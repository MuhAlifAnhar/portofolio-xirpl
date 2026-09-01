# 📄 MODUL AJAR & LEMBAR KERJA PRAKTIKUM (LKS)
## PEMROGRAMAN WEB DAN PERANGKAT BERGERAK (BACKEND)
**Proyek:** Pembuatan Web Portofolio Dinamis  
**Stack Teknologi:** Express.js, MySQL, Next.js  
**Tingkat / Fase:** SMK Kelas XI / XII - Rekayasa Perangkat Lunak (Fase F)  
**Pertemuan:** 2 dari 12 Pertemuan  
**Alokasi Waktu:** 4 Jam Pelajaran (4 x 45 Menit)  
**Penyusun:** Guru Mata Pelajaran RPL  

---

## 🎯 BAGIAN I: IDENTITAS & TUJUAN PEMBELAJARAN

### A. Capaian Pembelajaran (CP)
Peserta didik mampu memahami arsitektur web modern (Client-Server), membangun web service/API berbasis Node.js dengan framework Express.js, serta melakukan pengujian fungsionalitas endpoint menggunakan metode HTTP standar.

### B. Tujuan Pembelajaran Khusus (TP)
1. Siswa dapat menjelaskan konsep dasar arsitektur Client-Server dan siklus Request-Response.
2. Siswa dapat menginstal dan mengonfigurasi paket pendukung Node.js (`dotenv`, `cors`, `nodemon`).
3. Siswa dapat mengelola konfigurasi variabel lingkungan menggunakan file `.env`.
4. Siswa dapat membangun server HTTP lokal menggunakan Express.js pada file `src/server.js`.
5. Siswa dapat membuat endpoint routing `GET` dan mengembalikan data dalam format JSON.
6. Siswa dapat menerapkan penanganan rute tidak terdaftar (Error Handler 404).
7. Siswa dapat menguji dan menganalisis respon status code HTTP melalui Browser dan Postman/Thunder Client.

---

## 🗺️ BAGIAN II: SILABUS & PETA JALAN BELAJAR (12 PERTEMUAN)

| Pertemuan | Fokus Utama | Materi / Topik Bahasan | Target Output |
| :---: | :---: | :--- | :--- |
| **01** | Backend & Frontend | Setup Node.js, Next.js, & Struktur Folder Proyek | Proyek terinisialisasi *(Selesai)* |
| **02** | **Backend** | **Web Server Express.js, `.env`, Routing Dasar, & Respon JSON** | **Server API Aktif & Endpoint Test** |
| **03** | Backend | Perancangan Database MySQL (`db_portofolio`) & Skema Tabel | Database & Tabel Terbentuk |
| **04** | Backend | Koneksi MySQL Pool (`mysql2`), Helper DB & Struktur MVC | Backend Terhubung Database |
| **05** | Backend | CRUD Modul Profil Diri (*About Me / Biodata*) | API Profil Lengkap |
| **06** | Backend | CRUD Modul Projects (*Showcase Portofolio*) | API Projects Lengkap |
| **07** | Backend | CRUD Modul Skills & Experiences (*Pengalaman*) | API Skills & Experience |
| **08** | Backend | Upload Media / Gambar menggunakan `Multer` | API Upload Gambar Berfungsi |
| **09** | Backend | Modul Kontak (Pesan Masuk) & Validasi Data Request | API Kontak & Error Handler |
| **10** | Backend | Autentikasi Admin: Hashing `bcrypt` & Proteksi `JWT` | Login Admin Aman |
| **11** | Backend | CORS Policy, Dokumentasi API, & Review Menyeluruh | Backend Selesai 100% |
| **12** | Frontend | Integrasi Frontend Next.js: Konsumsi Data API | Portofolio Dinamis Live |

---

## 📚 BAGIAN III: LANDASAN TEORI SINGKAT

### 1. Arsitektur Client-Server & Siklus Request-Response
Dalam pengembangan web modern, sistem dibagi menjadi dua bagian:
- **Client (Frontend)**: Tampilan visual website yang berinteraksi langsung dengan pengguna (misalnya Next.js).
- **Server (Backend)**: Pusat logika dan pengelola database yang memproses permintaan dari client (misalnya Express.js).

Komunikasi keduanya terjadi melalui siklus:
1. **Request (`req`)**: Klien mengirim permintaan (URL, Method GET/POST, Header, Body data).
2. **Response (`res`)**: Server memproses dan membalas dengan status HTTP (200, 404, 500) dan payload data (biasanya berformat JSON).

### 2. Apa itu Express.js?
Express.js adalah framework web minimalis untuk runtime Node.js. Express menyediakan fungsionalitas esensial seperti:
- **Routing:** Mengatur alamat URL dan method HTTP.
- **Middleware:** Fungsi perantara yang memproses request sebelum sampai ke tujuan akhir (misal: JSON parser, CORS).
- **HTTP Helpers:** Memudahkan pengiriman data JSON, redirect, dan status HTTP.

### 3. Mengapa Menggunakan Environment Variable (`.env`)?
File `.env` digunakan untuk memisahkan konfigurasi lingkungan dari kode program. Data sensitif seperti nomor port, kunci rahasia token, dan password database tidak boleh di-hardcode di dalam kode program agar aman saat diunggah ke repository publik (GitHub).

---

## 🛠️ BAGIAN IV: LANGKAH KERJA PRAKTIKUM (STEP-BY-STEP)

```
[Struktur Folder yang Dituju]
porto/
└── backend/
    ├── .env                <-- (Dibuat pada Langkah 4)
    ├── package.json        <-- (Dikonfigurasi pada Langkah 2 & 3)
    └── src/
        └── server.js       <-- (Ditulis pada Langkah 5)
```

---

### Langkah 1: Navigasi ke Folder Backend
Buka terminal VS Code Anda, lalu pastikan direktori kerja berada di folder `backend`:
```bash
cd backend
```

---

### Langkah 2: Menginstal Paket Dependensi
Jalankan perintah berikut di terminal untuk mengunduh paket pendukung:
```bash
npm install dotenv cors
npm install -D nodemon
```

**Rincian Dependensi:**
- `dotenv`: Membaca variabel dari file `.env` ke `process.env`.
- `cors`: Mengizinkan komunikasi lintas domain (*Cross-Origin Resource Sharing*).
- `nodemon`: Menjalankan server otomatis *auto-reload* setiap ada perubahan kode.

---

### Langkah 3: Menyiapkan Script Eksekusi di `package.json`
Buka file `backend/package.json`. Tambahkan perintah `"start"` dan `"dev"` pada bagian `"scripts"`:

```json
{
  "name": "backend",
  "version": "1.0.0",
  "description": "Backend API Portfolio",
  "main": "src/server.js",
  "scripts": {
    "start": "node src/server.js",
    "dev": "nodemon src/server.js"
  },
  "keywords": [],
  "author": "",
  "license": "ISC",
  "dependencies": {
    "cors": "^2.8.6",
    "dotenv": "^17.4.2",
    "express": "^5.2.1"
  },
  "devDependencies": {
    "nodemon": "^3.1.14"
  }
}
```

---

### Langkah 4: Membuat File Konfigurasi `.env`
Buat file baru dengan nama `.env` di dalam folder `backend/` (satu tingkat dengan `package.json`):

```env
# Konfigurasi Server
PORT=5000
NODE_ENV=development
```

---

### Langkah 5: Menulis Kode Web Server di `src/server.js`
Buka file `backend/src/server.js` dan ketikkan kode lengkap berikut:

```javascript
// ==========================================
// 1. IMPORT MODUL / LIBRARY
// ==========================================
const express = require('express');
const dotenv = require('dotenv');
const cors = require('cors');

// ==========================================
// 2. MEMUAT FILE KONFIGURASI .ENV
// ==========================================
dotenv.config();

// ==========================================
// 3. INISIALISASI APLIKASI EXPRESS & PORT
// ==========================================
const app = express();
const PORT = process.env.PORT || 5000;

// ==========================================
// 4. MIDDLEWARE DASAR
// ==========================================
app.use(cors()); // Izin akses dari frontend lintas domain
app.use(express.json()); // Membaca body request format JSON
app.use(express.urlencoded({ extended: true })); // Membaca body request format url-encoded

// ==========================================
// 5. ROUTING / ENDPOINT DASAR
// ==========================================
// Endpoint Utama (Root)
app.get('/', (req, res) => {
    res.status(200).json({
        success: true,
        message: 'Selamat datang di API Portofolio Dinamis!',
        version: '1.0.0'
    });
});

// Endpoint Status Server
app.get('/api/status', (req, res) => {
    res.status(200).json({
        success: true,
        message: 'Server dalam keadaan sehat dan aktif.',
        timestamp: new Date().toISOString()
    });
});

// ==========================================
// 6. PENANGANAN ROUTE 404 (NOT FOUND)
// ==========================================
app.use((req, res) => {
    res.status(404).json({
        success: false,
        message: 'Endpoint tidak ditemukan!'
    });
});

// ==========================================
// 7. MENJALANKAN SERVER
// ==========================================
app.listen(PORT, () => {
    console.log(`========================================`);
    console.log(`🚀 Server berjalan di: http://localhost:${PORT}`);
    console.log(`📡 Mode: ${process.env.NODE_ENV || 'development'}`);
    console.log(`========================================`);
});
```

---

### 📖 Tabel Bedah Kode `server.js`

| Baris Kode | Penjelasan Teknis |
| :--- | :--- |
| `const express = require('express')` | Mengimpor framework Express ke dalam konstanta `express`. |
| `dotenv.config()` | Membaca file `.env` dan menyuntikkan variabelnya ke `process.env`. |
| `const app = express()` | Menginisialisasi instance aplikasi Express sebagai objek utama penampung route. |
| `const PORT = process.env.PORT \|\| 5000` | Menentukan port server dari file `.env`, dengan fallback ke port `5000`. |
| `app.use(cors())` | Middleware pembuka izin CORS agar API dapat dikonsumsi frontend Next.js. |
| `app.use(express.json())` | Middleware pengurai (*body-parser*) agar Express mampu membaca data JSON yang dikirimkan klien. |
| `app.get(path, (req, res) => {...})` | Mendaftarkan route HTTP berjenis `GET` pada alamat `path`. |
| `res.status(200).json({...})` | Mengirim respon balik dengan HTTP status `200 (OK)` dan konten berformat JSON. |
| `app.use((req, res) => {...})` | Middleware fallback yang dieksekusi saat tidak ada rute yang cocok (`404 Not Found`). |
| `app.listen(PORT, callback)` | Menjalankan server pada port yang ditentukan dan mengeksekusi fungsi *callback*. |

---

### Langkah 6: Menjalankan Server
Jalankan server pengembangan dengan mengetikkan perintah berikut:
```bash
npm run dev
```

**Output Terminal:**
```text
[nodemon] starting `node src/server.js`
========================================
🚀 Server berjalan di: http://localhost:5000
📡 Mode: development
========================================
```

---

### Langkah 7: Pengujian Endpoint API

#### 1. Pengujian Melalui Browser
Buka browser dan kunjungi alamat berikut:
1. `http://localhost:5000/`
   ```json
   {
     "success": true,
     "message": "Selamat datang di API Portofolio Dinamis!",
     "version": "1.0.0"
   }
   ```
2. `http://localhost:5000/api/status`
   ```json
   {
     "success": true,
     "message": "Server dalam keadaan sehat dan aktif.",
     "timestamp": "2026-09-01T01:05:46.175Z"
   }
   ```
3. `http://localhost:5000/api/halaman-tidak-ada`
   ```json
   {
     "success": false,
     "message": "Endpoint tidak ditemukan!"
   }
   ```

#### 2. Pengujian Melalui Postman / Thunder Client (VS Code)
1. Buka Thunder Client / Postman.
2. Buat Request Baru $\rightarrow$ Method: `GET` $\rightarrow$ URL: `http://localhost:5000/api/status`.
3. Klik **Send**.
4. Amati bahwa Status Code bernilai **`200 OK`** dan format body adalah **JSON**.

---

## 📝 BAGIAN V: LEMBAR KERJA SISWA (LKS) & TUGAS MANDIRI

**Nama Siswa:** ___________________________  
**Kelas / No. Presensi:** ___________________________  
**Tanggal Pengerjaan:** ___________________________  

### Instruksi Tugas:
1. **Tugas Praktik 1 (Membuat Endpoint Biodata):**
   Tambahkan sebuah endpoint baru di file `src/server.js` dengan spesifikasi:
   - **Method:** `GET`
   - **Endpoint:** `/api/profile`
   - **Format Output JSON:**
     ```json
     {
       "success": true,
       "data": {
         "nama": "Nama Lengkap Anda",
         "kelas": "XI RPL 1",
         "jurusan": "Rekayasa Perangkat Lunak",
         "keahlian": ["JavaScript", "HTML", "CSS", "Express.js"],
         "bio": "Siswa RPL yang antusias belajar backend development."
       }
     }
     ```
2. **Tugas Praktik 2 (Eksperimen Port):**
   Ubah nilai `PORT` di dalam file `.env` menjadi `8080`. Amati log terminal dan lakukan uji coba akses di browser dengan URL `http://localhost:8080/`.

---

## 📊 BAGIAN VI: RUBRIK PENILAIAN PRAKTIKUM

| No | Aspek Penilaian | Kriteria | Skor Maks | Skor Perolehan |
| :---: | :--- | :--- | :---: | :---: |
| 1 | **Setup & Konfigurasi** | Berhasil menginstal paket, konfigurasi `.env`, dan `package.json` | 20 | |
| 2 | **Implementasi Server** | Kode `server.js` rapi, menerapkan middleware dan port dengan benar | 30 | |
| 3 | **Struktur Respon JSON** | Respon endpoint menggunakan format standar (`success`, `message`, `data`) | 20 | |
| 4 | **Tugas Mandiri (Biodata)** | Berhasil menambahkan endpoint `/api/profile` dan berjalan dengan baik | 20 | |
| 5 | **Pengujian & Pemecahan Masalah** | Mampu melakukan pengujian endpoint dan menjelaskan hasilnya | 10 | |
| **TOTAL SKOR** | | | **100** | |

---

## ❓ BAGIAN VII: PANDUAN PEMECAHAN MASALAH (TROUBLESHOOTING)

1. **Kendala:** `Error: listen EADDRINUSE: address already in use :::5000`
   - *Penyebab:* Port 5000 sedang digunakan oleh aplikasi lain atau server sebelumnya belum dihentikan.
   - *Solusi:* Tekan `Ctrl + C` pada terminal lama untuk mematikan server, atau ganti `PORT=5001` di file `.env`.
2. **Kendala:** `Error: Cannot find module 'express'`
   - *Penyebab:* Perintah instalasi belum dijalankan di folder yang tepat.
   - *Solusi:* Pastikan terminal berada di folder `backend`, lalu ketik `npm install`.
3. **Kendala:** Error script execution policy di PowerShell Windows
   - *Solusi:* Gunakan Command Prompt (cmd) atau jalankan `npx nodemon src/server.js`.
