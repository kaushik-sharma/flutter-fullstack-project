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

## Screenshots

<img width="1080" height="2424" alt="Screenshot_1753373556" src="https://github.com/user-attachments/assets/ba8b5536-ea56-4c78-96d9-6836cd13ff45" />
<img width="1080" height="2424" alt="Screenshot_1753373861" src="https://github.com/user-attachments/assets/5357a358-bf89-40b9-b034-87ac467baa29" />
<img width="1080" height="2424" alt="Screenshot_1753373855" src="https://github.com/user-attachments/assets/1fe02fca-9d3b-48f5-abfc-a02110a6a57c" />
<img width="1080" height="2424" alt="Screenshot_1753373850" src="https://github.com/user-attachments/assets/e75ec40c-e89c-4e5c-9702-3b359d3ac1d1" />
<img width="1080" height="2424" alt="Screenshot_1753373622" src="https://github.com/user-attachments/assets/e9cfc942-9d85-43da-a17e-9214d47c3f9f" />

---
