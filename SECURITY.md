# Security & Setup Notes

This document captures the security-sensitive steps that the senior-elite
refactor introduced. The legacy repo committed the Firebase configuration
file with API keys; if you forked or cloned the legacy commit, **rotate the
API key in the Firebase Console** before continuing.

## Files NOT to commit

- `Sports-Almanach/GoogleService-Info.plist` — gitignored. Use the template:
  ```
  cp Sports-Almanach/GoogleService-Info.template.plist Sports-Almanach/GoogleService-Info.plist
  ```
  Then fill in your own values from
  Firebase Console → Project Settings → General → Your apps → iOS.

## After installing dependencies

1. Deploy Firestore security rules:
   ```
   firebase login
   firebase deploy --only firestore:rules
   ```
   The rules enforce that:
   - profile reads/writes belong to the authenticated owner
   - bet slip reads/writes belong to the authenticated owner
   - everything else is denied by default

2. Enable **App Check** in the Firebase Console
   (Build → App Check → Apps → register the iOS app with App Attest).
   App Check is recommended to limit API-key abuse from cloned apps.

3. In the Firebase Console:
   - **Authentication → Sign-in method**: enable Email/Password.
   - **Firestore → Indexes**: deploy via `firebase deploy --only firestore:indexes`
     once you add `firestore.indexes.json` (not strictly required for current
     queries — they only use `whereField` + `orderBy` on indexed fields).

## Rotating a leaked key

If the legacy `GoogleService-Info.plist` (committed at
`Sports-Almanach/GoogleService-Info.plist` until this refactor) was visible
in a public branch you do not control, treat the key as compromised:

1. Firebase Console → Project Settings → General → Your apps → iOS → **delete the app**.
2. **Add a new iOS app** with the same bundle ID. A fresh `GOOGLE_APP_ID`
   and `API_KEY` are issued.
3. Download the new `GoogleService-Info.plist` and place it locally.
4. Force-push only the cleanup commit (the file remains in history of the
   forked repository).

## What changed in the rules

The new `firestore.rules` introduces a default-deny rule on `{document=**}`,
so any new collection you add will require explicit allow logic — fail-safe by
construction, opposite of the legacy "no rules" posture which was fail-open.
