<table>
  <tr>
    <td>
      <img src="https://github.com/NEO849/Sports-Almanach/blob/main/sportalmanachklein.png?raw=true" alt="Sport Almanach Klein" width="150"/>
    </td>
    <td>
      <h1 style="color: #00b48a;">Sports-Almanach</h1>
    </td>
  </tr>
</table>

<br>

## ![Warum Sports-Almanach?](https://img.shields.io/badge/Warum%20Sports--Almanach-%2300b48a?style=for-the-badge&logo=none)

**Die App** ist ideal für Sportfans, die jederzeit aktuelle Informationen zu Sportarten und Events erhalten möchten. Mit der App kannst du:
- Informationen zu verschiedenen Sportevents abrufen.
- Wetten mit Spielgeld platzieren und dein Sportwissen testen.
- Von einer einfachen und intuitiven Navigation profitieren.

Die App zeichnet sich durch eine reibungslose Integration mit Firebase und eine aufgeräumte MVVM-Architektur aus. So wird Stabilität und einfache Erweiterbarkeit garantiert.

---

## ![Design](https://img.shields.io/badge/Design-%2300b48a?style=for-the-badge&logo=none)

Screenshots der App (Beispiel Images):


| ![Screenshot 1](https://github.com/NEO849/Sports-Almanach/blob/main/beispielscreenshot1.png?raw=true) | ![Screenshot 2](https://github.com/NEO849/Sports-Almanach/blob/main/beispielscreenshot2.png?raw=true) | ![Screenshot 3](https://github.com/NEO849/Sports-Almanach/blob/main/beispielscreenshot3.png?raw=true) |
|:---:|:---:|:---:|
| Erläuterung 1 | Erläuterung 2 | Erläuterung 3 |


<div>
  <img src="https://github.com/NEO849/Sports-Almanach/blob/main/beispielscreenshot1.png?raw=true" alt="Screenshot 1" width="15%" />
  <img src="https://github.com/NEO849/Sports-Almanach/blob/main/beispielscreenshot2.png?raw=true" alt="Screenshot 2" width="15%" />
  <img src="https://github.com/NEO849/Sports-Almanach/blob/main/beispielscreenshot3.png?raw=true" alt="Screenshot 3" width="15%" />
</div>

---

## ![Features](https://img.shields.io/badge/Features-%2300b48a?style=for-the-badge&logo=none)

- **Benutzeranmeldung**: Registriere dich und Melde dich an, um personalisierte Funktionen nutzen zu können.
- **Sportarten und Events**: Erhalte aktuelle Informationen zu verschiedenen Sportarten und Events.
- **Wettmöglichkeiten**: Platziere Wetten mit Spielgeld und teste dein Wissen über Sport.
- **Einfache Navigation**: Nutze Tabs für Home, Bet und Detail, um mühelos durch die App zu navigieren.
- **Jahres- und Liga-Auswahl**: Wähle ein Jahr und eine Liga aus, um relevante Fußball-Events anzuzeigen.
- **Event-Details**: Sieh dir detaillierte Informationen zu Events an, einschließlich Wettquoten, Team-Logos und Event-Status.
- **Event-Status**: Jeder Event-Status wird durch einen farbigen Kreis angezeigt (geplant, verschoben, gesperrt, abgesagt).

## ![Projektaufbau](https://img.shields.io/badge/Projektaufbau-%2300b48a?style=for-the-badge&logo=none)

Die App ist nach dem **MVVM-Muster** (Model-View-ViewModel) strukturiert.
Dies sorgt für eine klare Trennung der Logik und Benutzeroberfläche und erleichtert Wartung und Erweiterungen. 

- **Model**: Beinhaltet die Datenstrukturen für Events und Benutzer.
- **View**: Stellt die Benutzeroberfläche dar und zeigt die Events an.
- **ViewModel**: Handhabt die Logik zum Abrufen und Verarbeiten der Event-Daten. Verbindet die View mit den Model-Daten.

## ![Datenspeicherung](https://img.shields.io/badge/Datenspeicherung-%2300b48a?style=for-the-badge&logo=none)

**Firebase** wird für die Authentifizierung der Benutzer und die Speicherung von Wettinformationen verwendet. Firebase bietet zuverlässige Echtzeit-Synchronisierung.

## ![API Calls](https://img.shields.io/badge/API%20Calls-%2300b48a?style=for-the-badge&logo=none)

Die App nutzt externe APIs, um Live-Daten zu Sportereignissen abzurufen und Wettquoten in Echtzeit anzuzeigen:
    
<table>
  <tr>
    <th>Sportdaten API</th>
  </tr>
  <tr>
    <td>Abrufen von Event-Daten basierend auf Jahr und Liga.</td>
  </tr>
  <tr>
    <td>
      <b>Beispiel-URL</b>: https://www.thesportsdb.com/api/v1/json/3/eventsseason.php?id=&lt;LeagueID&gt;&amp;s=&lt;Season&gt;
    </td>
  </tr>
  <tr>
    <td>
      <b>Parameter</b>:
      <ul>
        <li><b>id</b>: Liga-ID</li>
        <li><b>s</b>: Saison im Format Jahr-Jahr</li>
      </ul>
    </td>
  </tr>
</table>
     

### ![3rd-Party Frameworks](https://img.shields.io/badge/3rd--Party%20Frameworks-%2300b48a?style=for-the-badge&logo=none)

- **Firebase**: Für Authentifizierung, Datenbanken und Crashlytics.
- **SwiftUI**: Für das UI-Design und die Darstellung der Benutzeroberfläche.

---

## ![Ausblick](https://img.shields.io/badge/Ausblick-%2300b48a?style=for-the-badge&logo=none)

In Zukunft möchten ich folgende Features hinzufügen, um die App weiter zu verbessern:

- **Live-Benachrichtigungen** über Sportereignisse und Wettmöglichkeiten.
- **Erweiterte Statistiken** zu Sportarten und Spielern.
- **Personalisierte Wettvorschläge** basierend auf KI ausgewerteten Daten.

---

## ![Installation](https://img.shields.io/badge/Installation-%2300b48a?style=for-the-badge&logo=none)

1. Klone das Repository:

```   
git clone https://github.com/NEO849/Sports-Almanach.git
```

2. Öffne das Projekt in Xcode:

```  
open Sports-Almanach.xcodeproj
```
---

## ![Verwendung](https://img.shields.io/badge/Verwendung-%2300b48a?style=for-the-badge&logo=none)

- Starte die App und registriere dich, anschliessend wirst du zur HomeVie weitergeleitet.
- Navigiere über die Tabs zwischen Home, Bet und Detail.
- Informiere dich über Sportereignisse und platziere Wetten.   

---

## ![Lizenz](https://img.shields.io/badge/Lizenz-%2300b48a?style=for-the-badge&logo=none)

- Dieses Projekt ist unter der [MIT-Lizenz](https://github.com/NEO849/Sports-Almanach/tree/main#) lizenziert. Siehe die LICENSE Datei für weitere Details.     

---

## ![Kontakt](https://img.shields.io/badge/Kontakt-%2300b48a?style=for-the-badge&logo=none)

Für Fragen oder Anmerkungen kannst du mich unter f.michi84.989@gmail.com erreichen.

---

Viel Spaß beim Nutzen der App und beim Wetten mit Spielgeld!
