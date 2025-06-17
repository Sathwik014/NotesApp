# 📝 Notes App (Flutter + Firebase)

A fully functional cross-platform **Notes App** built with **Flutter** and powered by **Firebase**.  
This app allows users to sign up or log in, create and manage notes, and enjoy real-time syncing across devices.  
It also supports features like **pinning**, **category filters**, **Markdown content editing**, and **Google Sign-In** for mobile.

---

## 🚀 Features

- 🔐 **Firebase Authentication**
  - Email/password login
  - Google Sign-In (for mobile only)

- 📦 **Cloud Firestore**
  - Create, read, update, delete notes
  - Real-time sync across devices
  - User-specific data isolation

- ✨ **Rich UI Features**
  - Modern, minimal UI with Lottie animations
  - Markdown support in note editor
  - Category filtering (Work, Study, Fitness, etc.)
  - Pinned notes and timestamp display
  - Responsive design for different screen sizes

- 🔎 **Search functionality**
  - Integrated search bar to look for notes by title/content

---

## 🧠 Firebase Services Used

| Firebase Service     | Purpose                                                |
|----------------------|--------------------------------------------------------|
| Firebase Auth         | User registration and login (email/password, Google)  |
| Cloud Firestore       | NoSQL database to store user-specific notes           |
| Firebase Core         | Core SDK setup and initialization                     |
| Firebase Offline Cache (optional) | Offline persistence for notes           |

---
## ⚙️ Challenges & Solutions

### 🔄 Note Data Passing
**Problem:** Needed to pass only `title` and `date` from NotePopup to NoteEditor.  
**Fix:** Used optional constructor params and fallback in `initState()`.

### 📝 Description vs Content
**Problem:** Keep `description` (for tile) separate from full `content`.  
**Fix:** Passed only `title` to NoteEditor; handled `description` separately.

### 📌 Pinning Notes
**Problem:** Pinned notes needed to show at the top.  
**Fix:** Sorted Firestore query by `pinned` and `timestamp`.

### 🧰 Markdown Formatting
**Problem:** No external rich text editor used.  
**Fix:** Inserted markdown syntax directly using `TextSelection`.

### 🎨 Text Color Picker
**Problem:** Allow users to choose text color.  
**Fix:** Used `PopupMenuButton<Color>` to change `_selectedTextColor`.

### ⚠️ Firebase Field Errors
**Problem:** Missing Firestore fields caused runtime errors.  
**Fix:** Used null-aware operators: `data['key'] ?? defaultValue`.
![WhatsApp Image 2025-06-17 at 11 48 55 PM](https://github.com/user-attachments/assets/6859f81a-2667-4567-bbe3-b78b306fd49f)
![WhatsApp Image 2025-06-17 at 11 48 55 PM (1)](https://github.com/user-attachments/assets/b23e949f-4dde-438a-b9b8-6eef0d409427)
![WhatsApp Image 2025-06-17 at 11 48 55 PM (2)](https://github.com/user-attachments/assets/deb85160-467b-44ea-a549-a496d8184d38)
![WhatsApp Image 2025-06-17 at 11 48 55 PM (3)](https://github.com/user-attachments/assets/7f938515-cd84-40df-a0e9-765073f02479)
![WhatsApp Image 2025-06-17 at 11 48 56 PM](https://github.com/user-attachments/assets/95c1eb9b-d07d-4216-b985-cb3599ceccf6)
![WhatsApp Image 2025-06-17 at 11 48 56 PM (1)](https://github.com/user-attachments/assets/798721b4-6bed-4ab1-aa82-21e339e84026)
![WhatsApp Image 2025-06-17 at 11 48 56 PM (2)](https://github.com/user-attachments/assets/7fb257e5-a9e0-48e8-8ba2-d7b7ff543137)



https://github.com/user-attachments/assets/731d8b90-1c12-494b-a66d-4acf38d488cb


