# How to run "Welcome To The Roof" on your Windows PC (from absolute zero)

You know nothing about Flutter — that's fine. This runs with a handful of
copy-paste commands. **5 steps total.**

---

## Step 1 — Install the Flutter SDK (one-time)

1. Go to **https://docs.flutter.dev/get-started/install/windows**
2. Download the **Flutter SDK** zip (~1 GB, a few minutes).
3. Unzip it somewhere simple like `C:\flutter` (avoid spaces in the path).
4. Add its `bin` folder to your PATH:
   - Press `Win`, type **"env"**, click **"Edit the system environment variables"**.
   - Click **"Environment Variables…"**.
   - Under **"User variables"**, select **`Path`** → **Edit** → **New** → add:
     `C:\flutter\bin`
   - OK on every window.
5. **Close and reopen** your terminal so the change takes effect.

---

## Step 2 — Check the install

Open **Command Prompt** (`Win` → `cmd` → Enter) and run:

```
flutter doctor
```

A check mark next to **Chrome** means you're good to run in the browser.

---

## Step 3 — Put the app into your folder

**Option A — Download ZIP (easiest):**
1. Go to **https://github.com/im-oree/MFT-Stub-**
2. **Code** → **Download ZIP** → extract into your dev folder.
3. Open the `MFT-Stub-` folder in a terminal:
   ```
   cd C:\your\dev\folder\MFT-Stub-
   ```

**Option B — Git clone:**
```
cd C:\your\dev\folder
git clone https://github.com/im-oree/MFT-Stub-.git
cd MFT-Stub-
```

You should now be **inside the project folder** (the one containing `pubspec.yaml`).

---

## Step 4 — Generate the platform files + dependencies

Your terminal must be inside the project folder. Run:

```
flutter create . --project-name welcome_to_the_roof --platforms web
flutter pub get
```

- `flutter create .` writes the missing `web/` (and other) platform folders from the
  template. It will **not** overwrite any of the existing app code.
- `flutter pub get` downloads dependencies. There are **no third-party packages** in
  this project, so this is fast and works on a slow connection.

> Want to also run on a phone later? Re-run step 4's first command as
> `flutter create . --project-name welcome_to_the_roof --platforms web,android,ios`.

---

## Step 5 — Run it!

```
flutter run -d chrome
```

- The **first** run compiles — **1–3 minutes**, normal, don't close the window.
- A Chrome window opens with the app.

**Hot reload (the magic part):** while it's running, in the terminal press:
- `r` — reload (apply code changes instantly, keep your place)
- `R` — full restart
- `q` — quit

If Chrome isn't installed, use `flutter run -d edge`, or
`flutter run -d web-server --web-port=8080` and open `http://localhost:8080` yourself.

---

## Try the app

- It opens on **Home**, **signed out**.
- Tap **Profile** → **Sign in** (email/password are pre-filled) → **Sign in**.
- Go to **Book**, pick a day, tap a session → **Book** → confirmation.
- See your booking under **Profile → My bookings**.
- **Settings** (from Profile or More) has a **dark mode** toggle.

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| `'flutter' is not recognized` | Step 1.4 (PATH) missed, or terminal not reopened. |
| `flutter doctor` shows an X | Usually a missing tool; the app may still run fine in Chrome. |
| First `flutter run` is slow | Normal — wait 1–3 minutes. |
| Project name / directory error | Make sure you're inside the `MFT-Stub-` folder and passed `--project-name welcome_to_the_roof`. |

Paste the exact error text if you get stuck.
