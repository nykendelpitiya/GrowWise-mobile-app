GrowWise Smart Plant Nursery Mobile Application

GrowWise is an AI-powered smart plant nursery mobile application developed to support farmers and plant growers in making better agricultural decisions. The application combines Artificial Intelligence, Machine Learning, Deep Learning, weather monitoring, and smart notifications into a single mobile platform to improve plant management and reduce crop loss.

The system is specially designed for Sri Lankan agricultural conditions and currently focuses on Tea, Cinnamon, Pepper, and Areca Nut plants.

🎯 Project Purpose

The main purpose of GrowWise Mobile Application is to provide an AI-powered smart agriculture solution for farmers and plant growers. The application helps users make better farming decisions through crop recommendation, fertilizer and water management, plant disease detection, weather monitoring, and smart reminder notifications. GrowWise aims to improve agricultural productivity, reduce crop loss, and simplify plant care management using modern Artificial Intelligence and mobile technologies.

📖 Project Overview

GrowWise is an AI-based smart plant nursery mobile application developed for the agriculture sector. The system combines Machine Learning, Deep Learning, cloud services, and mobile application technologies into a single platform to support smart farming activities. The application currently focuses on Tea, Cinnamon, Pepper, and Areca Nut plants. Users can receive crop recommendations, fertilizer and water recommendations, detect diseases using plant leaf images, view weather information, and receive smart care notifications through the mobile application.

✨ Key Features
AI Crop Recommendation
Recommends the most suitable crop based on environmental and regional conditions
Uses an Artificial Neural Network (ANN) model
Provides high-accuracy predictions for smart crop selection
Fertilizer Recommendation
Generates fertilizer recommendations according to crop type and district
Calculates nutrient requirements including:
Nitrogen (N)
Phosphorus (P2O5)
Potassium (K2O)
Water Recommendation
Predicts daily water requirements for plants
Considers environmental and regional agricultural conditions
Helps optimize water usage
Plant Disease Detection
Detects plant diseases using leaf images
Uses a ResNet50 deep learning model
Supports image-based disease prediction for:
Tea
Cinnamon
Pepper
Areca Nut
Smart Notification System
Automatically schedules:
Water reminders
Fertilizer reminders
Uses Firebase Cloud Messaging (FCM)
Background scheduler sends notifications at the correct time
Weather Integration
Real-time weather data integration
Displays weather information based on district
Supports better agricultural planning
Today Tip Feature
Provides daily agriculture-related tips
Helps users improve farming practices
Multi-language Support
Translation support included
Designed for user-friendly accessibility
💻 Technologies Used
Frontend
Flutter
Dart
Backend
FastAPI
Python
Artificial Intelligence & Machine Learning
TensorFlow
Keras
Scikit-learn
Artificial Neural Networks (ANN)
ResNet50
Database & Cloud
Firebase Authentication
Cloud Firestore
Firebase Cloud Messaging (FCM)
Scheduler & APIs
APScheduler
OpenWeather API
📱 Application Screens
Splash Screen
Onboarding Screens
Login Screen
Register Screen
Home Screen
Crop Recommendation Screen
Fertilizer Recommendation Screen
Water Recommendation Screen
Disease Detection Screen
Weather Screen
Notification Screen
Today Tip Screen
Profile Screen
Settings Screen
🔗 Backend API

The GrowWise backend is developed using FastAPI and provides REST API endpoints for mobile application communication.

Main APIs
/predict → Crop recommendation
/predict-care → Fertilizer and water recommendation
/predict-disease → Disease detection
/weather → Weather information
/today-tip → Daily agriculture tips
Notification scheduling APIs
Translation APIs

The backend also handles Firebase integration, AI model execution, notification scheduling, and weather data processing.

🔒 Security and Repository Note
Firebase Authentication is used for secure user login and registration
Cloud Firestore is used for secure cloud data storage
Firebase Cloud Messaging (FCM) is used for notification delivery
Environment variables are protected using .env configuration files
Sensitive files and API keys are excluded from the public repository
GitHub is used for version control and project management
⚙️ CI/CD Workflow

The project follows a GitHub-based development workflow.

Workflow Process
Feature development in separate branches
Local testing and debugging
Commit and push updates to GitHub
Continuous project updates and version management
Backend and frontend integration testing
Final deployment preparation
🚀 Project Status
✅ Frontend Development Completed
✅ Backend Development Completed
✅ AI Model Training Completed
✅ Disease Detection Integration Completed
✅ Firebase Integration Completed
✅ Notification System Completed
✅ Weather API Integration Completed
🔄 Continuous Improvements and UI Enhancements Ongoing
👨‍💻 Developer

Developed by Nusith Kendelpitiya as a final year individual project for a BSc (Hons) Computer Science degree program.

📄 License

This project is developed for academic and educational purposes.
