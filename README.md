# Welcome To The Roof — booking app prototype

A rooftop **pickup-soccer booking app** ("Welcome To The Roof", Dallas). This is a
clickable, fully-wired prototype built in **Flutter** with **mock data** behind an
async service layer that's structured so a real backend can be dropped in later.

> Built strictly to the provided design system: **monochrome** (black / white / gray,
> no accent color), rounded geometric sans, pill buttons, black header blocks, 5-tab
> bottom bar (Home · Book · Buy · Profile · More).

---

## What's included

All five reference screens, plus the screens needed to make the flow complete and
consistent:

| Screen | Notes |
|---|---|
| **Home** (Screen 4) | Black flat header ("Welcome to / Dallas"), info card, "Coming up" list, Book CTA |
| **Book** (Screen 5) | Location header, 7-day selector (Aug 10–16), session list with **loading skeleton**, pull-to-refresh |
| **Enable Notifications** (Screen 3) | Bottom-sheet modal with grabber, Okay / Dismiss |
| **Profile** (Screen 1) | Signed-out: curved header + avatar cutout + Sign in / Create account. Signed-in: account, plan, **My bookings**, settings |
| **More** (Screen 2) | Flat header, menu list, auth buttons, gray fill |
| **Session detail** *(new)* | Session info, capacity bar, venue, Book flow → confirmation |
| **Booking confirmation** *(new)* | Success state with summary + "Done" |
| **Sign in / Create account** *(new)* | Mock auth (any login resolves to the demo member) |
| **Location picker** *(new)* | Switch city (Dallas / Austin / Houston / Fort Worth) |
| **Buy** *(new)* | Membership plans (Drop-In / Rooftop Unlimited / 10-Pack) |
| **Notifications** *(new)* | Feed loaded from the API |
| **Settings** *(new)* | **Dark-mode toggle**, notifications, account |

Cross-cutting: a **dark mode** (clean monochrome inversion) toggled from Settings,
and **loading skeletons** on every async screen.

---

## Design system

- **Palette:** `#000000` ink, `#FFFFFF` paper, `#F5F5F5` canvas, `#EFEFF1` skeleton,
  `#8E8E93` muted, `#E5E5EA` divider — no accent. Dark mode inverts these.
- **Type:** rounded geometric sans (set `fontFamily: 'Poppins'` once you add the font
  files — see below).
- **Shapes:** pill buttons, 12–20px cards, circular badges/date-pickers, one curved
  header (Profile).
- All tokens live in `lib/theme/wtr_theme.dart` (`WtrPalette`); resolve via
  `paletteOf(context)`.

---

## Run it

You need the **Flutter SDK** (≥ 3.10). The repo ships source + `pubspec.yaml` only —
the platform folders are generated on your machine (and gitignored).

```bash
# 1. one-time: generate the platform scaffolding (web for Chrome)
flutter create . --project-name welcome_to_the_roof --platforms web

# 2. get dependencies (none are third-party, so this is instant)
flutter pub get

# 3. run in Chrome
flutter run -d chrome
```

> Windows from-scratch? See **`SETUP_WINDOWS.md`** for a step-by-step.

### Optional: match the Poppins typeface
The design references Poppins. To use it:
1. Drop `Poppins-{Regular,Medium,SemiBold,Bold}.ttf` into `assets/fonts/`.
2. Uncomment the `fonts:` block in `pubspec.yaml`.
3. Uncomment `fontFamily: 'Poppins'` in `lib/theme/wtr_theme.dart`.

Without it, the app uses the system sans — everything else still matches the spec.

---

## Demo account & mock data

- The app opens **signed out** (Home/Profile/More reflect that).
- **Sign in** with any email + password (e.g. the pre-filled `alex@example.com` /
  `password`) → signs in as the demo member **Alex Rivera** (Rooftop Unlimited).
- The "today" used by the Book screen is anchored to **Mon, Aug 10 2026** so the date
  selector shows 10–16 with "10" = Today (matching the reference).
- Bookings you make live in memory for the session (no persistence yet).

---

## Architecture — ready for a backend

```
lib/
  services/booking_api.dart   ← THE swap point. Replace the mock bodies with real HTTP.
  services/app_session.dart   ← ChangeNotifier: auth, city, bookings, theme
  data/mock_data.dart         ← seed data (delete once the API is real)
  models/                     ← DTOs (CityLocation, SessionSlot, Booking, …)
  theme/  widgets/  screens/  nav/
```

Every screen reads data through `BookingApi` (via `app_session.dart`), never touching
`MockData` directly. Each method returns a `Future` with a small artificial delay so
the loading skeletons exercise naturally. **To go live:** keep the method signatures,
swap the bodies for `dio`/`http` calls to your booking backend, delete `mock_data.dart`.
