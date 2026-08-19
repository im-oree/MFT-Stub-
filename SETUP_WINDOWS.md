# How to run MFT Stat Engine on your Windows PC (from absolute zero)

You know nothing about Flutter — that's fine, this app runs with a handful of
copy-paste commands. There are **5 steps total**.

---

## Step 1 — Install the Flutter SDK

This is the one-time setup. The Flutter SDK is a free tool from Google that
knows how to build and run the app.

1. Go to **https://docs.flutter.dev/get-started/install/windows**
2. Download the **Flutter SDK** zip (it's ~1GB, takes a few minutes).
3. Unzip it somewhere you have write access. **Important:** put it somewhere
   simple like `C:\flutter` (avoid long paths or paths with spaces).
4. In the unzipped folder there is a `bin` folder. You now need to add it to
   your PATH so Windows can find the `flutter` command:
   - Press `Win` key, type **"env"**, click **"Edit the system environment variables"**.
   - Click **"Environment Variables…"**.
   - Under **"User variables"**, find **`Path`**, select it, click **"Edit"**, then **"New"**, and add:
     `C:\flutter\bin`
   - Click OK on every window.
5. **Close and reopen** your terminal (Command Prompt or PowerShell) so the change takes effect.

> If you'd rather skip manual PATH editing, the official Flutter docs also
> mention installing via **Git** (`git clone https://github.com/flutter/flutter.git`).

---

## Step 2 — Check the install works

Open **Command Prompt** (press `Win`, type `cmd`, press Enter), then run:

```
flutter doctor
```

This checks that Flutter is installed and tells you what's ready. You'll see a
list like `[✓] Flutter`, `[✓] Chrome`, etc. A check mark next to **Chrome**
means you're good to go for running in the browser.

---

## Step 3 — Put the app into your (empty) folder

Your folder is empty, so we need to copy the app code into it. You have two easy
options:

**Option A — Download the ZIP (easiest, no extra tools):**
1. Go to **https://github.com/im-oree/MFT-Stub-**
2. Click the green **"Code"** button → **"Download ZIP"**.
3. Extract it into your empty dev folder. Inside you'll find a `MFT-Stub-`
   folder with all the code. **Open that folder in your terminal** (see below).

**Option B — Git clone (if you have Git installed):**
```
cd C:\path\to\your\empty\dev\folder
git clone https://github.com/im-oree/MFT-Stub-.git
cd MFT-Stub-
```

Either way, you end up **inside the project folder** (the one that has
`pubspec.yaml` in it). Your terminal's current folder must be this folder for
the next commands to work. In Command Prompt, navigate there with:
```
cd C:\your\dev\folder\MFT-Stub-
```

---

## Step 4 — Download dependencies

Still inside the project folder, run:

```
flutter pub get
```

This downloads the app's dependencies. It should finish in a few seconds and
say something like `Get packages completed`.

> There are **no third-party packages** in this project, so this is fast and
> works even on a slow connection.

---

## Step 5 — Run it!

Inside the project folder, run:

```
flutter run -d chrome
```

What happens:
- The first run **compiles** the app. **The first time takes 1–3 minutes.**
  That's normal — be patient and don't close the window.
- After it finishes, **a Chrome window opens automatically** with the app.

**Hot reload (this is the magic part):** while the app is running, go back to
the terminal and press:
- `r` — reload (keeps your place, applies code changes instantly)
- `R` — full restart
- `q` — quit

If Chrome isn't installed, use `flutter run -d edge` for Microsoft Edge, or
`flutter run -d windows` to run it as a native Windows app window.

---

## Optional — Run it on your phone

If you want it on your phone instead of the browser:
1. Install **Android Studio** (https://developer.android.com/studio) — the
   official Android dev tool.
2. Open Android Studio → **More Actions** → **SDK Manager** and install an
   **Android SDK**.
3. Plug your phone in via USB and enable **USB debugging** (Developer Options).
4. Run `flutter doctor` again — it should now show `[✓] Android toolchain`.
5. Run `flutter run` (no `-d chrome`) and pick your phone.

---

## Troubleshooting quick list

| Problem | Fix |
|---------|-----|
| `'flutter' is not recognized` | You missed Step 1.5 (PATH) or didn't reopen the terminal. |
| `flutter doctor` shows an X | Read what it says — usually it just means a tool isn't installed, and the app may still run fine in Chrome. |
| First `flutter run` is slow | Normal. Wait 1–3 minutes. |
| `flutter: command not found` on macOS/Linux | Add `<flutter>/bin` to your PATH, same idea as Step 1. |
| It compiles but Chrome doesn't open | Use `flutter run -d web-server --web-port=8080` then open `http://localhost:8080` in your own browser. |

That's it. If you hit a wall at any step, paste the exact error text here and
I'll help you fix it.
