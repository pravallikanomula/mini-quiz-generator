<h1 align="center">🧠 Mini Quiz Generator</h1>

<p align="center">
  <em>A Flutter app that generates AI-powered multiple-choice quizzes using OpenAI — built while preparing for AWS Cloud Certification ☁️</em>
</p>

---

### 📱 About the App
**Mini Quiz Generator** is a mobile app built with **Flutter** that uses **OpenAI** to generate short, topic-based quizzes.  
You can enter any topic (like *AWS EC2*, *IAM*, or *Data Science*), and the app creates **5 AI-generated MCQs** to test your understanding.

After answering all the questions, the app:
- Displays your **score**
- Shows which questions you got **wrong**
- Reveals the **correct answers** (so you can learn and improve)

---

### ⚙️ Features
- **AI-Powered Question Generation** — Uses OpenAI API to create new quizzes on any topic  
- **5-100 MCQs per Quiz** — Quick sessions to test your knowledge  
- **Topic Input Bar** — Enter *any topic* (tech, science, art, general knowledge) and get a custom quiz  
- **Answer Explanations** — Learn from detailed reasoning for every question  
- **Difficulty Levels** — Choose between *Easy*, *Medium*, and *Hard* quizzes 
- **Local Storage** — Save quiz history with `shared_preferences`  
- **Dark Mode & Custom Themes**  
- **Export/Share Results** (planned feature with `pdf` and `share_plus`)

---

### 🧰 Tech Stack

| Component | Technology |
|------------|-------------|
| **Framework** | Flutter |
| **Language** | Dart |
| **AI Engine** | OpenAI API |
| **Local Storage** | shared_preferences |
| **Extras (Planned)** | pdf, printing, share_plus |
| **Platform Support** | Android & iOS |

---

### 🚀 Getting Started

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/quiz_generator.git
   cd quiz_generator
2. Install dependencies:
   ```bash
   flutter pub get
3. Add your OpenAI API key securely (e.g., .env or local config).
4. Run the app:
   ```bash
   flutter run

---

### Motivation

I built this project while preparing for my AWS Cloud Practitioner Certification.
I wanted a simple way to generate quizzes instantly on cloud concepts — and OpenAI made it possible to create endless practice questions and explanations in seconds.

---

###🛠️ Future Improvements

- 🔔 Notifications for daily quiz reminders
- 📊 Add quiz statistics and performance tracking
- 🏆 Leaderboard for friendly challenges
- 📤 Export and share results as PDFs
