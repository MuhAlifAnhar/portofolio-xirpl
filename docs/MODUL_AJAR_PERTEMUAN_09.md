# 📄 MODUL AJAR & LEMBAR KERJA PRAKTIKUM (LKS)
## PEMROGRAMAN WEB DAN PERANGKAT BERGERAK (BACKEND)
**Proyek:** Pembuatan Web Portofolio Dinamis  
**Stack Teknologi:** Express.js, MySQL, Node.js  
**Tingkat / Fase:** SMK Kelas XI / XII - Rekayasa Perangkat Lunak (Fase F)  
**Pertemuan:** 9 dari 12 Pertemuan  
**Alokasi Waktu:** 4 Jam Pelajaran (4 x 45 Menit)  
**Materi Pokok:** Implementasi CRUD 5 — Modul Sertifikat (*Certificates*)

---

## 🎯 BAGIAN I: TUJUAN PEMBELAJARAN

### Capaian Pembelajaran (CP)
Peserta didik mampu memahami dan menerapkan konsep pembuatan Web Service / RESTful API berbasis arsitektur MVC (Model-View-Controller) menggunakan Express.js dan MySQL untuk mengelola data sertifikat secara dinamis.

### Tujuan Pembelajaran Khusus (TP)
1. **Memahami Struktur Data:** Siswa dapat merancang skema tabel `certificates` untuk menampung riwayat penghargaan, sertifikasi kompetensi, atau lisensi online.
2. **Pola MVC (Model-View-Controller):** Siswa mampu membedakan tugas dari **Model** (kueri database), **Controller** (logika & validasi), dan **Route** (penentu URL/endpoint).
3. **Penerapan Operasi CRUD Penuh:**
   - **Create (POST):** Menyimpan data sertifikat baru.
   - **Read (GET):** Menampilkan semua sertifikat atau 1 sertifikat spesifik berdasarkan `id`.
   - **Update (PUT):** Mengubah data sertifikat yang sudah ada.
   - **Delete (DELETE):** Menghapus data sertifikat.
4. **Pengujian API (Testing):** Siswa mampu menguji kelima endpoint menggunakan Postman atau Thunder Client dengan metode HTTP dan format JSON yang tepat.

---

## 🗺️ BAGIAN II: POSISI PERTEMUAN DALAM SILABUS

| Pertemuan | Status | Materi Pokok | Target Output |
| :---: | :---: | :--- | :--- |
| **06** | ✅ Selesai | CRUD 2: Modul Proyek (*Portofolio Karya*) | Endpoint CRUD Projects |
| **07** | ✅ Selesai | CRUD 3: Modul Skills & Experiences | Endpoint CRUD Skills & Experiences |
| **08** | ✅ Selesai | CRUD 4: Modul Pesan Kontak (*Contact Messages*) | Endpoint CRUD Messages |
| **09** | **📌 Hari Ini** | **CRUD 5: Modul Sertifikat (*Certificates*)** | **Endpoint Penuh CRUD Sertifikat (5 Endpoint)** |
| **10** | Berikutnya | Integrasi Frontend (Fetch API & DOM) | Tampilan Portofolio Dinamis |

---

## 📋 BAGIAN III: ALUR ARSITEKTUR MVC

Dalam pembuatan fitur CRUD di Express.js, alur data selalu mengikuti siklus:

```
Request dari Client (Postman/Browser)
             │
             ▼
    [1. server.js]  ───────► Meneruskan URL prefix '/api/certificates'
             │
             ▼
 [2. certificateRoutes.js] ──► Mencocokkan Method (GET/POST/PUT/DELETE)
             │
             ▼
[3. certificateController.js] ─► Validasi input & jalankan logika bisnis
             │
             ▼
 [4. certificateModel.js]   ──► Eksekusi Query SQL ke MySQL
             │
             ▼
        [Database MySQL]
             │
             ▼ (Response Data JSON dikembalikan ke Client)
```

---

## 🗄️ BAGIAN IV: PERSIAPAN TABEL DATABASE

Buka tool database kalian (**phpMyAdmin** atau **MySQL Workbench** / Terminal), lalu jalankan query SQL berikut:

```sql
USE db_portofolio;

CREATE TABLE IF NOT EXISTS certificates (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    issuer VARCHAR(100) NOT NULL,
    issue_date DATE NOT NULL,
    expiration_date DATE NULL,
    credential_id VARCHAR(100) NULL,
    credential_url VARCHAR(255) NULL,
    description TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Data Contoh (Dummy Data) untuk Pengujian
INSERT INTO certificates (name, issuer, issue_date, expiration_date, credential_id, credential_url, description) 
VALUES 
(
    'Belajar Dasar Pemrograman JavaScript', 
    'Dicoding Indonesia', 
    '2024-05-10', 
    '2027-05-10', 
    'DICODING-JS-12345', 
    'https://www.dicoding.com/certificates/DICODING-JS-12345', 
    'Sertifikasi kompetensi pemahaman fundamental JavaScript ES6+, asynchronous, dan object-oriented.'
),
(
    'Junior Web Developer Certification', 
    'BNSP Indonesia', 
    '2024-08-20', 
    NULL, 
    'BNSP-JWD-98765', 
    'https://bnsp.go.id/verify/98765', 
    'Sertifikasi keahlian skema Junior Web Developer standar SKKNI.'
);
```

### 💡 Penjelasan Kolom:
- `id`: Kunci utama unik berulang otomatis (*Auto Increment*).
- `name`: Nama penghargaan atau sertifikat (Contoh: *"Belajar Dasar JavaScript"*).
- `issuer`: Lembaga/organisasi penerbit (Contoh: *"Dicoding"*, *"BNSP"*, *"Coursera"*).
- `issue_date`: Tanggal sertifikat diterbitkan (Format: `YYYY-MM-DD`).
- `expiration_date`: Tanggal kedaluwarsa (opsional, `NULL` jika berlaku selamanya).
- `credential_id`: Nomor/ID unik sertifikat untuk verifikasi.
- `credential_url`: Link web untuk memeriksa keaslian sertifikat secara online.
- `description`: Penjelasan singkat materi sertifikasi.

---

## 🔨 BAGIAN V: LANGKAH DEMI LANGKAH PEMBUATAN KODE

### 🟢 STEP 1: Membuat Model (`certificateModel.js`)

Model bertugas murni untuk berkomunikasi dengan MySQL. Semua sintaks SQL (`SELECT`, `INSERT`, `UPDATE`, `DELETE`) ditulis di sini.

📁 **Buat file baru di:** `backend/src/models/certificateModel.js`

```javascript
// backend/src/models/certificateModel.js
const db = require('../config/db');

// 1. GET ALL - Mengambil semua sertifikat (diurutkan dari tanggal terbit terbaru)
const getAllCertificates = async () => {
    const [rows] = await db.query('SELECT * FROM certificates ORDER BY issue_date DESC');
    return rows;
};

// 2. GET BY ID - Mengambil 1 sertifikat berdasarkan ID unik
const getCertificateById = async (id) => {
    const [rows] = await db.query('SELECT * FROM certificates WHERE id = ?', [id]);
    return rows[0];
};

// 3. CREATE - Menyimpan data sertifikat baru
const createCertificate = async (data) => {
    const { name, issuer, issue_date, expiration_date, credential_id, credential_url, description } = data;
    const [result] = await db.query(
        'INSERT INTO certificates (name, issuer, issue_date, expiration_date, credential_id, credential_url, description) VALUES (?, ?, ?, ?, ?, ?, ?)',
        [name, issuer, issue_date, expiration_date || null, credential_id || null, credential_url || null, description || null]
    );
    return result;
};

// 4. UPDATE - Memperbarui data sertifikat yang sudah ada
const updateCertificate = async (id, data) => {
    const { name, issuer, issue_date, expiration_date, credential_id, credential_url, description } = data;
    const [result] = await db.query(
        'UPDATE certificates SET name = ?, issuer = ?, issue_date = ?, expiration_date = ?, credential_id = ?, credential_url = ?, description = ? WHERE id = ?',
        [name, issuer, issue_date, expiration_date || null, credential_id || null, credential_url || null, description || null, id]
    );
    return result;
};

// 5. DELETE - Menghapus data sertifikat
const deleteCertificate = async (id) => {
    const [result] = await db.query('DELETE FROM certificates WHERE id = ?', [id]);
    return result;
};

module.exports = {
    getAllCertificates,
    getCertificateById,
    createCertificate,
    updateCertificate,
    deleteCertificate
};
```

#### 🔍 Penjelasan Kode:
1. `db.query(...)`: Menjalankan query MySQL berformat Promise (`async/await`).
2. Tanda tanya `?`: Dikenal sebagai **Prepared Statements** (parameter binding) yang berguna mencegah bahaya celah keamanan **SQL Injection**.
3. `[rows]` dan `[result]`: Teknik *destructuring array* karena driver mysql2 mengembalikan array berisi `[hasil, metadata]`.

---

### 🟢 STEP 2: Membuat Controller (`certificateController.js`)

Controller bertugas sebagai jembatan: menerima permintaan dari user (*request*), mengecek apakah input data valid, memanggil Model, lalu membalas ke user (*response*).

📁 **Buat file baru di:** `backend/src/controller/certificateController.js`

```javascript
// backend/src/controller/certificateController.js
const certificateModel = require('../models/certificateModel');

// 1. GET ALL - Mengambil semua sertifikat
const getAllCertificates = async (req, res) => {
    try {
        const certificates = await certificateModel.getAllCertificates();
        res.status(200).json({
            success: true,
            total: certificates.length,
            data: certificates
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: 'Server Error',
            error: error.message
        });
    }
};

// 2. GET BY ID - Mengambil detail 1 sertifikat
const getCertificateById = async (req, res) => {
    try {
        const { id } = req.params;
        const certificate = await certificateModel.getCertificateById(id);

        if (!certificate) {
            return res.status(404).json({
                success: false,
                message: 'Data sertifikat tidak ditemukan'
            });
        }

        res.status(200).json({
            success: true,
            data: certificate
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: 'Server Error',
            error: error.message
        });
    }
};

// 3. CREATE - Menambah data baru
const createCertificate = async (req, res) => {
    try {
        const data = req.body;

        // Validasi kolom wajib diisi
        if (!data.name || !data.issuer || !data.issue_date) {
            return res.status(400).json({
                success: false,
                message: 'Nama sertifikat (name), penerbit (issuer), dan tanggal terbit (issue_date) wajib diisi'
            });
        }

        const result = await certificateModel.createCertificate(data);
        res.status(201).json({
            success: true,
            message: 'Sertifikat berhasil ditambahkan',
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

// 4. UPDATE - Mengubah data berdasarkan ID
const updateCertificate = async (req, res) => {
    try {
        const { id } = req.params;
        const data = req.body;

        // Validasi kolom wajib diisi
        if (!data.name || !data.issuer || !data.issue_date) {
            return res.status(400).json({
                success: false,
                message: 'Nama sertifikat (name), penerbit (issuer), dan tanggal terbit (issue_date) wajib diisi'
            });
        }

        const result = await certificateModel.updateCertificate(id, data);

        if (result.affectedRows === 0) {
            return res.status(404).json({
                success: false,
                message: 'Data sertifikat tidak ditemukan'
            });
        }

        res.status(200).json({
            success: true,
            message: 'Sertifikat berhasil diperbarui'
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: 'Server Error',
            error: error.message
        });
    }
};

// 5. DELETE - Menghapus data berdasarkan ID
const deleteCertificate = async (req, res) => {
    try {
        const { id } = req.params;
        const result = await certificateModel.deleteCertificate(id);

        if (result.affectedRows === 0) {
            return res.status(404).json({
                success: false,
                message: 'Data sertifikat tidak ditemukan'
            });
        }

        res.status(200).json({
            success: true,
            message: 'Sertifikat berhasil dihapus'
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
    getAllCertificates,
    getCertificateById,
    createCertificate,
    updateCertificate,
    deleteCertificate
};
```

#### 🔍 Penjelasan Kode:
- `req.params`: Mengambil parameter dari URL (misalnya angka id pada `/api/certificates/3`).
- `req.body`: Mengambil data JSON yang dikirimkan user saat method POST atau PUT.
- `res.status(200)`: Berhasil (OK).
- `res.status(201)`: Berhasil membuat data baru (Created).
- `res.status(400)`: Bad Request (Input dari pengguna tidak lengkap).
- `res.status(404)`: Not Found (Data yang dicari/diupdate/dihapus tidak ada).
- `res.status(500)`: Internal Server Error.

---

### 🟢 STEP 3: Membuat Router (`certificateRoutes.js`)

Router menentukan pintu masuk (*endpoint*) URL dan menyambungkannya ke fungsi controller yang cocok.

📁 **Buat file baru di:** `backend/src/routes/certificateRoutes.js`

```javascript
// backend/src/routes/certificateRoutes.js
const express = require('express');
const router = express.Router();
const certificateController = require('../controller/certificateController');

// 1. GET /api/certificates - Menampilkan semua sertifikat
router.get('/', certificateController.getAllCertificates);

// 2. GET /api/certificates/:id - Menampilkan detail 1 sertifikat
router.get('/:id', certificateController.getCertificateById);

// 3. POST /api/certificates - Menambahkan sertifikat baru
router.post('/', certificateController.createCertificate);

// 4. PUT /api/certificates/:id - Mengubah data sertifikat
router.put('/:id', certificateController.updateCertificate);

// 5. DELETE /api/certificates/:id - Menghapus sertifikat
router.delete('/:id', certificateController.deleteCertificate);

module.exports = router;
```

---

### 🟢 STEP 4: Mendaftarkan Route ke `server.js`

Agar route yang telah dibuat dapat diakses secara publik, kita harus mendaftarkannya ke berkas utama server Express.

📁 **Buka file:** `backend/src/server.js`

Tambahkan import dan `app.use('/api/certificates', ...)` seperti pada contoh berikut:

```javascript
// Import route certificates
const certificateRoutes = require('./routes/certificateRoutes');

// Daftarkan endpoint prefix
app.use('/api/profile', profileRoutes);
app.use('/api/projects', projectRoutes);
app.use('/api/skills', skillRoutes);
app.use('/api/experiences', experienceRoutes);
app.use('/api/contacts', contactRoutes);
app.use('/api/certificates', certificateRoutes); // ⬅️ TAMBAHKAN BARIS INI
```

---

## 🧪 BAGIAN VI: PANDUAN PENGUJIAN API (POSTMAN / THUNDER CLIENT)

Nyalakan server Express kalian terlebih dahulu di terminal:
```bash
npm run dev
# atau
node src/server.js
```

### 1️⃣ GET All Certificates
- **Method:** `GET`
- **URL:** `http://localhost:3000/api/certificates`
- **Response Expected:** `200 OK`
```json
{
  "success": true,
  "total": 2,
  "data": [
    {
      "id": 2,
      "name": "Junior Web Developer Certification",
      "issuer": "BNSP Indonesia",
      "issue_date": "2024-08-20",
      "credential_id": "BNSP-JWD-98765"
    }
  ]
}
```

---

### 2️⃣ GET Certificate by ID
- **Method:** `GET`
- **URL:** `http://localhost:3000/api/certificates/1`
- **Response Expected:** `200 OK`

---

### 3️⃣ POST Create Certificate
- **Method:** `POST`
- **URL:** `http://localhost:3000/api/certificates`
- **Headers:** `Content-Type: application/json`
- **Body (JSON):**
```json
{
  "name": "Cloud Practitioner Essentials",
  "issuer": "AWS Training & Certification",
  "issue_date": "2024-09-15",
  "expiration_date": "2027-09-15",
  "credential_id": "AWS-CLF-88990",
  "credential_url": "https://aws.amazon.com/verify/88990",
  "description": "Fundamental arsitektur komputasi awan Amazon Web Services."
}
```
- **Response Expected:** `201 Created`
```json
{
  "success": true,
  "message": "Sertifikat berhasil ditambahkan",
  "data": {
    "id": 3
  }
}
```

---

### 4️⃣ PUT Update Certificate
- **Method:** `PUT`
- **URL:** `http://localhost:3000/api/certificates/3`
- **Headers:** `Content-Type: application/json`
- **Body (JSON):**
```json
{
  "name": "AWS Certified Cloud Practitioner (Updated)",
  "issuer": "Amazon Web Services",
  "issue_date": "2024-09-15",
  "credential_id": "AWS-CLF-88990-VERIFIED"
}
```
- **Response Expected:** `200 OK`

---

### 5️⃣ DELETE Certificate
- **Method:** `DELETE`
- **URL:** `http://localhost:3000/api/certificates/3`
- **Response Expected:** `200 OK`
```json
{
  "success": true,
  "message": "Sertifikat berhasil dihapus"
}
```

---

## 📝 BAGIAN VII: LEMBAR KERJA & TUGAS SISWA

### Tugas Individu (Praktikum):
1. Buat tabel `certificates` pada database MySQL kalian masing-masing.
2. Ikuti Step 1 sampai Step 4 untuk mengimplementasikan Model, Controller, Route, dan mendaftarkannya pada `server.js`.
3. Tambahkan minimal **3 sertifikat milik kalian sendiri** (atau sertifikat seminar/pelatihan yang pernah diikuti) menggunakan metode `POST`.
4. Lakukan pengujian perubahan data menggunakan `PUT` dan pengujian penghapusan menggunakan `DELETE`.
5. Ambil tangkapan layar (screenshot) hasil pengujian kelima endpoint di Postman/Thunder Client sebagai bukti pengerjaan praktikum.
