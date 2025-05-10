# Study Group Organizer

A mobile application developed for the **Software for Mobile Devices** course that helps students manage and collaborate in study groups efficiently. Built with **Flutter**, the app follows the **BLoC architecture** and integrates **Firebase** for authentication and data storage, alongside **Supabase** for file management.

Group #9 Members:

21K-4898 Ali Naqi <br>
21K-4904 Hatim <br>
21K-3350 Syed Muhammad Abid Mustafa <br>
21K-3437 Mohammad Anas

## Features

### 🔐 Authentication

* **Login and Sign-Up** using **Firebase Authentication**
* Supports **Email/Password** sign-up
* Secure session management

<p align="center">
  <img src="https://github.com/user-attachments/assets/fafb9f28-94dd-4681-bdf1-726a793bdb03" alt="Login Demo" width="600"/>
</p>

###

<p align="center">
  <img src="https://github.com/user-attachments/assets/0570a97b-f36d-4dfd-a060-a780ed78b381" alt="Signup Demo" width="600"/>
</p>

### 📦 Firebase Integration

* Uses **Cloud Firestore** for data persistence
* Organized into the following collections:

  * `users`: Stores user profile and metadata
  * `groups`: Stores group information and members
  * `announcements`: Stores announcements within each group
  * `messages`: Stores messages within each group

### 🏠 Home Page

* Displays a list of **groups the user has joined**
* Options to **Create** or **Join** a new group

<p align="center">
  <img src="https://github.com/user-attachments/assets/1368c20c-5a24-42c2-82c4-072d45ba0150" alt="Home Page Create Group Demo" width="600"/>
</p>

###

<p align="center">
  <img src="https://github.com/user-attachments/assets/970084c6-9703-4f8a-82e7-41fb0ccf95f8" alt="Home Page Join Group Demo" width="600"/>
</p>

### 📁 Group Details Page

Each group includes multiple features:

* **Announcements Tab**

  * Post new announcements
<p align="center">
  <img src="https://github.com/user-attachments/assets/88b2fd83-f231-4baf-b6e5-766a3e62ecbb" alt="Announcement Page Demo" width="600"/>
</p>

  * Attach files (e.g., PDFs, images) using the **file picker**
  * Files are uploaded and stored using **Supabase Storage**
* **File Explorer**

  * View all uploaded files for the group
 
<p align="center">
  <img src="https://github.com/user-attachments/assets/7582f588-f526-4d52-a56a-ee53aa0087b2" alt="File Explorer Demo" width="600"/>
  </p>

* **Chat Tab**

  * Real-time chat functionality for each group
  <p align="center">
  <img src="https://github.com/user-attachments/assets/09a8901d-cf37-4880-ac7c-169a28717109" alt="Chat Demo" width="600"/>
  </p>

* **Group Info**

  * View group details including name, subject, and group ID

 <p align="center">
  <img src="https://github.com/user-attachments/assets/b84a0b4d-da2d-4fd5-89c5-c752700bdd79" alt="Group Info Demo" width="600"/>
</p>

## Architecture

This project uses the **BLoC (Business Logic Component)** pattern to separate the presentation and business logic layers, improving testability and scalability.

### Technologies Used

* **Flutter** (UI framework)
* **Firebase Authentication**
* **Cloud Firestore**
* **Supabase Storage**
* **File Picker** package
* **Flutter BLoC** for state management

## Getting Started

1. Clone the repository:

   ```bash
   git clone https://github.com/anasdevv/smd-assignment.git
   cd smd-assignment
   ```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Set up Firebase:

   * Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   * Enable Email/Password authentication in the Firebase Console

4. Configure Supabase:

   * Create a Supabase project and bucket for file storage
   * Add your Supabase keys in the appropriate config file

5. Run the app:

   ```bash
   flutter run
   ```
