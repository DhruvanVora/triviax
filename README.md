# TriviaX

TriviaX is a modern Flutter-based quiz application that allows users to play trivia quizzes fetched from a real-time API or create their own custom quizzes.

## Features

- **Difficulty-Based Quiz System:** Choose from Easy, Medium, or Hard difficulty levels.
- **Real-Time API Integration:** Fetches questions dynamically from `the-trivia-api.com`.
- **Admin Quiz Creation:** Manage custom questions via the Admin Panel (Add, Edit, Delete).
- **Custom Quiz Play Mode:** Play quizzes created by the admin.
- **Intelligent Scoring System:** +10 points for correct answers, -1 life for wrong answers.
- **Life-Based Gameplay:** Start with 3 lives. Game over if lives run out.
- **Visual Answer Feedback:** Immediate feedback with color-coded answers (Green for correct, Red for wrong).
- **Result Screen:** Displays score and a celebratory confetti animation for high scores.
- **Light & Dark Mode Support:** Toggle between themes for better accessibility.
- **Professional UI & UX:** Clean design with animations and responsive layout.

## Technologies Used

- **Frontend:** Flutter, Dart
- **State Management:** Riverpod (for quiz logic and data), GetX (for navigation and theme)
- **API:** HTTP package
- **UI:** Lottie, Confetti, Google Fonts

## Getting Started

To run this project locally:

1.  **Clone the repository:**
    ```bash
    git clone <repository-url>
    cd triviax
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Run the application:**
    ```bash
    flutter run
    ```

## Project Structure

- `lib/models/`: Data models (Question).
- `lib/providers/`: State management (Quiz, Admin, API).
- `lib/screens/`: UI Screens (Home, Quiz, Result, Admin, Add Question).
- `lib/widgets/`: Reusable widgets (QuizOption).
- `lib/services/`: API services.
- `lib/controllers/`: GetX controllers (Theme).

## License

This project is licensed under the MIT License.
