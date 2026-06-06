# Firestore Security Rules - Wetten Problem beheben

## 🔴 Problem
Die Fehlermeldung "Missing or insufficient permissions" oder "The query requires an index" erscheint beim Versuch, eine Wette zu platzieren.

## ✅ Lösung - Zwei Schritte erforderlich

### Schritt 1: Firestore Security Rules deployen

1. Öffne die **Firebase Console**: https://console.firebase.google.com
2. Wähle dein Projekt "Sports-Almanach"
3. Navigiere zu **Firestore Database** → **Rules**
4. Kopiere den Inhalt der Datei `firestore.rules` und füge ihn in den Rules-Editor ein
5. Klicke auf **Publish** (Veröffentlichen)

### Schritt 2: Überprüfen der Authentifizierung

Stelle sicher, dass:
- Der User korrekt eingeloggt ist
- Die Firebase Authentication funktioniert
- Die User ID (`request.auth.uid`) mit der `userID` in den Dokumenten übereinstimmt

### Schritt 3: Firestore Indexes erstellen

Die App benötigt spezielle Indexes für die Wett-Queries.

**Automatische Methode (Empfohlen):**
1. Versuche, eine Wette zu platzieren
2. Wenn der Fehler "The query requires an index" erscheint, **klicke auf den Link** in der Fehlermeldung
3. Firebase öffnet sich automatisch mit der Index-Konfiguration
4. Klicke auf **"Index erstellen"** / **"Create Index"**
5. Warte 1-2 Minuten, bis der Status "Enabled" ist

**Manuelle Methode:**
1. Öffne die **Firebase Console**: https://console.firebase.google.com
2. Wähle dein Projekt "Sports-Almanach"
3. Navigiere zu **Firestore Database** → **Indexes**
4. Klicke auf **"Composite"** → **"Add Index"**
5. Erstelle folgende Indexes:

   **Index 1 - Für BetSlips laden:**
   - Collection: `BetSlips`
   - Fields:
     - `userID` (Ascending)
     - `slipNumber` (Descending)
   - Query Scope: Collection

   **Index 2 - Für Pending Slips:**
   - Collection: `BetSlips`
   - Fields:
     - `userID` (Ascending)
     - `status` (Ascending)
     - `slipNumber` (Descending)
   - Query Scope: Collection

6. Warte, bis beide Indexes den Status "Enabled" haben (1-2 Minuten)

### Schritt 4: Testen

Nachdem die Rules und Indexes deployed wurden:
1. Starte die App neu
2. Logge dich ein (oder aus und wieder ein)
3. Versuche erneut, eine Wette zu platzieren

## 📋 Was die neuen Rules machen

Die aktualisierten Firestore Security Rules erlauben:

✅ **Profile Collection**
- User können ihr eigenes Profil lesen und schreiben
- User können ihre eigenen Events verwalten

✅ **BetSlips Collection**
- User können ihre eigenen Wettscheine lesen
- User können neue Wettscheine für sich selbst erstellen
- User können ihre eigenen Wettscheine aktualisieren (für Settlement)
- User können Wetten in ihren eigenen Wettscheinen lesen und schreiben

❌ **Alles andere**
- Standardmäßig verboten (Security First!)

## 🐛 Debug-Logs

Die App loggt jetzt ausführliche Informationen beim Platzieren von Wetten:
- Aktueller Kontostand
- Versuchter Einsatz
- Firestore-Fehler mit Details

Öffne die **Console** in Xcode, um diese Logs zu sehen.

## 🔧 Weitere mögliche Probleme

Falls das Problem weiterhin besteht:

1. **User ist nicht authentifiziert**
   - Prüfe, ob `session.currentUser` nicht `nil` ist
   - Prüfe, ob Firebase Auth korrekt initialisiert wurde

2. **Falsche Collection-Namen**
   - Prüfe, ob die Collection-Namen in Firestore mit `AppConstants.FirestoreCollections` übereinstimmen
   - Profile vs Profiles
   - BetSlips vs betSlips

3. **User ID Mismatch**
   - Prüfe, ob die `userID` im Profil-Dokument mit `request.auth.uid` übereinstimmt

4. **Firestore nicht initialisiert**
   - Prüfe, ob `FirebaseApp.configure()` aufgerufen wurde
   - Prüfe, ob die `GoogleService-Info.plist` korrekt ist

## 📞 Support

Bei weiteren Fragen siehe die Firebase Console Logs:
Firebase Console → Firestore Database → Usage → Logs
