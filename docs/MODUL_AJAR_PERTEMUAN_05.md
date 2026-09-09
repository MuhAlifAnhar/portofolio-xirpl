# 📄 MODUL AJAR & LEMBAR KERJA PRAKTIKUM (LKS)
## PEMROGRAMAN WEB DAN PERANGKAT BERGERAK (BACKEND)
**Proyek:** Pembuatan Web Portofolio Dinamis  
**Stack Teknologi:** Express.js, MySQL, Next.js  
**Tingkat / Fase:** SMK Kelas XI / XII - Rekayasa Perangkat Lunak (Fase F)  
**Pertemuan:** 5 dari 12 Pertemuan  
**Alokasi Waktu:** 4 Jam Pelajaran (4 x 45 Menit)  
**Materi Pokok:** Implementasi Arsitektur MVC & CRUD Bagian 1 — Modul Profil Diri (*About Me*)

---

## 🎯 BAGIAN I: TUJUAN PEMBELAJARAN

### Tujuan Pembelajaran Khusus (TP)
1. Siswa dapat menerapkan pola arsitektur **MVC (Model-View-Controller)** secara langsung dalam proyek Express.js nyata.
2. Siswa mampu membuat file **Model** yang berisi fungsi-fungsi query database.
3. Siswa mampu membuat file **Controller** yang mengolah logika request-response.
4. Siswa mampu membuat file **Routes** yang mendaftarkan alamat endpoint API.
5. Siswa dapat mendaftarkan (*register*) route modul ke dalam file utama `server.js`.
6. Siswa memahami penggunaan **`async/await`** dan blok **`try...catch`** dalam penanganan proses asinkronus (query database).
7. Siswa dapat menguji endpoint **`GET`** (Ambil Data) dan **`PUT`** (Perbarui Data) menggunakan Postman/Thunder Client.

---

## 🗺️ BAGIAN II: POSISI PERTEMUAN DALAM SILABUS

| Pertemuan | Status | Materi Pokok | Target Output |
| :---: | :---: | :--- | :--- |
| **04** | Selesai | Koneksi Database MySQL Pool (`mysql2`) & MVC | Backend Terhubung DB |
| **05** | **Hari Ini** | **CRUD 1: Modul Profil Diri (*About Me*)** | **Endpoint GET & PUT Profile** |
| **06** | Berikutnya| CRUD 2: Modul Projects (*Portofolio Karya*) | Endpoint CRUD Projects |

---

## 📚 BAGIAN III: LANDASAN TEORI

### 1. Arsitektur MVC dalam Praktik Nyata
Di Pertemuan 4, kita sudah mengenal teori MVC. Sekarang kita terapkan langsung:

```
[Client / Postman]
      │
      │  Request: GET /api/profile
      ▼
 ┌──────────┐     ┌────────────────────┐     ┌──────────────────┐
 │  ROUTES   │ ──► │   CONTROLLER       │ ──► │     MODEL        │
 │ (Alamat)  │     │ (Logika Bisnis)    │     │ (Query Database) │
 └──────────┘     └────────────────────┘     └──────────────────┘
                           │                         │
                           │◄────── data profil ◄────┘
                           │
                           ▼
                    Response: JSON { success, data }
```

- **Routes** (`profileRoutes.js`): Menentukan alamat URL dan method HTTP, lalu mengarahkannya ke controller.
- **Controller** (`profileController.js`): Menerima request, memanggil fungsi di model, memproses hasilnya, lalu mengirim response JSON.
- **Model** (`profileModel.js`): Berisi fungsi-fungsi yang menjalankan query SQL ke database MySQL.

### 2. Async/Await & Try...Catch
Karena query ke database membutuhkan waktu (bersifat *asinkronus*), kita menggunakan:
- `async`: Menandai sebuah fungsi sebagai fungsi yang berjalan secara asinkronus.
- `await`: Menunggu sampai query database selesai sebelum baris kode berikutnya dieksekusi.
- `try...catch`: Menangkap error yang terjadi agar server tidak langsung *crash*. Jika terjadi error, blok `catch` akan mengirimkan pesan error yang rapi.

### 3. Mengapa Profile Hanya GET & PUT?
Karena pemilik portofolio hanya ada 1 orang, maka:
- **Tidak perlu CREATE (POST)**: Data awal sudah di-seed di Pertemuan 3.
- **Tidak perlu DELETE**: Kita tidak ingin profil dihapus.
- **GET**: Untuk mengambil dan menampilkan data profil ke frontend.
- **PUT**: Untuk memperbarui seluruh data profil saat admin ingin mengubah bio, kontak, dll.

---

## 🛠️ BAGIAN IV: LANGKAH KERJA PRAKTIKUM (STEP-BY-STEP)

```
[Struktur File yang Akan Dibuat Hari Ini]
backend/
└── src/
    ├── config/
    │   └── db.js              (Sudah ada dari Pertemuan 4)
    ├── models/
    │   └── profileModel.js    ◄── BARU (Langkah 1)
    ├── controller/
    │   └── profileController.js ◄── BARU (Langkah 2)
    ├── routes/
    │   └── profileRoutes.js   ◄── BARU (Langkah 3)
    └── server.js              ◄── DIPERBARUI (Langkah 4)
```

---

### **Langkah 1: Membuat Model Profil (`models/profileModel.js`)**
Model adalah file yang khusus mengurusi komunikasi dengan database (query SQL).

Buat file baru `backend/src/models/profileModel.js`, lalu tuliskan kode berikut:

```javascript
const db = require('../config/db');

// 1. Mengambil data profil (hanya 1 baris, karena profil hanya 1 pemilik)
const getProfile = async () => {
    const [rows] = await db.query('SELECT * FROM profile LIMIT 1');
    return rows[0]; // Ambil baris pertama saja
};

// 2. Memperbarui data profil berdasarkan ID
const updateProfile = async (id, data) => {
    const {
        name, role, bio, about, avatar_url, resume_url,
        email, phone, address, github_url, linkedin_url, instagram_url
    } = data;

    const [result] = await db.query(
        `UPDATE profile SET 
            name = ?, role = ?, bio = ?, about = ?, 
            avatar_url = ?, resume_url = ?,
            email = ?, phone = ?, address = ?, 
            github_url = ?, linkedin_url = ?, instagram_url = ?
        WHERE id = ?`,
        [name, role, bio, about, avatar_url, resume_url,
         email, phone, address, github_url, linkedin_url, instagram_url, id]
    );
    return result;
};

module.exports = {
    getProfile,
    updateProfile
};
```

> 💡 **Penjelasan Baris Penting:**
> - `const [rows] = await db.query(...)`: Menjalankan query SQL dan hasilnya ditampung di variabel `rows`. Tanda kurung siku `[rows]` disebut *destructuring* (membongkar array).
> - `rows[0]`: Mengambil baris data pertama saja (karena profil hanya ada 1).
> - Tanda `?` dalam query SQL: Disebut *Prepared Statement* / *Parameterized Query*. Tanda tanya ini akan diganti oleh nilai-nilai dari array parameter di bawahnya. Teknik ini sangat penting untuk mencegah serangan **SQL Injection** (hacker menyisipkan kode jahat lewat input).
> - `module.exports = {...}`: Mengekspor fungsi agar bisa dipanggil dari file lain (Controller).

---

### **Langkah 2: Membuat Controller Profil (`controller/profileController.js`)**
Controller bertugas sebagai "otak" yang menjembatani antara permintaan pengguna (Request) dan data dari Model, lalu meracik balasan (Response) dalam format JSON.

Buat file baru `backend/src/controller/profileController.js`:

```javascript
const profileModel = require('../models/profileModel');

// 1. Controller: Mengambil data profil
const getProfile = async (req, res) => {
    try {
        const profile = await profileModel.getProfile();

        // Jika data profil belum ada di database
        if (!profile) {
            return res.status(404).json({
                success: false,
                message: 'Data profil belum tersedia.'
            });
        }

        res.status(200).json({
            success: true,
            message: 'Berhasil mengambil data profil.',
            data: profile
        });
    } catch (error) {
        console.error('Error getProfile:', error.message);
        res.status(500).json({
            success: false,
            message: 'Terjadi kesalahan pada server.',
            error: error.message
        });
    }
};

// 2. Controller: Memperbarui data profil
const updateProfile = async (req, res) => {
    try {
        const { id } = req.params;
        const data = req.body;

        // Validasi sederhana: pastikan nama dan role tidak kosong
        if (!data.name || !data.role) {
            return res.status(400).json({
                success: false,
                message: 'Kolom "name" dan "role" wajib diisi!'
            });
        }

        const result = await profileModel.updateProfile(id, data);

        // Cek apakah ada baris yang ter-update
        if (result.affectedRows === 0) {
            return res.status(404).json({
                success: false,
                message: `Profil dengan ID ${id} tidak ditemukan.`
            });
        }

        res.status(200).json({
            success: true,
            message: 'Data profil berhasil diperbarui.'
        });
    } catch (error) {
        console.error('Error updateProfile:', error.message);
        res.status(500).json({
            success: false,
            message: 'Terjadi kesalahan pada server.',
            error: error.message
        });
    }
};

module.exports = {
    getProfile,
    updateProfile
};
```

> 💡 **Penjelasan Baris Penting:**
> - `async (req, res) => {...}`: Setiap fungsi controller menerima objek Request (`req`) dan Response (`res`).
> - `try {...} catch (error) {...}`: Blok penanganan error. Jika query database gagal, kode di dalam `catch` yang dieksekusi, sehingga server tetap hidup dan mengirimkan pesan error yang rapi (`500 Internal Server Error`).
> - `req.params`: Mengambil parameter dari URL (misal: `/api/profile/:id`, maka `req.params.id` akan bernilai angka ID-nya).
> - `req.body`: Mengambil data JSON yang dikirimkan oleh klien di dalam body request (misal: nama, bio, dll).
> - `result.affectedRows`: Properti dari MySQL yang memberitahu berapa banyak baris data yang terpengaruh oleh query UPDATE. Jika `0`, berarti tidak ada data yang cocok.
> - **Validasi `!data.name || !data.role`**: Pengecekan sederhana sebelum data masuk ke database. Jika `name` atau `role` kosong, server langsung menolak dengan status `400 Bad Request`.

---

### **Langkah 3: Membuat Routes Profil (`routes/profileRoutes.js`)**
File Routes bertugas mendaftarkan alamat-alamat URL (endpoint) dan mengarahkannya ke fungsi controller yang sesuai.

Buat file baru `backend/src/routes/profileRoutes.js`:

```javascript
const express = require('express');
const router = express.Router();
const profileController = require('../controller/profileController');

// GET /api/profile - Mengambil data profil pemilik portofolio
router.get('/', profileController.getProfile);

// PUT /api/profile/:id - Memperbarui data profil berdasarkan ID
router.put('/:id', profileController.updateProfile);

module.exports = router;
```

> 💡 **Penjelasan:**
> - `express.Router()`: Membuat mini-router terpisah dari `server.js`. Ini membuat kode lebih rapi karena setiap modul (Profile, Projects, Skills, dll) punya file route sendiri.
> - `router.get('/', ...)`: Artinya route `GET` di path dasar. Nanti di `server.js` kita pasangkan dengan prefix `/api/profile`, sehingga URL lengkapnya menjadi `GET /api/profile`.
> - `router.put('/:id', ...)`: Tanda `:id` disebut *Route Parameter*. Misalnya jika URL yang dipanggil adalah `/api/profile/1`, maka `req.params.id` bernilai `1`.

---

### **Langkah 4: Mendaftarkan Route di File Utama `server.js`**
Buka file `backend/src/server.js`, lalu tambahkan baris berikut **di atas** middleware penanganan Error 404:

```javascript
// ==========================================
// ROUTES API (Mendaftarkan route dari folder routes/)
// ==========================================
const profileRoutes = require('./routes/profileRoutes');
app.use('/api/profile', profileRoutes);

// 6. Middleware untuk menangani route yang tidak ditemukan (404 Not Found)
app.use((req, res) => {
    // ... kode 404 yang sudah ada ...
});
```

> 💡 **Penjelasan:**
> - `app.use('/api/profile', profileRoutes)`: Memasang semua route dari `profileRoutes.js` di bawah prefix `/api/profile`. Sehingga:
>   - `router.get('/')` → menjadi `GET /api/profile`
>   - `router.put('/:id')` → menjadi `PUT /api/profile/1`
> - **PENTING:** Baris ini harus ditulis **sebelum** middleware 404! Jika ditaruh sesudahnya, route profil tidak akan pernah terjangkau.

---

### **Langkah 5: Menjalankan & Menguji API Profil**
Pastikan MySQL XAMPP menyala, lalu jalankan server:
```bash
npm run dev
```

#### **A. Uji GET (Mengambil Data Profil)**
Buka **Thunder Client / Postman**, lalu buat request:
- **Method:** `GET`
- **URL:** `http://localhost:5000/api/profile`
- Klik **Send**

**Hasil yang Diharapkan (Status 200 OK):**
```json
{
    "success": true,
    "message": "Berhasil mengambil data profil.",
    "data": {
        "id": 1,
        "name": "Ahmad Fauzi",
        "role": "Junior Fullstack Web Developer",
        "bio": "Siswa RPL yang antusias...",
        "about": "Halo! Saya seorang siswa SMK...",
        "email": "ahmad.fauzi@example.com",
        "phone": "+6281234567890",
        "address": "Jakarta, Indonesia",
        "github_url": "https://github.com/ahmadfauzi",
        "linkedin_url": "https://linkedin.com/in/ahmadfauzi",
        "instagram_url": "https://instagram.com/ahmadfauzi",
        "created_at": "2026-09-01T...",
        "updated_at": "2026-09-01T..."
    }
}
```

#### **B. Uji PUT (Memperbarui Data Profil)**
Buat request baru di Thunder Client / Postman:
- **Method:** `PUT`
- **URL:** `http://localhost:5000/api/profile/1`
- Klik tab **Body** → pilih **JSON**
- Masukkan isi body berikut:

```json
{
    "name": "Nama Lengkap Kamu",
    "role": "Web Developer & Siswa RPL",
    "bio": "Saya adalah siswa RPL kelas XI yang sedang belajar backend.",
    "about": "Saya senang belajar pemrograman web, terutama Express.js dan Next.js.",
    "avatar_url": "",
    "resume_url": "",
    "email": "emailkamu@gmail.com",
    "phone": "+6281234567890",
    "address": "Kota Kamu, Indonesia",
    "github_url": "https://github.com/usernamekamu",
    "linkedin_url": "",
    "instagram_url": "https://instagram.com/igkamu"
}
```
- Klik **Send**

**Hasil yang Diharapkan (Status 200 OK):**
```json
{
    "success": true,
    "message": "Data profil berhasil diperbarui."
}
```

#### **C. Verifikasi Perubahan**
Lakukan kembali request `GET /api/profile` untuk membuktikan bahwa data telah berubah sesuai dengan yang baru saja kita kirimkan.

---

## 📝 BAGIAN V: LEMBAR KERJA SISWA (LKS) & TUGAS MANDIRI

**Nama Siswa:** ___________________________  
**Kelas / No. Presensi:** ___________________________  

### Instruksi Tugas:
1. **Tugas Praktik 1 (Update Profil Diri):**  
   Gunakan method `PUT` untuk memperbarui data di tabel `profile` menjadi data diri Anda sendiri (nama, email, bio, alamat, media sosial). Sertakan screenshot hasil response JSON dari Postman/Thunder Client!
2. **Tugas Praktik 2 (Validasi Error):**  
   Kirimkan request `PUT` dengan body JSON yang TIDAK memiliki field `name` (sengaja dikosongkan). Tuliskan pesan error apa yang muncul dan status code HTTP berapa yang dikembalikan oleh server!
3. **Tugas Analisis:**  
   Jelaskan mengapa di dalam fungsi Model kita menggunakan tanda `?` (*Parameterized Query*) alih-alih langsung menuliskan nilai datanya ke dalam string SQL!

---

## 📊 BAGIAN VI: RUBRIK PENILAIAN PRAKTIKUM

| No | Aspek Penilaian | Kriteria Evaluasi | Skor Maks | Skor Perolehan |
| :---: | :--- | :--- | :---: | :---: |
| 1 | **Pembuatan Model** | File `profileModel.js` berjalan tanpa error, query SQL benar | 20 | |
| 2 | **Pembuatan Controller** | File `profileController.js` menerapkan `async/await` dan `try...catch` | 20 | |
| 3 | **Pembuatan Route & Registrasi** | Route terdaftar di `server.js`, endpoint `GET` dan `PUT` aktif | 20 | |
| 4 | **Pengujian GET & PUT** | Berhasil menguji kedua endpoint dan mendapatkan response JSON yang benar | 20 | |
| 5 | **Tugas Mandiri & Analisis** | Menyelesaikan tugas LKS dan menjawab pertanyaan analisis dengan tepat | 20 | |
| **TOTAL SKOR** | | | **100** | |

---

## ❓ BAGIAN VII: TROUBLESHOOTING

| Gejala Masalah | Penyebab | Cara Mengatasi |
| :--- | :--- | :--- |
| `Cannot find module '../config/db'` | Path import salah atau file `db.js` belum dibuat. | Periksa lokasi file `db.js` di `src/config/`. |
| `req.body is undefined` saat PUT | Body request tidak dikirim sebagai JSON, atau lupa `express.json()`. | Pastikan tab Body di Postman diset ke **JSON**, dan `app.use(express.json())` ada di `server.js`. |
| `affectedRows: 0` saat PUT | ID yang dikirim di URL tidak ada di database. | Gunakan ID yang benar (cek lewat `GET` dulu). |
| `ER_PARSE_ERROR: You have an error in your SQL syntax` | Kesalahan penulisan query SQL di model. | Periksa kembali jumlah tanda `?` dan kolom di query. |
