**Flutter Fullstack Developer Assessment Assignment**

## 🎯 Objective

Build a personal expense tracker app with a Flutter frontend and a Node.js (or any backend stack) service. Users should be able to:

* Add expenses (amount, category, description, date)
* View daily, weekly, and monthly summaries
* See basic visualizations (bar or pie charts)
* Persist data locally or via API calls
* Authenticate via email OTP or token-based login

## 📂 Repository Structure

```
/expense-tracker-app
├── backend/              # Backend service (Node.js/Express.js)
│   ├── src/
│   │   ├── controllers/
│   │   ├── datasources/
│   │   ├── models/
│   │   ├── routes/
│   │   ├── middlewares/
│   │   ├── services/
│   │   ├── utils/
│   │   ├── validations/
│   │   └── app.js
├── frontend/             # Flutter app
│   ├── lib/
│   │   ├── controllers/
│   │   ├── values/
│   │   ├── models/
│   │   ├── providers/    # (Provider/Riverpod/Bloc)
│   │   ├── pages/
│   │   ├── widgets/
│   │   ├── services/     # API clients/storage
│   │   └── main.dart
│   ├── assets/
│   ├── pubspec.yaml
│   └── README.md         # Frontend-specific README
├── README.md
├── design_decision.md
└── VIDEO_WALKTHROUGH.mp4  # 2-minute tutorial
```

## ⚙️ Prerequisites

* **Flutter**: v3.x or later
* **Node.js**: v14.x or later (or your preferred backend runtime)
* **npm/yarn**: for package management
* **Postman**: to import and test API endpoints
* * **PostgreSQL**: persistent database

## 🚀 Running the Video Walkthrough

The `VIDEO_WALKTHROUGH.mp4` file demonstrates:

* App architecture and state management choice
* Backend routes and data flow
* The custom feature implementation

## 🛠️ Error Handling & Edge Cases

* Input validation on both client and server
* Custom error messages for missing fields, network failures, and auth errors
* Fallbacks for offline mode (local storage)

## Video Walkthrough Link
* https://drive.google.com/file/d/10sHmYOV0swfCTjO0ZsWr2Zits15w2KlG/view?usp=sharing

## ✅ Evaluation Checklist

* [✅] Clean, modular architecture (Provider/Riverpod/Bloc)
* [✅] UI/UX consistency and simplicity
* [✅] Fully functional frontend-backend integration
* [✅] Bonus: Basic authentication flow
* [✅] Unique custom feature
* [✅] Good error handling
* [✅] Video walkthrough submitted 

---
