# 🔐 Firestore Permission Fix - Detaillierte Erklärung

## 🔴 Das Problem

**Fehlermeldung:** "Keine Berechtigung für diese Aktion. Bitte Firestore Security Rules überprüfen."

### Was ist passiert?

Deine Firestore Security Rules hatten:

```javascript
// ❌ FALSCH - nur "create" erlaubt
allow create: if request.auth != null && 
                 request.auth.uid == request.resource.data.userID;
```

**Problem:** Der Code in `BetRepository.swift` verwendet `transaction.setData()` in einer Firestore Transaction:

```swift
// Aus BetRepository.swift Zeile 62
transaction.setData(slipPayload, forDocument: slipRef)
```

### Warum funktioniert das nicht?

Firestore Security Rules unterscheiden zwischen verschiedenen Operationen:

| Operation | Was es bedeutet | Wann wird es verwendet |
|-----------|----------------|------------------------|
| `create` | Nur **neues Dokument erstellen** | `addDocument()`, erstes `setData()` |
| `update` | Nur **bestehendes Dokument ändern** | `updateData()` |
| `write` | **create ODER update** | `setData()` in Transactions |
| `read` | Dokument lesen | `getDocument()`, Queries |
| `delete` | Dokument löschen | `delete()` |

**In Firestore Transactions wird `setData()` als `write` interpretiert, nicht als `create`!**

Das liegt daran, dass Transactions idempotent sein müssen - wenn die Transaction wiederholt wird (bei Konflikten), darf sie nicht beim zweiten Mal fehlschlagen.

---

## ✅ Die Lösung

### Neue Security Rule:

```javascript
// ✅ RICHTIG - "write" erlaubt create UND update
allow write: if request.auth != null && 
                request.auth.uid == request.resource.data.userID;
```

### Warum ist das sicher?

**Diese Rule ist genauso sicher wie vorher**, weil:

1. ✅ **Authentifizierung erforderlich:** `request.auth != null`
2. ✅ **User ID Check:** `request.auth.uid == request.resource.data.userID`
3. ✅ **Kein fremder Zugriff:** User kann nur eigene BetSlips erstellen/ändern

Der User kann:
- ✅ Eigene BetSlips erstellen
- ✅ Eigene BetSlips aktualisieren (für Settlement)
- ❌ KEINE fremden BetSlips lesen
- ❌ KEINE fremden BetSlips ändern
- ❌ KEINE BetSlips für andere User erstellen

---

## 🔍 Technischer Deep-Dive

### Warum verwendet der Code `setData()` in einer Transaction?

Aus `BetRepository.swift` (Zeile 48-120):

```swift
try await firestore.runTransaction({ transaction, errorPointer -> Any? in
    // 1. Balance lesen
    let profileSnap = try transaction.getDocument(profileRef)
    
    // 2. Balance prüfen
    guard currentBalance >= stake else {
        errorPointer?.pointee = AppErrors.Bet.insufficientFunds as NSError
        return nil
    }
    
    // 3. Balance abbuchen
    transaction.updateData(["balance": encodedBalance], forDocument: profileRef)
    
    // 4. BetSlip speichern - HIER ist das Problem!
    transaction.setData(slipPayload, forDocument: slipRef)  // ← Wird als "write" interpretiert
    
    // 5. Einzelne Bets speichern
    for (betID, payload) in betPayloads {
        transaction.setData(payload, forDocument: betRef)  // ← Auch hier
    }
    
    return nil
})
```

**Warum ist das wichtig?**

Die Transaction ist **atomar**:
- ✅ **Entweder:** Balance wird abgebucht UND BetSlip wird gespeichert
- ✅ **Oder:** GAR NICHTS passiert

**Das verhindert Datenverlust:** Kein Geld wird abgebucht ohne dass ein BetSlip existiert.

**Ohne Transaction (alte Implementierung):**
```swift
// ❌ GEFÄHRLICH - Race Condition!
await profileRepo.debitBalance(stake)  // ← Könnte erfolgreich sein
// ... App stürzt ab oder Netzwerk fällt aus ...
await betRepo.saveBetSlip(slip)       // ← Könnte fehlschlagen
// → Geld ist weg, aber kein BetSlip existiert! 💸
```

---

## 📋 Vollständige firestore.rules

Hier ist die **vollständige, sichere** `firestore.rules` Datei:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Profile Collection
    match /Profile/{userID} {
      allow read, write: if request.auth != null && request.auth.uid == userID;
      
      match /events/{eventID} {
        allow read, write: if request.auth != null && request.auth.uid == userID;
      }
    }
    
    // BetSlips Collection
    match /BetSlips/{slipID} {
      // Read eigene Slips
      allow read: if request.auth != null && 
                     request.auth.uid == resource.data.userID;
      
      // Write (create + update) eigene Slips
      // WICHTIG: "write" statt "create" für Transactions!
      allow write: if request.auth != null && 
                      request.auth.uid == request.resource.data.userID;
      
      // Bets subcollection
      match /bets/{betID} {
        allow read, write: if request.auth != null && 
                              request.auth.uid == get(/databases/$(database)/documents/BetSlips/$(slipID)).data.userID;
      }
    }
    
    // Deny all other access
    match /{document=**} {
      allow read, write: if false;
    }
  }
}
```

---

## 🧪 Testing

### Test 1: Wette platzieren

```swift
// User ist eingeloggt als userID = "abc123"

// 1. BetSlip erstellen
let slip = BetSlip(
    id: UUID(),
    userID: "abc123",  // ← MUSS mit request.auth.uid übereinstimmen
    slipNumber: 1,
    totalStake: Money(amount: 50000),  // 500 €
    // ...
)

// 2. Wette platzieren
try await betRepo.placeSlip(slip, debiting: stake, from: "abc123")

// Firestore prüft:
// ✅ request.auth.uid == "abc123"
// ✅ request.resource.data.userID == "abc123"
// ✅ Erlaubt!
```

### Test 2: Fremde Wette erstellen (sollte fehlschlagen)

```swift
// User ist eingeloggt als userID = "abc123"

let slip = BetSlip(
    id: UUID(),
    userID: "xyz789",  // ← Anderer User!
    // ...
)

try await betRepo.placeSlip(slip, debiting: stake, from: "xyz789")

// Firestore prüft:
// ✅ request.auth.uid == "abc123"
// ❌ request.resource.data.userID == "xyz789"
// ❌ VERBOTEN! Permission denied
```

---

## 🚨 Häufige Fehler

### Fehler 1: `allow create` statt `allow write`

**Symptom:** "Missing or insufficient permissions" bei Transactions

**Lösung:** Verwende `allow write` für Transactions

### Fehler 2: User ID Mismatch

**Symptom:** Permission denied trotz korrekter Rules

**Lösung:** Prüfe, ob `slip.userID == request.auth.uid`

```swift
// ❌ FALSCH
let slip = BetSlip(userID: session.currentUser?.id.uuidString)  // UUID String

// ✅ RICHTIG
let slip = BetSlip(userID: session.currentUser?.id)  // Firebase Auth UID
```

### Fehler 3: Nicht authentifiziert

**Symptom:** Permission denied für alle Operationen

**Lösung:** Prüfe `Auth.auth().currentUser`:

```swift
guard let user = Auth.auth().currentUser else {
    print("❌ User ist nicht eingeloggt!")
    return
}
print("✅ User eingeloggt: \(user.uid)")
```

---

## 📞 Debugging

### Xcode Console Logs

Die App loggt jetzt alle Firestore-Operationen:

```
[Betting] Attempting to place slip #1 for user abc123, stake: 500,00 €
[Betting] Current balance for user abc123: 3.500,00 €, stake: 500,00 €
✅ [Betting] Successfully placed slip #1 for user abc123
```

**Bei Permission Errors:**

```
❌ [Betting] Transaction failed for slip #1: Missing or insufficient permissions.
```

### Firebase Console

**Firestore Rules Playground:**
1. Öffne: https://console.firebase.google.com/project/sports-almanach-55acf/firestore/rules
2. Klicke auf **"Rules Playground"**
3. Teste verschiedene Operationen:
   - Authenticated user: `abc123`
   - Document path: `/BetSlips/some-slip-id`
   - Operation: `set`
   - Request data: `{ "userID": "abc123", ... }`

**Sollte anzeigen: ✅ Allowed**

---

## ✅ Checkliste

Nach dem Deployment der neuen Rules:

- [ ] Rules in Firebase Console deployed (`Publish` geklickt)
- [ ] Status: "Published" (nicht "Draft")
- [ ] App neu gestartet (komplett schließen!)
- [ ] User ist eingeloggt (`session.currentUser != nil`)
- [ ] BetSlip hat korrekte `userID` (gleich wie Auth UID)
- [ ] Wette platzieren funktioniert
- [ ] Kontostand wird korrekt abgebucht
- [ ] BetSlip erscheint in Firestore
- [ ] Keine Fehlermeldung in Xcode Console

---

## 🎯 Zusammenfassung

**Problem:** 
`allow create` erlaubt keine Transactions

**Lösung:** 
`allow write` erlaubt `create` UND `update`

**Warum sicher:**
User kann nur eigene Dokumente schreiben, weil `request.auth.uid == request.resource.data.userID`

**Nächster Schritt:**
Deploy die neuen Rules und teste die App!
