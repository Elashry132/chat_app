# Simple Chat App

## Overview

The Simple Chat App is a real-time messaging application built using Flutter and Firebase. The app allows users to communicate with each other in real-time, featuring user authentication, messaging, and a clean, responsive user interface.

## Features

- **User Authentication**: Users can sign up and log in using email and password through Firebase Authentication.
- **Real-Time Messaging**: Send and receive messages instantly with Firebase Firestore.
- **Online Status**: Display the online status of users.
- **Chat History**: Store and retrieve past conversations from Firestore.
- **Responsive Design**: Optimized for both mobile and tablet devices.

## Technologies Used

- **Frontend**: 
  - [Flutter](https://flutter.dev/) for building the cross-platform user interface.
  - [Provider](https://pub.dev/packages/provider) or [Bloc/Cubit](https://bloclibrary.dev/#/) for state management (if applicable).
  
- **Backend**:
  - [Firebase Authentication](https://firebase.google.com/docs/auth) for user authentication.
  - [Firebase Firestore](https://firebase.google.com/docs/firestore) for real-time database and chat storage.
  - [Firebase Cloud Messaging (FCM)](https://firebase.google.com/docs/cloud-messaging) for push notifications (optional).
  - [Firebase Storage](https://firebase.google.com/docs/storage) for storing media files (optional).

## Getting Started

### Prerequisites

- Flutter installed on your development machine.
- Firebase project set up with Authentication and Firestore enabled.
- Firebase CLI for deploying Firebase functions (if applicable).

### Installation

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/Elashry132/chat_app.git
   cd chat_app-app
Set Up Firebase:

Create a Firebase project in the Firebase Console.
Enable Email/Password Authentication.
Set up a Firestore database.
Download the google-services.json file and place it in the android/app directory.
(Optional) If using Firebase Cloud Messaging or Firebase Storage, configure them as needed.
Install Dependencies:

bash
Copy code
flutter pub get
Run the Application:

bash
Copy code
flutter run
Usage
Sign Up: Create an account using your email and password.
Log In: Access the chat app using your credentials.
Chat: Start chatting with other users in real-time.
Contributing
Contributions are welcome! Please follow these steps to contribute:

Fork the repository.
Create a new branch: git checkout -b feature-name.
Make your changes and commit them: git commit -m 'Add some feature'.
Push to the branch: git push origin feature-name.
Create a pull request.

Acknowledgements
Flutter for the UI framework.
Firebase for backend services.
