# 🎵 Musync - Full Stack Music Streaming App

**Musync** is a full-stack music streaming app built with **Flutter (frontend)** and **FastAPI (backend)**. It supports music uploads, playback, playlists, favorites, user authentication, and cloud storage — all with clean, modular architecture.

---

## 🚀 Features

### 📱 Flutter Client (Frontend)
- 🧭 **Riverpod State Management** – Scalable and testable architecture.
- 📱 **Cross-Platform** – Works on Android, iOS, and Web.
- 🎵 **Music Player UI** – Stream uploaded tracks with sleek playback design.
- 📂 **File Picker** – Upload music from device storage.
- 💚 **Favorites** – Organize and relisten easily.
- 🌐 **Responsive UI** – Optimized for multiple screen sizes.

### ⚙️ FastAPI Server (Backend)
- ⚡ **FastAPI** – Modern async Python backend.
- 🧠 **SQLAlchemy ORM** – Pythonic database models and queries.
- 🔐 **JWT Authentication** – Secure login/register.
- 🗃️ **PostgreSQL** – Relational database for tracks, users, playlists.
- ☁️ **Cloudinary** – Store and stream uploaded audio in the cloud.
- 🐳 **Dockerized Setup** – Run the entire backend via Docker.

---

## 📸 Screenshots & Demo

<table>
  <tr>
    <td align="center">
      <img src="./screenshots/welcome_screen.jpg" width="200"/><br/><b>Welcome Screen</b>
    </td>
    <td align="center">
      <img src="./screenshots/home_screen.jpg" width="200"/><br/><b>Home Screen</b>
    </td>
  </tr>
  <tr>
    <td align="center">
      <img src="./screenshots/music_player.jpg" width="200"/><br/><b>Music Player</b>
    </td>
    <td align="center">
      <img src="./screenshots/favorites.jpg" width="200"/><br/><b>Favorites</b>
    </td>
  </tr>
  <tr>
    <td colspan="2" align="center">
      <img src="./screenshots/demo.gif" width="400"/><br/><b>App Demo</b>
    </td>
  </tr>
</table>

---


## 🛠️ Project Setup

### 📁 Project Structure
musync/
├── client/        # Flutter frontend

├── server/        # FastAPI backend (Docker-ready)

---

### 📱 Flutter Frontend Setup

#### Prerequisites:
- Flutter SDK installed
- Emulator or Android/iOS device
- VS Code or Android Studio

#### Steps:
```bash
cd client
flutter pub get
flutter run
```
🧠 Make sure your backend URL in Flutter (e.g. ServerConstants) matches your host IP if testing on physical devices.

⸻

🖥️ FastAPI Backend Setup (Dockerized)

Prerequisites:
•	Docker & Docker Compose installed
•	Cloudinary account for music storage

Steps:
```bash
cd server
cp .env.example .env  # Add DB + Cloudinary credentials
docker compose up --build
```

📍 API docs available at: http://localhost:8000/docs

⸻

🔑 Environment Variables

Inside server/.env:
```bash
# PostgreSQL
DB_USER=postgres
DB_PASSWORD=your_password
DB_NAME=musync
DB_HOST=db
DB_PORT=5432

# JWT Secret
SECRET_KEY=your_jwt_secret

# Cloudinary Credentials
CLOUDINARY_API_KEY=your_key
CLOUDINARY_SECRET_KEY=your_secret
```

📬 Contact
•	GitHub: @Aman-chatterjee
•	Email: amanchatterjee121@gmail.com

⸻

Thanks for checking out Musync! 🎧✨
Star ⭐ the repo if you like it!
