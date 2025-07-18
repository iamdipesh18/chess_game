<h1 align="center">
  ♟️ Flutter Chess Game
</h1>

<p align="center">
  A modern, interactive chess game built in Flutter. Fully modular, cleanly architected, and customizable — perfect for learning, extending, or just playing a game of chess!
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter" />
  <img src="https://img.shields.io/badge/License-MIT-green" />
  <img src="https://img.shields.io/github/stars/iamdipesh18/chess_game?style=social" />
</p>

---

## 🎮 Preview

> Add your own GIF or screenshot here (record using Screenity, OBS, or VS Code Recorder):

<p align="center">
  <img src="assets/demo.gif" alt="Chess Game Demo" width="600"/>
</p>

---

## ✨ Features

- ♔ Classic 8×8 chess board
- 💡 Legal move generation & king safety validation
- 🔒 Check & checkmate detection
- 🔄 State management using modular service classes
- 🧩 Clean, maintainable architecture (separation of UI & logic)
- 📱 Responsive & interactive UI (tap/drag moves)
- ⚡ Built fully in Flutter (cross-platform)

---


## 📁 Project Structure
```bash
lib/
├── components/                # UI components (squares, pieces, captured pieces)
│   ├── dead_piece.dart
│   ├── piece_image.dart
│   └── square.dart
├── helper/                   # Utility functions
│   └── helper_methods.dart
├── models/                   # Core data models
│   ├── chess_piece.dart
│   └── game_state.dart
├── services/                 # Logic services (move validation, game state, etc.)
│   ├── board_initializer.dart
│   ├── check_detector.dart
│   ├── chess_game_service.dart
│   ├── game_state_updater.dart
│   ├── helpers.dart
│   ├── move_generator.dart
│   └── move_validator.dart
├── ui/                       # Game board UI and view logic
│   ├── game_board.dart
│   └── game_board_view.dart
├── values/                   # App colors and constants
│   └── colors.dart
├── main.dart                 # Entry point
└── generate_structure.dart   # Script to print project structure to file



---

## 🚀 Getting Started
```bash
git clone https://github.com/iamdipesh18/chess_game.git
cd chess_game
flutter pub get
flutter run

---