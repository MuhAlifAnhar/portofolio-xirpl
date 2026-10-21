# 📄 MODUL AJAR & LEMBAR KERJA PRAKTIKUM (LKS)
## PEMROGRAMAN WEB DAN PERANGKAT BERGERAK (BACKEND)
**Proyek:** Pembuatan Web Portofolio Dinamis  
**Stack Teknologi:** Express.js, MySQL, Node.js  
**Tingkat / Fase:** SMK Kelas XI / XII - Rekayasa Perangkat Lunak (Fase F)  
**Pertemuan:** 10 dari 12 Pertemuan  
**Alokasi Waktu:** 4 Jam Pelajaran (4 x 45 Menit)  
**Materi Pokok:** Implementasi CRUD 6 — Modul Testimoni (*Testimonials*)

---

## 🎯 BAGIAN I: TUJUAN PEMBELAJARAN

### Capaian Pembelajaran (CP)
Peserta didik mampu memahami dan menerapkan konsep pembuatan RESTful API berbasis arsitektur MVC (Model-View-Controller) menggunakan Express.js dan MySQL untuk mengelola data ulasan/testimoni (*testimonials*) secara dinamis.

### Tujuan Pembelajaran Khusus (TP)
1. **Perancangan Skema Database:** Siswa mampu merancang dan membuat tabel `testimonials` pada database MySQL lengkap dengan tipe data dan batasan (*constraints*).
2. **Pola Arsitektur MVC:** Siswa mampu memisahkan tanggung jawab kode antara:
   - **Model:** Menangani kueri SQL database.
   - **Controller:** Menangani logika validasi input dan status code HTTP.
   - **Route:** Mengatur alamat URL/endpoint dan kata kerja HTTP (*HTTP Verbs*).
3. **Penerapan Operasi CRUD Penuh:**
   - **Create (POST):** Menambahkan data ulasan baru.
   - **Read (GET):** Mengambil seluruh testimoni atau 1 data spesifik berdasarkan `id`.
   - **Update (PUT):** Memperbarui ulasan yang sudah ada.
   - **Delete (DELETE):** Menghapus data ulasan.
4. **Pengujian API (Testing):** Siswa mampu memvalidasi kelima endpoint menggunakan Postman / Thunder Client dengan status code yang tepat (200, 201, 400, 404, 500).

---

## 🗺️ BAGIAN II: POSISI PERTEMUAN DALAM SILABUS

| Pertemuan | Status | Materi Pokok | Target Output |
| :---: | :---: | :--- | :--- |
| **08** | ✅ Selesai | CRUD 4: Modul Pesan Kontak (*Contact Messages*) | Endpoint CRUD Pesan |
| **09** | ✅ Selesai | CRUD 5: Modul Sertifikat (*Certificates*) | Endpoint CRUD Sertifikat |
| **10** | **📌 Hari Ini** | **CRUD 6: Modul Testimoni (*Testimonials*)** | **Endpoint Penuh CRUD Testimoni (5 Endpoint)** |
| **11** | Berikutnya | Integrasi Frontend: Menampilkan Data dari API ke HTML | Tampilan Portofolio Dinamis |
| **12** | Berikutnya | Finalisasi & Deployment Web Portofolio | Portofolio Online Siap Pakai |

---

## 🧭 KITA MULAI DARI MANA? (ALUR DATA MVC)

Untuk membangun endpoint backend dengan arsitektur MVC, urutan langkah kerja selalu dimulai dari **lapisan terdalam (Database)** ke **lapisan luar (Server/Router)**:

```
[LANGKAH 1] Database (MySQL)
     │  → Siapkan tabel `testimonials` dan data awal
     ▼
[LANGKAH 2] Model (testimonialModel.js)
     │  → Tulis kueri SQL (SELECT, INSERT, UPDATE, DELETE)
     ▼
[LANGKAH 3] Controller (testimonialController.js)
     │  → Tangani validasi input & kirim format JSON + status code
     ▼
[LANGKAH 4] Route (testimonialRoutes.js)
     │  → Petakan URL & Method HTTP (GET, POST, PUT, DELETE)
     ▼
[LANGKAH 5] Registrasi di server.js
     │  → Pasang prefix '/api/testimonials' ke aplikasi Express
     ▼
[LANGKAH 6] Pengujian / Testing API
        → Uji dengan Thunder Client / Postman
```

---

## 🗄️ LANGKAH 1: Menyiapkan Tabel Database MySQL

### 1. Mengapa mulai dari sini?
Komputer tidak dapat menyimpan atau mengambil data testimoni jika wadahnya belum tersedia di database `db_portofolio`.

### 2. Kodingan SQL:
Buka **phpMyAdmin** atau **MySQL Workbench**, lalu jalankan kueri berikut:

```sql
USE db_portofolio;

-- 1. Membuat tabel testimonials
CREATE TABLE IF NOT EXISTS testimonials (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    role VARCHAR(100) NOT NULL,
    company VARCHAR(100) NULL,
    message TEXT NOT NULL,
    avatar_url VARCHAR(255) NULL,
    rating INT DEFAULT 5,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 2. Memasukkan data awal (Dummy Data) untuk pengujian
INSERT INTO testimonials (name, role, company, message, rating) VALUES 
(
    'Budi Santoso',
    'Senior Project Manager',
    'PT Inovasi Digital Nusantara',
    'Kerja sama yang luar biasa! Hasil pembuatan REST API sangat rapi, terstruktur sesuai standar industri, dan selesai tepat waktu.',
    5
),
(
    'Siti Rahmawati',
    'Lead UI/UX Designer',
    'Creative Studio ID',
    'Sangat komunikatif dalam mengintegrasikan desain menjadi tampilan web responsif. Sangat direkomendasikan untuk proyek web development!',
    5
);
```

### 3. Penjelasan Kolom:
* `id`: Identitas unik otomatis (*Primary Key* & *Auto Increment*).
* `name`: Nama orang yang memberikan testimoni (Wajib).
* `role`: Jabatan atau peran, contoh: *Project Manager*, *Client* (Wajib).
* `company`: Nama instansi atau perusahaan pemberi testimoni (Boleh kosong / `NULL`).
* `message`: Isi pesan ulasan atau ulasan kepuasan (Wajib).
* `avatar_url`: Tautan foto profil pengulas (Opsional).
* `rating`: Skor penilaian angka 1 sampai 5 (Default: 5).

---

## 📦 LANGKAH 2: Membuat Model (`testimonialModel.js`)

### 1. Mengapa langkah ini?
**Model** adalah layer yang bertugas khusus menjalankan kueri SQL ke database MySQL. Semua logika database diisolasi di sini agar tidak tercampur dengan urusan respons HTTP.

### 2. Kodingan:
Buat file baru di: `backend/src/models/testimonialModel.js`

```javascript
// backend/src/models/testimonialModel.js
const db = require('../config/db');

// 1. GET ALL - Mengambil semua data testimoni (diurutkan dari yang terbaru)
const getAllTestimonials = async () => {
    const [rows] = await db.query('SELECT * FROM testimonials ORDER BY created_at DESC');
    return rows;
};

// 2. GET BY ID - Mengambil 1 testimoni berdasarkan ID
const getTestimonialById = async (id) => {
    const [rows] = await db.query('SELECT * FROM testimonials WHERE id = ?', [id]);
    return rows[0];
};

// 3. CREATE - Menyimpan data testimoni baru
const createTestimonial = async (data) => {
    const { name, role, company, message, avatar_url, rating } = data;
    const [result] = await db.query(
        'INSERT INTO testimonials (name, role, company, message, avatar_url, rating) VALUES (?, ?, ?, ?, ?, ?)',
        [name, role, company || null, message, avatar_url || null, rating || 5]
    );
    return result;
};

// 4. UPDATE - Memperbarui data testimoni berdasarkan ID
const updateTestimonial = async (id, data) => {
    const { name, role, company, message, avatar_url, rating } = data;
    const [result] = await db.query(
        'UPDATE testimonials SET name = ?, role = ?, company = ?, message = ?, avatar_url = ?, rating = ? WHERE id = ?',
        [name, role, company || null, message, avatar_url || null, rating || 5, id]
    );
    return result;
};

// 5. DELETE - Menghapus data testimoni berdasarkan ID
const deleteTestimonial = async (id) => {
    const [result] = await db.query('DELETE FROM testimonials WHERE id = ?', [id]);
    return result;
};

module.exports = {
    getAllTestimonials,
    getTestimonialById,
    createTestimonial,
    updateTestimonial,
    deleteTestimonial
};
```

### 3. Penjelasan untuk Siswa:
* `db.query(...)`: Menjalankan query MySQL berformat Promise (`async/await`).
* Tanda `?` (*Prepared Statements*): Menghindari serangan peretasan **SQL Injection** dengan mengamankan input pengguna sebelum disisipkan ke query.
* `[rows]` dan `[result]`: Mengambil hasil tabel langsung dengan teknik *array destructuring*.

---

## 🎮 LANGKAH 3: Membuat Controller (`testimonialController.js`)

### 1. Mengapa langkah ini?
**Controller** adalah jembatan penghubung antara request pengguna dan model data. Controller bertugas mengecek apakah data yang diinput pengguna sudah lengkap, memanggil fungsi di Model, lalu mengirimkan respons JSON lengkap dengan kode status HTTP.

### 2. Kodingan:
Buat file baru di: `backend/src/controller/testimonialController.js`

```javascript
// backend/src/controller/testimonialController.js
const testimonialModel = require('../models/testimonialModel');

// 1. GET ALL TESTIMONIALS
const getAllTestimonials = async (req, res) => {
    try {
        const testimonials = await testimonialModel.getAllTestimonials();
        res.status(200).json({
            success: true,
            total: testimonials.length,
            data: testimonials
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: 'Server Error',
            error: error.message
        });
    }
};

// 2. GET TESTIMONIAL BY ID
const getTestimonialById = async (req, res) => {
    try {
        const { id } = req.params;
        const testimonial = await testimonialModel.getTestimonialById(id);

        if (!testimonial) {
            return res.status(404).json({
                success: false,
                message: 'Data testimoni tidak ditemukan'
            });
        }

        res.status(200).json({
            success: true,
            data: testimonial
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: 'Server Error',
            error: error.message
        });
    }
};

// 3. CREATE TESTIMONIAL (POST)
const createTestimonial = async (req, res) => {
    try {
        const data = req.body;

        // Validasi input wajib: nama, jabatan/role, dan pesan testimoni
        if (!data.name || !data.role || !data.message) {
            return res.status(400).json({
                success: false,
                message: 'Nama (name), peran/jabatan (role), dan pesan (message) wajib diisi'
            });
        }

        const result = await testimonialModel.createTestimonial(data);
        res.status(201).json({
            success: true,
            message: 'Testimoni berhasil ditambahkan',
            data: { id: result.insertId }
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: 'Server Error',
            error: error.message
        });
    }
};

// 4. UPDATE TESTIMONIAL (PUT)
const updateTestimonial = async (req, res) => {
    try {
        const { id } = req.params;
        const data = req.body;

        // Validasi input wajib
        if (!data.name || !data.role || !data.message) {
            return res.status(400).json({
                success: false,
                message: 'Nama (name), peran/jabatan (role), dan pesan (message) wajib diisi'
            });
        }

        const result = await testimonialModel.updateTestimonial(id, data);

        if (result.affectedRows === 0) {
            return res.status(404).json({
                success: false,
                message: 'Data testimoni tidak ditemukan'
            });
        }

        res.status(200).json({
            success: true,
            message: 'Testimoni berhasil diperbarui'
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: 'Server Error',
            error: error.message
        });
    }
};

// 5. DELETE TESTIMONIAL (DELETE)
const deleteTestimonial = async (req, res) => {
    try {
        const { id } = req.params;
        const result = await testimonialModel.deleteTestimonial(id);

        if (result.affectedRows === 0) {
            return res.status(404).json({
                success: false,
                message: 'Data testimoni tidak ditemukan'
            });
        }

        res.status(200).json({
            success: true,
            message: 'Testimoni berhasil dihapus'
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: 'Server Error',
            error: error.message
        });
    }
};

module.exports = {
    getAllTestimonials,
    getTestimonialById,
    createTestimonial,
    updateTestimonial,
    deleteTestimonial
};
```

### 3. Penjelasan Kode:
* `req.params.id`: Menangkap nilai parameter yang dikirim melalui URL (misal: `/api/testimonials/2`).
* `req.body`: Menangkap data payload JSON yang dikirimkan oleh klien.
* `res.status(200)`: Respons standar saat data berhasil diambil, diupdate, atau dihapus (*OK*).
* `res.status(201)`: Respons standar saat data baru berhasil disimpan ke database (*Created*).
* `res.status(400)`: Terjadi jika form tidak diisi lengkap oleh pengguna (*Bad Request*).
* `res.status(404)`: Terjadi jika data dengan ID terkait tidak ada di database (*Not Found*).

---

## 🚦 LANGKAH 4: Membuat Router (`testimonialRoutes.js`)

### 1. Mengapa langkah ini?
Router bertindak sebagai peta rute. Router menentukan method HTTP apa (`GET`, `POST`, `PUT`, `DELETE`) dan URL mana yang akan memicu fungsi di controller.

### 2. Kodingan:
Buat file baru di: `backend/src/routes/testimonialRoutes.js`

```javascript
// backend/src/routes/testimonialRoutes.js
const express = require('express');
const router = express.Router();
const testimonialController = require('../controller/testimonialController');

// 1. GET /api/testimonials - Ambil semua testimonial
router.get('/', testimonialController.getAllTestimonials);

// 2. GET /api/testimonials/:id - Ambil detail 1 testimonial berdasarkan ID
router.get('/:id', testimonialController.getTestimonialById);

// 3. POST /api/testimonials - Tambah testimonial baru
router.post('/', testimonialController.createTestimonial);

// 4. PUT /api/testimonials/:id - Update testimonial berdasarkan ID
router.put('/:id', testimonialController.updateTestimonial);

// 5. DELETE /api/testimonials/:id - Hapus testimonial berdasarkan ID
router.delete('/:id', testimonialController.deleteTestimonial);

module.exports = router;
```

---

## 🔌 LANGKAH 5: Mendaftarkan Route ke `server.js`

### 1. Mengapa langkah ini?
Agar route baru dapat diakses secara publik oleh klien, route harus diimpor dan didaftarkan menggunakan middleware `app.use()` di file utama Express.

### 2. Kodingan:
Buka file `backend/src/server.js`, lalu tambahkan route testimoni:

```javascript
// 1. Import Route Testimonials
const certificateRoutes = require('./routes/certificateRoutes');
const testimonialRoutes = require('./routes/testimonialRoutes'); // ⬅️ BARU

// 2. Pasang Middleware Route
app.use('/api/certificates', certificateRoutes);
app.use('/api/testimonials', testimonialRoutes); // ⬅️ BARU
```

---

## 🧪 LANGKAH 6: Pengujian API (*Testing*)

Jalankan server backend di terminal:
```bash
npm run dev
# atau: node src/server.js
```

### Panduan Lengkap Pengujian (Thunder Client / Postman):

| No | Operasi | Method HTTP | URL Endpoint | Header | Body (raw JSON) | Status Code |
|:--:|---|:---:|---|:---:|---|:---:|
| 1 | **Ambil Semua** | `GET` | `http://localhost:3000/api/testimonials` | - | *None* | `200 OK` |
| 2 | **Ambil Detail** | `GET` | `http://localhost:3000/api/testimonials/1` | - | *None* | `200 OK` |
| 3 | **Tambah Baru** | `POST` | `http://localhost:3000/api/testimonials` | `Content-Type: application/json` | JSON Baru | `201 Created` |
| 4 | **Ubah Data** | `PUT` | `http://localhost:3000/api/testimonials/1` | `Content-Type: application/json` | JSON Update | `200 OK` |
| 5 | **Hapus Data** | `DELETE` | `http://localhost:3000/api/testimonials/1` | - | *None* | `200 OK` |

#### Contoh JSON untuk Request POST (Tambah Data):
```json
{
  "name": "Dewi Sartika",
  "role": "Product Owner",
  "company": "Tech Startup Asia",
  "message": "Pengembang yang sangat teliti dalam pembuatan API dan dokumentasinya sangat memudahkan tim kami.",
  "rating": 5
}
```

---

## 📝 LEMBAR KERJA & TUGAS PRAKTIKUM SISWA

1. **Jalankan Kueri:** Jalankan query pembuatan tabel `testimonials` dan insert dummy data di database MySQL Anda.
2. **Ketik Kode:** Buatlah file `testimonialModel.js`, `testimonialController.js`, `testimonialRoutes.js`, serta daftarkan di `server.js`.
3. **Praktik Mandiri:** Tambahkan minimal **2 testimoni baru** menggunakan metode `POST` via Postman/Thunder Client.
4. **Validasi:** Coba kirim `POST` tanpa menyertakan kolom `message`, lalu amati apakah muncul error `400 Bad Request`.
5. **Dokumentasi:** Ambil tangkapan layar (*screenshot*) saat pengujian kelima endpoint berhasil dijalankan sebagai portofolio tugas praktikum.
