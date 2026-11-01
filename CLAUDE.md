# CLAUDE.md — Smoke Room (`smoke_room`)

Context for future Claude Code sessions. Read this before changing anything.

Owner: Chirag (final-year AIML engineering student). This is a fun project.
GitHub: https://github.com/chiragparamesh/smoke_room (public). Org / package: `com.chirag.smoke_room`.

## Project brief

### 4. smoke_room — "Smoke Room" (fun project)

Real-time virtual smoking rooms. Themed rooms (rainy terrace, chai stall, office fire exit, hostel rooftop) with ambient sound. The cigarette burns down over about 5 minutes; hold to drag (tip glows, smoke rises), tap to flick ash. Ask someone for a light (their lighter animates over). Anonymous names; chat disappears when your cigarette ends. Private rooms via share link. 18+ age gate, profanity filter, report button. Quit mode: join the room when a craving hits instead of smoking; it tracks cigarettes avoided and money saved, and is the lead feature in the store listing.

**Backend:** Supabase Realtime (free tier) for presence and chat. I will create the Supabase project and give you the keys.

**Current build scope:** age gate, one public room, presence count, cigarette animation, ephemeral chat, quit-mode counter.

## Lightweight rules

My Windows laptop has low RAM: Android Studio and the Android emulator froze it. Everything must stay lightweight:

- No Android Studio, no emulator, no local Gradle/APK builds.
- Daily preview with: `flutter run -d chrome`
- APKs are built by GitHub Actions and installed on my Pixel 9a.
- ML models are trained in Google Colab; only the exported .tflite files live in the project.
- Everything goes inside `D:\Projects`. Nothing else on `D:\` root.
- Never run Gradle or `flutter build apk` locally.
- One install / one heavy task at a time. Never run parallel heavy tasks.
- `android/gradle.properties` stays capped: `org.gradle.jvmargs=-Xmx1536m`, `org.gradle.daemon=false`, `org.gradle.parallel=false`.
- Toolchain lives in `D:\Projects\_tools` (flutter, jdk, android-sdk, caches\pub, caches\gradle).

## How to work in this repo

- Preview: `flutter run -d chrome` (web is the dev target; Android is built only by CI).
- Checks you may run locally: `flutter pub get`, `flutter analyze`, `flutter test`.
- Never run: `flutter build apk`, `./gradlew`, `flutter run -d <android device>` with a local build, or anything that starts Gradle.
- APK: push to GitHub → Actions → "Build APK" → download the `smoke_room-release-apk` artifact → install on the Pixel 9a.
- Plugins that don't support web (camera, tflite, GPS, haptics, …) must sit behind an interface in `lib/core/services/` with a web/mock implementation so Chrome preview keeps working.

## Structure

- `lib/main.dart`, `lib/app.dart` — entry point and `MaterialApp.router`.
- `lib/core/theme/` — theme and colors. `lib/core/router/` — go_router routes.
- `lib/core/services/` — platform/service interfaces. `lib/core/utils/` — constants, helpers. `lib/core/widgets/` — shared widgets.
- `lib/features/<feature>/{data,domain,presentation}/` — one folder per feature:
  - `lib/features/age_gate/` — 18+ age gate
  - `lib/features/room/` — One public room (themed rooms later)
  - `lib/features/presence/` — Live presence count (Supabase Realtime)
  - `lib/features/cigarette/` — Cigarette burn-down animation, drag and ash flick
  - `lib/features/chat/` — Ephemeral chat that disappears when the cigarette ends
  - `lib/features/quit_mode/` — Quit-mode counter: cigarettes avoided, money saved
  - `lib/features/moderation/` — Profanity filter and report button
- `supabase/` — SQL schema to paste into the Supabase SQL editor.
- `docs/architecture.md` — full system design and roadmap. Keep it updated.
- `.github/workflows/build-apk.yml` — the only place APKs are built.

## Status

Skeleton only: folders, theme, router, placeholder home screen, CI. No features built yet.
Update the features table in README.md (Built / Planned) as features land.
