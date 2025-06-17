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

![WhatsApp Image 2025-06-17 at 11 48 56 PM (2)](https://github.com/user-attachments/assets/07b160bf-0ecd-48c0-a850-70d6e7ebdc22)
![WhatsApp Image 2025-06-17 at 11 48 56 PM (1)](https://github.com/user-attachments/assets/4142d902-e111-49c0-a32f-c99d223e6c05)
![WhatsApp Image 2025-06-17 at 11 48 56 PM](https://github.com/user-attachments/assets/5a689262-f393-4f23-8250-1d509d4c7bbd)
![WhatsApp Image 2025-06-17 at 11 48 55 PM (3)](https://github.com/user-attachments/assets/16112188-913e-42ef-b9d2-1b4b8d3394ff)
![WhatsApp Image 2025-06-17 at 11 48 55 PM (2)](https://github.com/user-attachments/assets/a7b59940-ec27-4630-aeab-77a087ce087d)
![WhatsApp Image 2025-06-17 at 11 48 55 PM (1)](https://github.com/user-attachments/assets/9b5b586a-7010-4ea0-be6b-72283e01987a)
![WhatsApp Image 2025-06-17 at 11 48 55 PM (1)](https://github.com/user-attachments/assets/b25f6baf-d0ea-4639-8516-0a925867e52e)
![WhatsApp Image 2025-06-17 at 11 48 55 PM](https://github.com/user-attachments/assets/11c70fd1-c667-4885-a14d-93595c9afe4e)
