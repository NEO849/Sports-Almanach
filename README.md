<table>
  <tr>
    <td>
      <img src="https://github.com/SI-Classroom-Batch-015/Sports-Almanach/blob/main/ios-marketing.png?raw=true" alt="Sports Almanach" width="120" />
    </td>
    <td>
      <h1>Sports Almanach</h1>
      <p><em>Senior-Elite Refactor · Layered architecture · Native iOS</em></p>
    </td>
  </tr>
</table>

A SwiftUI sports almanac with Firebase auth and play-money betting. Browse
fixtures from `thesportsdb.com`, mark events you care about, stake virtual
EUR on combo bets, and watch slips settle once matches finish.

## Screenshots

<table>
  <tr>
    <td align="center">
      <img src="Images/sportsA_splash_1.png" width="220" alt="Splash" /><br/>
      <sub><b>Splash</b></sub>
    </td>
    <td align="center">
      <img src="Images/sportsA_home_2.png" width="220" alt="Home" /><br/>
      <sub><b>Home</b></sub>
    </td>
    <td align="center">
      <img src="Images/sportsA_events_3.png" width="220" alt="Events" /><br/>
      <sub><b>Events</b></sub>
    </td>
  </tr>
  <tr>
    <td align="center">
      <img src="Images/sportsA_events-detail_4.png" width="220" alt="Event-Details" /><br/>
      <sub><b>Event-Details</b></sub>
    </td>
    <td align="center">
      <img src="Images/sportsA_bet_5.png" width="220" alt="Wetten" /><br/>
      <sub><b>Wetten</b></sub>
    </td>
    <td align="center">
      <img src="Images/sportsA_betslip_6.png" width="220" alt="Wettschein" /><br/>
      <sub><b>Wettschein</b></sub>
    </td>
  </tr>
</table>

## What this fork rebuilt

| Layer | Before | After |
|---|---|---|
| Money | `Double` for balance, stake, payout — accumulated drift | `Money` on `Decimal` with banker's rounding, currency-aware |
| Bet evaluation | Done at placement time → future matches always lost | `BetStatus.pending` until event finishes; `BettingService.settlePendingSlips(...)` resolves on app launch |
| Atomicity | Balance debited in fire-and-forget Task before slip save | Single Firestore transaction debits stake + writes slip |
| Auth state | `FirebaseAuthManager.shared.isUserSignedIn` snapshot Bool | `AppSession` with `AsyncStream<SportsAlmanachUser?>` |
| League routing | Hard-coded `id=4328` | `League.sportsDBLeagueID` picks EPL / Bundesliga / La Liga / Serie A / Ligue 1 |
| N+1 fetches | Each historic bet refetched the whole season | `EventSnapshot` embedded in `Bet` — zero refetch |
| Security | `GoogleService-Info.plist` committed, no Firestore rules | plist gitignored, `firestore.rules` with default-deny |
| UI | 6× duplicated `Image("hintergrund")`, custom orange RoundedRectangles, hard-coded 300×50 frames | `AppTheme` design tokens, `.appBackground()` modifier, Dynamic Type, dark mode, accessibility hints |

## Architecture

```
Sports-Almanach/
├── Sports_AlmanachApp.swift        # @main — wires AppContainer + AppSession + ViewModels
├── AppRoot/                        # Routing
│   ├── AppSession.swift            # ObservableObject driven by AuthService.userStream()
│   ├── RootView.swift              # Splash / Onboarding / MainTabView switch
│   └── MainTabView.swift           # Native iOS TabView
├── Core/
│   ├── AppConstants.swift          # Numeric + URL constants
│   ├── Money/Money.swift           # Decimal-backed monetary value
│   ├── DesignSystem/               # AppTheme + AppBackground
│   ├── DI/AppContainer.swift       # Composition root
│   ├── Logging/AppLogger.swift     # os.Logger categories
│   └── Concurrency/RetryPolicy.swift
├── Domain/
│   ├── Bet/                        # Bet, BetSlip, BetStatus, Outcome, OddsCalculator
│   ├── Event/                      # Event + EventStatus
│   └── Profile/                    # Profile + SportsAlmanachUser
├── Data/
│   ├── Auth/                       # AuthServiceProtocol + FirebaseAuthService
│   ├── Repositories/
│   │   ├── Protocols/              # *Protocol files — only thing ViewModels see
│   │   ├── EventRepository.swift   # SportsDB + Firestore user-events
│   │   ├── ProfileRepository.swift
│   │   └── BetRepository.swift     # Firestore transactions, no N+1
│   ├── Services/BettingService.swift
│   └── MockData/Mocks.swift
├── ViewModels/                     # UserViewModel, EventViewModel, BetViewModel
├── Views/                          # SwiftUI views
├── Enums/                          # League, Season, Sport, AppErrors, TabSelection
├── Utils/                          # ValidationUtils, SportEventUtils
└── Resources/                      # de.lproj, en.lproj
```

## Bet lifecycle

```
draft (UI)
    ↓ BetViewModel.placeSlip
[Firestore transaction]
    ├── debit balance from Profile/{uid}
    └── write BetSlips/{slipID} + bets sub-collection (status = .pending)
    ↓
slip lives in Firestore with .pending bets
    ↓ App launches OR pull-to-refresh
BettingService.settlePendingSlips(forUser:eventLookup:)
    ├── re-reads event score via EventRepository.fetchEvent(id:)
    ├── transitions each bet: .pending → .won / .lost / .void
    ├── slip status recomputed from bets
    └── credit balance with winAmount, atomically
```

## Getting started

```
git clone https://github.com/SI-Classroom-Batch-015/Sports-Almanach.git
cd Sports-Almanach
cp Sports-Almanach/GoogleService-Info.template.plist Sports-Almanach/GoogleService-Info.plist
# fill in the REPLACE_ME fields from your Firebase Console
open Sports-Almanach.xcodeproj
```

Then deploy the Firestore rules so the live database stops fail-open:

```
firebase login
firebase deploy --only firestore:rules
```

See `SECURITY.md` for the key-rotation runbook and App Check setup.

## Testing

```
xcodebuild test \
  -scheme Sports-Almanach \
  -destination 'platform=iOS Simulator,name=iPhone 15'
```

Unit tests under `Tests/Sports-AlmanachTests/` cover the pure layers:
`Money` arithmetic, `OddsCalculator`, `ValidationUtils`, and the
`BetSlip.recomputedStatus()` state machine. They don't need Firestore —
they run on the simulator with no auth.

## Tech stack

- **SwiftUI** (iOS 17+ recommended) — Dynamic Type, dark mode, Material
  backgrounds, ContentUnavailableView, ContentTransition.
- **Firebase Auth + Firestore** — auth state stream + transactions.
- **`thesportsdb.com` API** — public, free, no key required.
- **SwiftLint** — see `.swiftlint.yml`.

## Localisation

`Sports-Almanach/Resources/` ships German + English Localizable.strings.
Add a new language by duplicating one of the `.lproj` directories.

## License

CC0 1.0 Universal — see `LICENSE`.

## Contact

Michael F. J. · <f.michi84.989@gmail.com>
