# 🧠 Wellness AI Coach

![Chat Interaction Demo]
![Image]https://github.com/user-attachments/assets/ba5773fe-2f98-4b73-90f5-dbec42f7ee51

A production-ready Flutter application that provides personalized AI coaching (Dietitian, Fitness, Yoga, Pilates) using Firebase AI (Vertex AI) and Remote Config.

## 🏗️ Architecture: Clean Architecture

This project is built using **Clean Architecture** principles and **Feature-First** folder structuring to ensure scalability, testability, and separation of concerns.

The application is divided into distinct layers:

- **Domain:** The core of the application. Contains Entities and abstract Repositories. It is completely independent of any external libraries or Flutter itself.
- **Data:** Handles data retrieval and storage. Contains Models (Hive adapters) and Repository Implementations (Firebase, Hive).
- **Presentation:** The UI layer. Contains Pages, Widgets, and State Management (Cubit). It only reacts to state changes and delegates business logic to the Cubit.

## 🧰 Tech Stack & State Management

- **Framework:** Flutter
- **State Management:** BLoC / Cubit
- **Dependency Injection:** get_it
- **AI Integration:** firebase_ai
- **Dynamic Prompts:** firebase_remote_config
- **Local Storage:** hive & hive_flutter

## 🚀 Core Features & Enterprise Solutions

### 1. Dynamic AI Personas (Remote Config)

Instead of hardcoding system instructions (prompts) within the app, **Firebase Remote Config** is used to fetch the persona logic for each coach dynamically.

- **Benefit:** Allows non-technical teams (like product managers or prompt engineers) to tweak and improve the AI's behavior instantly from the Firebase Console without requiring a new app store release.

### 2. Secure AI Integration

The application leverages **Firebase AI (`firebase_ai`)** linked to Google Cloud Vertex AI, using the `gemini-1.5-flash` model.

- **Security:** Unlike standard generative AI packages, this approach does **not** require embedding vulnerable API keys in the source code. It uses Firebase Authentication and App Check mechanisms to secure endpoints.
- **Enterprise Grade:** Firebase AI ensures production-level SLA, data privacy (user chat data is not used to train public models), and high stability.

### 3. Persistent Contextual Chat (Hive)

![History and Local Storage Demo]
(<![Image](https://github.com/user-attachments/assets/85258930-c905-4da6-91e4-e49e5c53ca84)>)

A highly performant NoSQL database, **Hive**, is implemented for local storage.

- The `ChatHistoryRepository` intercepts all messages and saves them directly to the device storage.
- **Context Retention:** When a user reopens a past chat from the History tab, the entire session is loaded from the local database and fed back into the `history` parameter of the `ChatSession`. This allows the AI to perfectly remember the ongoing conversation context.

## 🛠️ How to Run the Project

### Prerequisites

- Flutter SDK (v3.10.0 or higher)
- A Firebase project with **Firebase AI** enabled via Google Cloud Console.

### Installation Steps

1. **Clone the repository:**
   ```bash
   git clone <https://github.com/irfan-vural/manifest-app>
   cd manifestapp
   flutter pub get
   dart run build_runner build --delete-conflicting-outputs
   flutter run
   ```
