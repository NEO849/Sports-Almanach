# Sports-Almanach <img src="https://github.com/NEO849/Sports-Almanach/blob/main/sportalmanachklein.png?raw=true" alt="Sport Almanach Klein" align="right" width="150"/>
## Bet & Infos

**Der Sportwetten-Begleiter für alle Fans.**

**Sports-Almanach** bietet dir umfassende Informationen zu aktuellen Sportereignissen und ermöglicht dir, Wetten mit Spielgeld abzuschließen. Bleib immer auf dem Laufenden und teste dein Wissen in der Welt des Sports.

---

## Warum Sports-Almanach?

**Sports-Almanach** ist ideal für Sportfans, die jederzeit aktuelle Informationen zu Sportarten und Events erhalten möchten. Mit der App kannst du:
- Die neuesten Informationen zu Sportevents abrufen.
- Wetten mit Spielgeld platzieren und dein Sportwissen testen.
- Von einer einfachen und intuitiven Navigation profitieren.

Die App zeichnet sich durch eine reibungslose Integration mit Firebase und eine aufgeräumte MVVM-Architektur aus. So wird Stabilität und einfache Erweiterbarkeit garantiert.

---

## Design

Screenshots der App:

<div>
  <img src="https://github.com/NEO849/Sports-Almanach/blob/main/screenshots/screenshot1.png?raw=true" alt="Screenshot 1" width="30%" />
  <img src="https://github.com/NEO849/Sports-Almanach/blob/main/screenshots/screenshot2.png?raw=true" alt="Screenshot 2" width="30%" />
  <img src="https://github.com/NEO849/Sports-Almanach/blob/main/screenshots/screenshot3.png?raw=true" alt="Screenshot 3" width="30%" />
</div>

---

## Features

- **Benutzeranmeldung**: Melde dich an oder registriere dich, um personalisierte Funktionen nutzen zu können.
- **Sportarten und Events**: Erhalte aktuelle Informationen zu verschiedenen Sportarten und Events.
- **Wettmöglichkeiten**: Platziere Wetten mit Spielgeld und teste dein Wissen über Sport.
- **Einfache Navigation**: Nutze Tabs für Home, Bet und Detail, um mühelos durch die App zu navigieren.
- **Jahres- und Liga-Auswahl**: Wähle ein Jahr und eine Liga aus, um relevante Fußball-Events anzuzeigen.
- **Event-Details**: Sieh dir detaillierte Informationen zu Events an, einschließlich Wettquoten, Team-Logos und Event-Status.
- **Event-Status**: Jeder Event-Status wird durch einen farbigen Kreis angezeigt (geplant, verschoben, gesperrt, abgesagt).

## Projektaufbau

Die App ist nach dem **MVVM-Muster** (Model-View-ViewModel) strukturiert.
Dies sorgt für eine klare Trennung der Logik und Benutzeroberfläche und erleichtert Wartung und Erweiterungen. 

- **Model**: Beinhaltet die Datenstrukturen für Events und Benutzer.
- **View**: Stellt die Benutzeroberfläche dar und zeigt die Events an.
- **ViewModel**: Handhabt die Logik zum Abrufen und Verarbeiten der Event-Daten. Verbindet die View mit den Model-Daten.

## Datenspeicherung

**Firebase** wird für die Authentifizierung der Benutzer und die Speicherung von Wettinformationen verwendet. Firebase bietet zuverlässige Echtzeit-Synchronisierung.

## API Calls

Die App nutzt externe APIs, um Live-Daten zu Sportereignissen abzurufen und Wettquoten in Echtzeit anzuzeigen:

- **Sportdaten API**: Abrufen von Event-Daten basierend auf Jahr und Liga.
   - **Beispiel-URL**: https://www.thesportsdb.com/api/v1/json/3/eventsseason.php?id=<LeagueID>&s=<Season>
   - **Parameter**:
      - **id**: Liga-ID
      - **s**: Saison im Format Jahr-Jahr

### 3rd-Party Frameworks

- **Firebase**: Für Authentifizierung, Datenbanken und Crashlytics.
- **SwiftUI**: Für das UI-Design und die Darstellung der Benutzeroberfläche.

---

## Ausblick

In Zukunft möchten ich folgende Features hinzufügen, um die App weiter zu verbessern:

- **Live-Benachrichtigungen** über Sportereignisse und Wettmöglichkeiten.
- **Erweiterte Statistiken** zu Sportarten und Spielern.
- **Personalisierte Wettvorschläge** basierend auf KI ausgewerteten Daten.

---

## Installation

1. Klone das Repository:
   ```
   git clone https://github.com/NEO849/Sports-Almanach.git
   ```
2. Öffne das Projekt in Xcode:
   ```
   open Sports-Almanach.xcodeproj
   ```

---

## Verwendung

- Starte die App und registriere dich, anschliessend wirst du zur HomeVie weitergeleitet.
- Navigiere über die Tabs zwischen Home, Bet und Detail.
- Informiere dich über Sportereignisse und platziere Wetten.   

---

## Lizenz

- Dieses Projekt ist unter der [MIT-Lizenz](https://github.com/NEO849/Sports-Almanach/tree/main#) lizenziert. Siehe die LICENSE Datei für weitere Details.     

---

## Kontakt

Für Fragen oder Anmerkungen kannst du mich unter f.michi84.989@gmail.com erreichen.

---

Viel Spaß beim Nutzen der App und beim Wetten mit Spielgeld!
