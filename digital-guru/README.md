# Digital Guru Workspace

This workspace contains three main projects, each serving a unique purpose within the Digital Guru ecosystem:

## 1. admin-app
A Flutter-based admin dashboard for managing Digital Guru resources, users, and content. It provides:
- User and content management interfaces
- Analytics and reporting tools
- Configuration for both Android and iOS platforms
- Web support

**Key folders:**
- `lib/` — Dart source code for the app
- `assets/` — Images, fonts, and configuration files
- `android/`, `ios/`, `web/` — Platform-specific code and configs

**How to run:**
- Requires Flutter SDK
- Run `flutter pub get` then `flutter run` in the `admin-app` directory

---

## 2. digital-guru-app
The main Digital Guru mobile application for end users. Built with Flutter, it offers:
- Core user-facing features and UI
- Cross-platform support (Android, iOS, Web)
- Modular architecture for scalability

**Key folders:**
- `lib/` — Main app source code
- `assets/` — App resources
- `android/`, `ios/`, `web/` — Platform-specific code
- `test/` — Widget and unit tests

**How to run:**
- Requires Flutter SDK
- Run `flutter pub get` then `flutter run` in the `digital-guru-app` directory

---

## 3. firebase-data-loader
A utility project for uploading and managing data in Firebase, supporting Digital Guru's backend needs. Features:
- Scripts for uploading JSON data to Firebase
- Model generation tools
- Example configurations and usage samples

**Key folders:**
- `data_uploader/` — Node.js scripts for data upload
- `lib/` — Dart helpers for model generation
- `example/` — Usage examples and sample data

**How to use:**
- For Node.js scripts: Run `npm install` in `data_uploader/` then execute scripts as needed
- For Dart tools: Use Dart SDK to run model generators

---

Each project contains its own README with more details. For setup instructions, dependencies, and contribution guidelines, refer to the respective project folders.