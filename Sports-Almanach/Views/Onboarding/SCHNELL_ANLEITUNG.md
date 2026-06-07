# 🚀 Schnell-Anleitung - Wetten Problem beheben

## Das Problem
Die App zeigt: **"Wette nicht möglich - Keine Berechtigung für diese Aktion"**

## Die Lösung in 2 Schritten

### ✅ Schritt 1: Security Rules deployen (1 Minute) ⚠️ WICHTIGSTER SCHRITT!

1. **Öffne:** https://console.firebase.google.com/project/sports-almanach-55acf/firestore/rules

2. **Kopiere die NEUE `firestore.rules` Datei** (liegt im Projekt-Root)
   - **WICHTIG:** Die alte Version hatte `allow create`, die neue hat `allow write`!
   - Das ist der Unterschied zwischen funktionieren und nicht funktionieren!

3. **Ersetze ALLES** im Rules-Editor mit dem neuen Inhalt

4. **Klicke "Publish"** (oben rechts)

5. **Warte 10 Sekunden** bis die Rules aktiv sind

---

### ✅ Schritt 2: Testen (30 Sekunden)

1. **Starte die App neu** (komplett schließen und neu öffnen)

2. **Öffne Xcode Console** (⌘ + Shift + Y)

3. **Platziere eine Wette**

4. **Überprüfe die Logs:**
   ```
   ✅ [Betting] Successfully placed slip #1
   ```

5. **Überprüfe den Kontostand:**
   - Vorher: 3.500,00 €
   - Nachher: 3.000,00 € (bei 500 € Einsatz)

---

## ✅ Erfolgreich, wenn:

- ✅ Wettschein schließt sich automatisch
- ✅ Kontostand sinkt um den Einsatz
- ✅ Keine Fehlermeldung erscheint
- ✅ Console zeigt "Successfully placed slip"

---

## 🚨 Falls es nicht funktioniert

1. **Überprüfe den Index-Status:**
   - Firestore → Indexes → Status MUSS "Enabled" sein
   - Falls "Building": Warte noch 2 Minuten
   - Falls "Error": Lösche und erstelle neu

2. **Überprüfe die Collection-Namen:**
   - Firestore → Data
   - MUSS existieren: `Profile` (nicht `Profiles`)
   - MUSS existieren: `BetSlips` (genau diese Schreibweise!)

3. **Überprüfe Authentication:**
   - Firestore → Authentication → Users
   - Ein User muss existieren und eingeloggt sein

4. **Lies die vollständige Analyse:**
   - Siehe `WETTEN_FEHLERANALYSE.md` für Details

---

## 📞 Hilfe benötigt?

Kopiere die **Xcode Console Logs** und sende sie mir:
1. Öffne Console (⌘ + Shift + Y)
2. Suche nach `[Betting]` oder `ERROR`
3. Kopiere alle relevanten Zeilen
