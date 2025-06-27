# 📆 Daily Planner – Flutter To-Do App

Aplikasi **Daily Planner** adalah aplikasi to-do list sederhana berbasis Flutter yang memungkinkan pengguna mencatat, mengatur, dan menandai aktivitas harian mereka. Aplikasi ini menggunakan **Supabase** sebagai backend dan menyimpan sesi login secara lokal agar pengguna tidak perlu login ulang setiap saat.

---

## ✨ Fitur Utama

- ✅ **Autentikasi Pengguna (Sign Up, Sign In, Sign Out)**  
  Menggunakan Supabase Auth (Email/Password)

- 📝 **Manajemen To-Do Harian**  
  - Tambah aktivitas (judul, kategori, waktu)
  - Tandai aktivitas yang sudah selesai
  - Hapus aktivitas jika tidak diperlukan

- 🔒 **Session Persistence**  
  Menyimpan status login dengan SharedPreferences agar user tetap login saat aplikasi dibuka ulang

- 🚀 **Get Started Screen**  
  Menampilkan layar perkenalan saat aplikasi pertama kali di-install

- 📱 **Navigasi dan UI yang rapi & fungsional**  
  Menggunakan Material UI dan responsive layout

---

## 📦 Teknologi yang Digunakan

| Teknologi        | Keterangan                              |
|------------------|------------------------------------------|
| Flutter          | UI framework utama                       |
| Supabase         | Backend untuk Auth dan Realtime Database |
| SharedPreferences| Menyimpan status login & first open      |
| intl             | Format tanggal & waktu                   |

---

## ⚙️ Cara Install dan Build

siapin dependency seperti di pubspec.yml:
supabase_flutter: ^1.10.11
  flutter_riverpod: ^2.5.1
  shared_preferences: ^2.2.2
  intl: ^0.18.1

1. flutter pub get
2. flutter run

## Dummy Login
Email    : justin@gmail.com
Password : 123456