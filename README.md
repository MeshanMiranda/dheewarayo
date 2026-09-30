# 🎣 Dheewarayo App

Dheewarayo (ධීවරයෝ) is a comprehensive Flutter-based mobile application developed to empower fishermen with real-time weather forecasts, AI-driven Potential Fishing Zone (PFZ) predictions, safety warnings, and a community platform. The main objective of this project is to enhance safety at sea, improve catch yields, and connect fishing communities through modern mobile technologies and machine learning.

The application focuses on clean architecture, background task execution, API integration, and machine learning while providing an intuitive user experience tailored for fishermen.

---

## 🚀 Project Overview

Dheewarayo provides fishermen with essential tools for navigation, weather monitoring, and smart fishing. By combining real-time marine weather data from external APIs with on-device Machine Learning (TensorFlow Lite) models, the app predicts optimal fishing zones and provides automated background safety alerts for dangerous sea conditions.

This project was developed using **Flutter** and **Dart**, following best practices in mobile software architecture.

---

## 🛠️ Technologies Used

* **Flutter & Dart**
* **Firebase** (Authentication, Cloud Firestore, Firebase Storage)
* **TensorFlow Lite (`tflite_flutter`)** (On-device ML for PFZ & Weather Predictions)
* **Google Maps API & Geolocator** (`google_maps_flutter`, `geolocator`, `location`)
* **OpenWeatherMap & Copernicus Services** (Marine & meteorological weather data)
* **WorkManager & Local Notifications** (`workmanager`, `flutter_local_notifications`)
* **Provider** (State management, Theme & Localization control)

---

## 🔑 Key Concepts Demonstrated

### 1️⃣ Software Design Principles

* Modular architecture separating UI screens, state management providers, and background services
* Provider pattern for scalable state, dark/light theme switching (`ThemeProvider`), and multi-language support (`LocaleProvider`)
* High cohesion and loose coupling across components

### 2️⃣ Machine Learning & Background Services

* On-device AI inference using TensorFlow Lite models for Potential Fishing Zone (PFZ) estimation
* Background periodic tasks executed via `WorkManager` to continuously monitor weather conditions
* Automated local notifications alerting fishermen about high winds, heavy rain, or dangerous wave conditions

### 3️⃣ Interoperability & Service Integration

* Integration with external **OpenWeatherMap API** and **Copernicus Marine Data** services
* JSON response parsing for live multi-hour weather forecasts and environmental parameters
* Interactive Google Maps integration displaying user location, sea conditions, and fishing hotspots

### 4️⃣ Virtual Identity & User Management

* Secure user authentication via Firebase Auth (Email/Password & Google Sign-In)
* Personalized fisherman settings, location preferences, and user profile data stored per unique User ID
* Community hub enabling fishermen to share posts, fishing updates, and sea condition photos

---

## 🎯 Application Features

* User Registration & Login (Email & Google Sign-In)
* AI Fishing Radar (Potential Fishing Zone prediction)
* Live Weather Forecast & Marine Safety Warnings
* Background Periodic Weather Monitoring & Push Notifications
* Fisherman Community Hub (Create posts, share photos, and interact)
* Interactive Map with GPS Location Tracking
* Custom Dark & Light Theme Modes
* Multi-language Localization Support (English & Sinhala)
* Fisherman Profile & Settings Customization

---

## 🗄️ Database Design

The system uses **Firebase Cloud Firestore** and **Firebase Storage**:

* **Users Collection** – Stores user credentials, profiles, and individual fisherman settings
* **Posts Collection** – Stores community updates, captions, timestamps, likes, and image references
* **Firebase Storage** – Manages uploads for profile images and community photos

All records are linked using the unique user ID to ensure proper identity management and data security.

---

## 📽️ Demo Video

A complete introduction and application demonstration video is included, explaining:

* App navigation and user interface
* Weather API & Copernicus data integration
* AI/ML Potential Fishing Zone prediction functionality
* Community feed and Firebase Cloud backend integration

---

## 📌 Learning Outcomes

Through this project, I gained hands-on experience in:

* Building cross-platform mobile applications with Flutter & Dart
* Deploying TensorFlow Lite Machine Learning models for mobile edge computing
* Configuring background services with WorkManager and local notifications
* Integrating third-party REST APIs and Google Maps services
* Managing user identity, data persistence, and cloud storage with Firebase

---

## 🙌 Acknowledgements

This project was developed to support the fishing community by providing modern tools for sea safety, weather awareness, and smart fishing insights.

Feel free to explore the code and video demonstration.
Enjoy using Dheewarayo! 🚀

---

## 📸 Live Demonstration

[View the Live Demonstration](https://drive.google.com/file/d/1AMOP3UTUK2PEoZ1RC-TdthU5SLxsZjV7/view?usp=sharing)

---

## 📄 Project Poster

<p align="center">
  <img src="https://github.com/MeshanMiranda/dheewarayo/blob/main/Dheewarayo%20Poster4.png?raw=true" alt="Dheewarayo Project Poster" width="800">
</p>

---
