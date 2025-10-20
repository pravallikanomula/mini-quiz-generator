🧠 Mini Quiz Generator

A Flutter-based mobile app that generates multiple-choice quizzes using OpenAI’s API.
Built while preparing for the AWS Cloud Practitioner certification, this app helps users test their knowledge interactively with AI-generated questions.

🚀 Overview

Mini Quiz Generator allows users to:

Enter a topic (e.g., AWS EC2, S3, IAM, or general tech concepts).

Automatically generate 5 multiple-choice questions (MCQs) using OpenAI.

Select answers and get instant feedback.

View which questions were answered incorrectly along with the correct answers.

Review past quizzes anytime for continued learning.

🧩 Features

🧠 AI-Powered Quiz Creation – Generates quiz questions dynamically via OpenAI.

🎯 Instant Feedback – Highlights wrong answers and displays the correct ones.

💾 Quiz History – Stores past quizzes locally using shared_preferences.

🌓 Dark Mode & Custom Themes – Smooth UI with built-in theme support.

📤 Export & Share – Share your quiz results or export them as PDF (coming soon).

🧰 Tech Stack
Component	Description
Framework	Flutter
Language	Dart
AI Engine	OpenAI API
Local Storage	shared_preferences
PDF & Sharing	pdf, printing, share_plus (planned features)
Platform Support	Android & iOS
🏗️ Setup Instructions

Clone this repository:

git clone https://github.com/yourusername/quiz_generator.git
cd quiz_generator


Install dependencies:

flutter pub get


Add your OpenAI API key in a .env or config file (if applicable).

Run the app:

flutter run

📱 Screenshots (optional)

Add screenshots of your main quiz screen, result summary, and history page.

💡 Motivation

This app was created while preparing for my AWS Cloud Certification.
I wanted a way to practice concepts interactively, and using OpenAI allowed me to generate new quizzes on any topic instantly — making learning more engaging and personalized.
