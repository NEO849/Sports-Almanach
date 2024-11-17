<table>
  <tr>   
    <td>
      <!-- Bild-Tag für "Sport Almanach Klein" -->
      <img src="https://github.com/SI-Classroom-Batch-015/Sports-Almanach/blob/main/ios-marketing.png?raw=true" alt="Sport Almanach Klein" width="150" />
    </td>
    <td>
      <h1 style="color: #00b48a;">Sports-Almanach</h1>
    </td>
  </tr>
</table>

<br>

## ![Warum Sports-Almanach?](https://img.shields.io/badge/Warum%20Sports--Almanach-%23FFA500?style=for-the-badge&logo=none)

**Die App** ist ideal für Sportfans, die jederzeit Informationen zu Sportarten und Events erhalten möchten. Mit der App kannst du:
- Informationen zu verschiedenen Sportevents abrufen.
- Wetten mit Spielgeld platzieren und dein Sportwissen testen.
- Von einer einfachen und intuitiven Navigation profitieren.

**Die App zeichnet sich durch eine reibungslose Integration mit Firebase und eine aufgeräumte MVVM-Architektur aus. Die Stabilität und einfache Erweiterbarkeit garantiert.**

---

## ![Design](https://img.shields.io/badge/Design-%23FFA500?style=for-the-badge&logo=none)

Screenshots der App:

<div>
  <img src="https://github.com/SI-Classroom-Batch-015/Sports-Almanach/blob/main/HomeView.png?raw=true" alt="Screenshot 3" width="15%" />
  <img src="https://github.com/SI-Classroom-Batch-015/Sports-Almanach/blob/main/EventView.png?raw=true" alt="Screenshot 2" width="15%" />
  <img src="https://github.com/SI-Classroom-Batch-015/Sports-Almanach/blob/main/Event-DetailView.png?raw=true" alt="Screenshot 3" width="15%" />
  <img src="https://github.com/SI-Classroom-Batch-015/Sports-Almanach/blob/main/BetView.png?raw=true" alt="Screenshot 3" width="15%" />
  <img src="https://github.com/SI-Classroom-Batch-015/Sports-Almanach/blob/main/BetSlipView.png?raw=true" alt="Screenshot 3" width="15%" />
</div>

---

## ![Features](https://img.shields.io/badge/Features-%23FFA500?style=for-the-badge&logo=none)

- **Sportarten und Events**: Erhalte aktuelle Informationen zu verschiedenen Sportarten und Events.
- **Wettmöglichkeiten**: Platziere Wetten mit Spielgeld und teste dein Wissen über Sport.
- **Einfache Navigation**: Nutze Tabs für Home, Bet und Detail, um mühelos durch die App zu navigieren.
- **Jahres- und Liga-Auswahl**: Wähle ein Jahr und eine Liga aus, um relevante Fußball-Events anzuzeigen.
- **Event-Details**: Sieh dir detaillierte Informationen zu Events an, einschließlich Wettquoten, Team-Logos und Event-Status.
- **Event-Status**: Jeder Event-Status wird Farbigen angezeigt (geplant, verschoben, gesperrt, abgesagt).
- **OddsCalculator**: Lediglich durch die gefallenen Tore im Spiel, werden Wettquoten berechnet, unter Berücksichtigung verschiedenener Faktoren, wie Heimspiel, oder Auswärtsspiel.
- **Wetten**: Teste dein Wissen mit Spielgeld Wetten. In den Wettscheinen kannst du dann die Höhe  des Einsatzes samt Wette abgeben und dich bei einem Gewinn Feiern.
- **Statistiken**: Sieh dir deine Wettscheine an , oder ob du bereits die Nummer 1 der Weltrrangliste bist und Messe dich mit deinen Freunden.

## ![Projektaufbau](https://img.shields.io/badge/Projektaufbau-%23FFA500?style=for-the-badge&logo=none)

Die App ist nach dem **MVVM-Muster** (Model-View-ViewModel) strukturiert. Dies sorgt für eine klare Trennung der Logik und Benutzeroberfläche und erleichtert Wartung und Erweiterungen. 
Besonders vorteilhaft ist dies beim Testen der App mit **Mock-Daten** wie User, Events und Wettquoten. 

## ![Projektstruktur](https://img.shields.io/badge/Projektstruktur-%23FFA500?style=for-the-badge&logo=none)

- **Model**: Enthält die Datenstrukturen für Events, Benutzer und Wettinformationen. 
- **View**: Stellt die Benutzeroberfläche dar und zeigt die Events an.
- **ViewModel**: Verbindet die View mit dem Model, enthält die Logik zum Abrufen und Verarbeiten von Daten. (Über das **Repository**-Muster, Remote-API oder Mock-Daten abwickeln.

- **Repository**: 
  - Die **Repository-Schicht** dient als zentrale Stelle, um Daten zu beziehen. Es agiert als Schnittstelle zwischen dem ViewModel und den eigentlichen Datenquellen (wie APIs oder lokalen Datenbanken/Mockdaten).

- **Mock-Daten**:
  - In der frühen Entwicklungsphase nutze ich die Mock-Daten, die das tatsächliche Verhalten der App simulieren. Dies ist ideal, um UI-Elemente zu überprüfen oder Logik zu testen.
  - In der frühen Phase konnte einfach durch ändern einer var von `true`auf `false`zwischen Mock-und API Daten gewechselt werden. 

## ![Datenspeicherung](https://img.shields.io/badge/Datenspeicherung-%23FFA500?style=for-the-badge&logo=none)

**Firebase** wird für die Authentifizierung der Benutzer und die Speicherung von Wettinformationen verwendet. 
**Firestore** wird genutzt damit die ausgewählten Events beim Anmelden wieder erscheinen und speichert die Wettscheine. 

## ![API Calls](https://img.shields.io/badge/API%20Calls-%23FFA500?style=for-the-badge&logo=none)

Die App nutzt externe APIs, um Daten zu Sportereignissen abzurufen und anzuzeigen:
    
<table>
  <tr>
    <th>Sportdaten API</th>
  </tr>
  <tr>
    <td>Abrufen von Event-Daten basierend auf Jahr und Liga.</td>
  </tr>
  <tr>
    <td>
      <b>Parameter</b>:
      <ul>
        <li><b>id</b>: Liga-ID (z.B. 4734)</li>
        <li><b>s</b>: Saison im Format Jahr-Jahr (z.B. 2020-2021)</li>
      </ul>
    </td>
  </tr>
  <tr>
    <td>
      <b>Beispiel-URL für die Saison 2020-2021</b>: https://www.thesportsdb.com/api/v1/json/3/eventsseason.php?id=4734&s=2020-2021
    </td>
  </tr>
  <tr>
    <td>
      <b>Weitere Endpunkte</b>:
      <ul>
        <li><b>Beispiel-URL für alle Ligen im Fußball</b>: https://www.thesportsdb.com/api/v1/json/3/search_all_leagues.php?s=Soccer</li>
      </ul>
    </td>
  </tr>
</table>
     

### ![3rd-Party Frameworks](https://img.shields.io/badge/3rd--Party%20Frameworks-%23FFA500?style=for-the-badge&logo=none)

- **Firebas und Storee**: Für Authentifizierung, Datenbanken und Crashlytics.
- **SwiftUI**: Für das UI-Design und die Darstellung der Benutzeroberfläche.

---

## ![Ausblick](https://img.shields.io/badge/Ausblick-%23FFA500?style=for-the-badge&logo=none)

In Zukunft möchten ich folgende Features hinzufügen, um die App weiter zu verbessern:

- **Live-Benachrichtigungen** über Sportereignisse und Wettmöglichkeiten.
- **Erweiterte Statistiken** zu Sportarten und Spielern.
- **Personalisierte Wettvorschläge** basierend auf KI ausgewerteten Daten.

---

## ![Installation](https://img.shields.io/badge/Installation-%23FFA500?style=for-the-badge&logo=none)

1. Klone das Repository:

```   
git clone https://github.com/NEO849/Sports-Almanach.git
```

2. Öffne das Projekt in Xcode:

```  
open Sports-Almanach.xcodeproj
```
---

## ![Verwendung](https://img.shields.io/badge/Verwendung-%23FFA500?style=for-the-badge&logo=none)

- Starte die App und registriere dich, melde dich an und anschliessend wirst du zur HomeView weitergeleitet.
- Navigiere über die Tabs zwischen Home, Bet und Detail.
- Informiere dich über Sportereignisse und platziere Wetten.   

---

## ![Lizenz](https://img.shields.io/badge/Lizenz-%23FFA500?style=for-the-badge&logo=none)

- Dieses Projekt ist unter der [CC0 1.0 Universal (CC0 1.0)](https://github.com/NEO849/Sports-Almanach/tree/main#) lizenziert. Siehe die LICENSE Datei für weitere Details.     

---

## ![Kontakt](https://img.shields.io/badge/Kontakt-%23FFA500?style=for-the-badge&logo=none)

Für Fragen, Feedback oder Anmerkungen kannst du mich unter f.michi84.989@gmail.com erreichen.

---

Viel Spaß beim Nutzen der App, erweitern deines Sportwissens und beim Wetten mit Spielgeld!

**Euer  AI-Data-F3 Team**
