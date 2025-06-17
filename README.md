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
![WhatsApp Image 2025-06-17 at 11 48 56 PM (2)](https://github.com/user-attachments/assets/392ef0cb-e41b-4b5e-8db3-6284e2776355)
![WhatsApp Image 2025-06-17 at 11 48 56 PM (1)](https://github.com/user-attachments/assets/0d6aa876-448c-4234-8eef-92b95b9277c2)
![WhatsApp Image 2025-06-17 at 11 48 56 PM](https://github.com/user-attachments/assets/a6394d40-aa68-4bff-ba66-d353178c822a)
![WhatsApp Image 2025-06-17 at 11 48 55 PM (3)](https://github.com/user-attachments/assets/7c354832-61ea-4bc8-8dff-acc6daf0a34b)
![WhatsApp Image 2025-06-17 at 11 48 55 PM (2)](https://github.com/user-attachments/assets/211a84ad-a46c-4565-a716-570c6c2cbe09)
![WhatsApp Image 2025-06-17 at 11 48 55 PM (1)](https://github.com/user-attachments/assets/703ff595-5575-4e27-90da-ac3f20825cf3)
![WhatsApp Image 2025-06-17 at 11 48 55 PM](https://github.com/user-attachments/assets/d983aa15-c2a5-4654-b881-f4aa459db3fd)

https://github.com/user-attachments/assets/32952a13-09d6-403b-bc0d-3d71e7d9bc47

