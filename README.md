# 🧗‍♂️ VerticalShelter App

**VerticalShelter** is a mobile app built with **Flutter** to help climbers track their progress, share beta, and connect with their climbing community.

This is the **official repository for the VerticalShelter Flutter app**.

> ⚠️ This README is still a work in progress — feel free to contribute!

---

## 🚀 Getting Started

Before jumping into the frontend, we **strongly recommend launching the backend locally**:  
👉 [VerticalShelter Backend Repository](https://github.com/Vertical-Shelter/VerticalShelter-Back)

To run the app:

```bash
# Clone the repo
git clone https://github.com/Vertical-Shelter/VerticalShelter-App.git
cd VerticalShelter-App

# Install dependencies
flutter pub get

# Run the app
flutter run
```
---

## 🧩 Architecture

VerticalShelter uses **GetX** for state management and follows a **Model-View-Controller (MVC)** inspired architecture. Here's a simplified overview of the project structure:

app/lib/
├── Core/                 # Core logic, bindings, config, etc.
├── Data/                 # Models and data structures
├── GeneralScreens/       # Login, Register, etc.
├── l10n/                 # Localization files
├── routes/               # App route definitions
├── utils/                # Utility functions and global controllers
├── Vertical-Setting/     # Screens for route setters
├── Vertical-Tracking/    # Screens for climbers
├── Widget/               # Reusable widgets
└── main.dart             # Entry point of the app

---

## 🤝 Contributing

We welcome contributions!

If you want to build features, fix bugs, or improve architecture:

1. Fork this repo.
2. Create a new branch (`feature/your-feature`).
3. Submit a pull request — we'll be happy to review it!

---

## 🗺️ Roadmap (Coming Soon)

We’ll soon publish a public roadmap, including:

- New features
- Upcoming refactors
- Community suggestions

---

## 📫 Contact

Questions or ideas?  
Open an issue or reach out directly!
ludovik.maitre@gmail.com

---

## 📄 License

This project is licensed under a custom non-permissive license.  
**Use is restricted for commercial purposes without explicit permission.**

Please see the [`LICENSE`](./LICENSE) file for details.

