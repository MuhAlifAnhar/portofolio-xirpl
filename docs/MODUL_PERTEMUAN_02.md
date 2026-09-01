# 📚 MODUL PEMBELAJARAN: PEMROGRAMAN WEB BACKEND (EXPRESS.JS)
## Proyek: Pembuatan Web Portofolio Dinamis
**Tingkat / Kelas:** SMK Jurusan RPL / Informatika  
**Alokasi Waktu:** 12 Pertemuan (11 Pertemuan Backend + 1 Pertemuan Frontend)  
**Pertemuan ke-2:** *Dasar Web Server Express.js, Environment Variable, Basic Routing, & JSON Response*

---

## 🎯 Tujuan Pembelajaran
Setelah mengikuti pertemuan ini, siswa diharapkan mampu:
1. Memahami konsep arsitektur **Client-Server** dan siklus **Request-Response (Req-Res)**.
2. Memahami peran **Express.js** sebagai web framework backend berbasis Node.js.
3. Menginstal dan mengonfigurasi dependensi pendukung (`dotenv`, `nodemon`, `cors`).
4. Mengonfigurasi file `.env` untuk menyimpan variabel lingkungan secara aman.
5. Menulis dan menjalankan server web pertama menggunakan Express.js di `src/server.js`.
6. Membuat endpoint routing dasar dengan metode `GET` dan mengembalikan respon berformat **JSON**.
7. Menangani error **404 Not Found** dengan middleware sederhana.
8. Melakukan pengujian API menggunakan Web Browser dan **Postman / Thunder Client**.

---

## 🗺️ Peta Kurikulum (Roadmap 12 Pertemuan)

| Pertemuan | Fokus | Materi Pokok |
| :---: | :---: | :--- |
| **01** | Backend & Frontend | Setup Environment, Inisialisasi Node.js & Next.js, Struktur Folder Proyek *(Selesai)* |
| **02** | **Backend** | **Web Server Express.js, Routing Dasar, JSON Response, & Testing Endpoint** *(Hari Ini)* |
| **03** | Backend | Perancangan Database MySQL (`db_portofolio`) & Skema Tabel Lengkap |
| **04** | Backend | Koneksi Database MySQL Pool (`mysql2`), Konfigurasi Database di `.env` |
| **05** | Backend | Arsitektur MVC & CRUD 1: Modul Profil Diri (About Me) |
| **06** | Backend | CRUD 2: Modul Projects / Karya Portofolio |
| **07** | Backend | CRUD 3: Modul Skills & Experiences (Pengalaman) |
| **08** | Backend | Upload Media / Gambar (Thumbnail & Foto Profil) menggunakan `Multer` |
| **09** | Backend | Modul Kontak (Pesan Masuk), Validasi Input Data & Global Error Handler |
| **10** | Backend | Autentikasi Admin: Register/Login, Hashing Password (`bcrypt`), & Proteksi Route (`JWT`) |
| **11** | Backend | Finalisasi Backend: CORS Policy, Dokumentasi API Endpoint, & Pengujian Total |
| **12** | Frontend | Integrasi Frontend Next.js: Fetching Data API ke Tampilan Portofolio Dinamis |

---

## 📖 Ringkasan Teori Dasar

### 1. Apa itu Express.js?
**Express.js** adalah framework minimalis dan fleksibel untuk **Node.js** yang dirancang untuk membangun aplikasi web dan RESTful API (Application Programming Interface).
- Tanpa Express, membuat web server di Node.js membutuhkan modul bawaan `http` yang kodenya panjang dan rumit.
- Dengan Express, kita dapat membuat route, mengolah data JSON, dan menambahkan middleware hanya dengan beberapa baris kode.

### 2. Siklus Request & Response (Req & Res)
Dalam pengembangan web backend, komunikasi terjadi secara dua arah:
- **Request (`req`)**: Data atau permintaan yang dikirim oleh Client (Browser, Postman, Frontend Next.js) ke Server. Contoh data yang dibawa: URL, HTTP Method, Query Params, Header, dan Body Request.
- **Response (`res`)**: Jawaban atau balasan yang dikirim oleh Server ke Client. Contoh: Status code (200, 404, 500) dan data berupa JSON.

### 3. Mengapa Menggunakan `.env` (Environment Variable)?
File `.env` digunakan untuk menyimpan konfigurasi sensitif seperti port server, password database, dan secret key. Tujuannya adalah agar informasi rahasia tidak bocor saat kode diunggah ke GitHub.

---

## 🛠️ Langkah Praktikum (Step-by-Step)

### Langkah 1: Membuka Folder Backend
Buka terminal dan pastikan kamu berada di dalam direktori `backend`:
```bash
cd backend
```

---

### Langkah 2: Instalasi Dependensi Pendukung
Pada Pertemuan 1, kita sudah menginstal `express`. Sekarang kita tambahkan paket:
1. `dotenv` : Untuk membaca konfigurasi dari file `.env`.
2. `cors` : Agar backend kita nantinya dapat diakses oleh frontend Next.js tanpa kendala CORS (Cross-Origin Resource Sharing).
3. `nodemon` *(Dev Dependency)* : Menjalankan server otomatis restart setiap kali ada file kode yang diubah/disimpan.

Jalankan perintah berikut di terminal:
```bash
npm install dotenv cors
npm install -D nodemon
```

---

### Langkah 3: Menyiapkan Script di `package.json`
Buka file `package.json` di dalam folder `backend`, lalu perbarui bagian `"scripts"` menjadi seperti berikut:

```json
{
  "name": "backend",
  "version": "1.0.0",
  "main": "src/server.js",
  "scripts": {
    "start": "node src/server.js",
    "dev": "nodemon src/server.js"
  },
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

> 💡 **Penjelasan Script:**
> - `npm run dev`: Menjalankan server dengan `nodemon` selama proses belajar/development.
> - `npm start`: Menjalankan server dalam mode produksi standar Node.js.

---

### Langkah 4: Membuat File Konfigurasi `.env`
Buat file baru bernama `.env` di dalam folder `backend/` (sejajar dengan `package.json`):

```env
# Konfigurasi Server
PORT=5000
NODE_ENV=development
```

---

### Langkah 5: Menulis Kode Utama Server di `src/server.js`
Buka file `src/server.js` dan ketikkan kode berikut:

```javascript
// 1. Import library yang dibutuhkan
const express = require('express');
const dotenv = require('dotenv');
const cors = require('cors');

// 2. Load konfigurasi dari file .env
dotenv.config();

// 3. Inisialisasi aplikasi Express
const app = express();
const PORT = process.env.PORT || 5000;

// 4. Middleware dasar
app.use(cors()); // Mengizinkan request dari aplikasi lain (Frontend)
app.use(express.json()); // Membaca body request bertipe JSON
app.use(express.urlencoded({ extended: true })); // Membaca body request bertipe form-data

// 5. Endpoint dasar (Testing Server)
// URL: http://localhost:5000/
app.get('/', (req, res) => {
    res.status(200).json({
        success: true,
        message: 'Selamat datang di API Portofolio Dinamis!',
        version: '1.0.0'
    });
});

// Endpoint untuk cek status API
// URL: http://localhost:5000/api/status
app.get('/api/status', (req, res) => {
    res.status(200).json({
        success: true,
        message: 'Server dalam keadaan sehat dan aktif.',
        timestamp: new Date().toISOString()
    });
});

// 6. Middleware untuk menangani route yang tidak ditemukan (404 Not Found)
app.use((req, res) => {
    res.status(404).json({
        success: false,
        message: 'Endpoint tidak ditemukan!'
    });
});

// 7. Menjalankan server
app.listen(PORT, () => {
    console.log(`========================================`);
    console.log(`🚀 Server berjalan di: http://localhost:${PORT}`);
    console.log(`📡 Environment: ${process.env.NODE_ENV || 'development'}`);
    console.log(`========================================`);
});
```

---

### Langkah 6: Menjalankan Server
Buka terminal dan jalankan perintah:
```bash
npm run dev
```

Jika berhasil, terminal akan menampilkan:
```text
========================================
🚀 Server berjalan di: http://localhost:5000
📡 Environment: development
========================================
```

---

## 🧪 Pengujian API (Testing)

### 1. Menguji via Browser
Buka Google Chrome / browser pilihanmu, lalu akses:
1. `http://localhost:5000/`  
   **Hasil yang diharapkan:**
   ```json
   {
     "success": true,
     "message": "Selamat datang di API Portofolio Dinamis!",
     "version": "1.0.0"
   }
   ```
2. `http://localhost:5000/api/status`  
   **Hasil yang diharapkan:** Status server aktif beserta timestamp waktu saat ini.
3. `http://localhost:5000/halaman-asal`  
   **Hasil yang diharapkan:** Status 404 `"Endpoint tidak ditemukan!"`.

### 2. Menguji via Postman / Thunder Client (VS Code Extension)
1. Buat request baru dengan method **`GET`**.
2. Masukkan URL `http://localhost:5000/`.
3. Klik tombol **Send**.
4. Periksa **Status Code** (harus `200 OK`) dan tampilan **Body Response** (JSON).

---

## 🧠 Bedah Kode (Penjelasan Mendalam untuk Siswa)

| Baris Kode | Fungsi & Makna |
| :--- | :--- |
| `const app = express()` | Membuat instance utama dari aplikasi Express. Objek `app` inilah yang akan menampung routing, middleware, dan konfigurasi server. |
| `dotenv.config()` | Membaca variabel di file `.env` sehingga bisa diakses lewat `process.env.NAMA_VARIABEL`. |
| `app.use(express.json())` | Middleware bawaan Express untuk mem-parsing data JSON yang dikirimkan oleh client di dalam body request. |
| `app.get(path, handler)` | Mendaftarkan route dengan method HTTP `GET`. Ketika user membuka alamat `path`, fungsi handler `(req, res)` akan dieksekusi. |
| `res.status(200).json(...)` | Mengirimkan kode status HTTP 200 (Success) beserta data berformat JSON kepada pengirim request. |
| `app.listen(PORT, ...)` | Menginstruksikan server untuk mulai mendengarkan lalu lintas koneksi pada nomor port tertentu. |

---

## 📝 Latihan Mandiri / Tugas Siswa
1. **Latihan 1:** Tambahkan sebuah route baru `GET /api/info` yang mengembalikan data biodata singkat pembuat portofolio (misal: `nama`, `kelas`, `jurusan`, `cita_cita`) dalam format JSON.
2. **Latihan 2:** Coba ubah nilai `PORT=8000` di file `.env`, lalu perhatikan di terminal apakah `nodemon` me-restart server secara otomatis dan server berjalan di port yang baru.

---

## ❓ FAQ & Troubleshooting
- **Error: `EADDRINUSE: address already in use :::5000`**
  - *Penyebab:* Port 5000 sedang digunakan oleh aplikasi lain atau terminal sebelumnya belum ditutup (`Ctrl + C`).
  - *Solusi:* Tutup terminal yang sedang aktif atau ganti nilai `PORT` di `.env` menjadi `5001` atau `8000`.
- **Nodemon tidak mau jalan di Windows (`running scripts is disabled on this system`)**
  - *Solusi:* Buka PowerShell sebagai Administrator dan jalankan: `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser`, atau jalankan sementara dengan `npx nodemon src/server.js`.
