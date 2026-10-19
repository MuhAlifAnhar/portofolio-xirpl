# 📄 MODUL AJAR & LEMBAR KERJA PRAKTIKUM (LKS)
## PEMROGRAMAN WEB DAN PERANGKAT BERGERAK (BACKEND)
**Proyek:** Pembuatan Web Portofolio Dinamis  
**Stack Teknologi:** Express.js, MySQL, Next.js  
**Tingkat / Fase:** SMK Kelas XI / XII - Rekayasa Perangkat Lunak (Fase F)  
**Pertemuan:** 8 dari 12 Pertemuan  
**Alokasi Waktu:** 4 Jam Pelajaran (4 x 45 Menit)  
**Materi Pokok:** Implementasi CRUD 4 — Modul Pesan Kontak (*Contact Messages*)

---

## 🎯 BAGIAN I: TUJUAN PEMBELAJARAN

### Tujuan Pembelajaran Khusus (TP)
1. Siswa mampu membuat fungsionalitas CRUD untuk tabel `messages` (Pesan Kontak).
2. Siswa mampu menerapkan pola **Model → Controller → Route** secara mandiri.
3. Siswa mampu mendaftarkan Route baru di dalam file utama `server.js`.
4. Siswa mampu melakukan pengujian untuk endpoint *Contact Messages* menggunakan Postman / Thunder Client.
5. Siswa mampu membuat halaman front-end sederhana yang terhubung ke API menggunakan `fetch()`.

---

## 🗺️ BAGIAN II: POSISI PERTEMUAN DALAM SILABUS

| Pertemuan | Status | Materi Pokok | Target Output |
| :---: | :---: | :--- | :--- |
| **06** | ✅ Selesai | CRUD 2: Modul Proyek (*Portofolio Karya*) | Endpoint CRUD Penuh (5 Rute) |
| **07** | ✅ Selesai | CRUD 3: Modul Skills & Experiences | Endpoint CRUD Skills & Exp |
| **08** | **📌 Hari Ini** | **CRUD 4: Modul Pesan Kontak (*Contact Messages*)** | **Endpoint Contact Messages + Halaman Form Kontak** |
| **09** | Berikutnya | Integrasi Frontend (Menampilkan Data dari API) | Halaman Portfolio Dinamis |

---

## 📋 BAGIAN III: PETA KONSEP

```
Pertemuan 8: Modul Pesan Kontak (Contact Messages)
│
├── 📁 Model (contactModel.js)
│   ├── getAllContacts()   → Ambil semua pesan
│   ├── getContactById()  → Ambil 1 pesan berdasarkan ID
│   ├── createContact()   → Simpan pesan baru
│   └── deleteContact()   → Hapus pesan
│
├── 📁 Controller (contactController.js)
│   ├── getAll()   → Handle GET /api/contacts
│   ├── getById()  → Handle GET /api/contacts/:id
│   ├── create()   → Handle POST /api/contacts
│   └── remove()   → Handle DELETE /api/contacts/:id
│
├── 📁 Route (contactRoutes.js)
│   └── Pemetaan HTTP Method → Fungsi Controller
│
├── 📁 Server (server.js)
│   └── Mendaftarkan route /api/contacts
│
└── 📁 Frontend (contact.html)
    └── Formulir kontak + JavaScript fetch()
```

---

## 🗄️ BAGIAN IV: STRUKTUR TABEL DATABASE

Sebelum mulai membuat kode, pastikan tabel `messages` sudah ada di database MySQL kalian. Berikut strukturnya (sudah ada di file `schema.sql`):

```sql
-- 7. Tabel Messages (Pesan Masuk dari Pengunjung / Form Kontak)
CREATE TABLE IF NOT EXISTS messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sender_name VARCHAR(100) NOT NULL,
    sender_email VARCHAR(100) NOT NULL,
    subject VARCHAR(150),
    message TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Penjelasan Setiap Kolom:

| Kolom | Tipe Data | Keterangan |
|-------|-----------|------------|
| `id` | `INT AUTO_INCREMENT` | Nomor unik otomatis untuk setiap pesan |
| `sender_name` | `VARCHAR(100)` | Nama pengirim pesan (wajib diisi) |
| `sender_email` | `VARCHAR(100)` | Email pengirim (wajib diisi) |
| `subject` | `VARCHAR(150)` | Subjek/judul pesan (boleh kosong) |
| `message` | `TEXT` | Isi pesan lengkap (wajib diisi) |
| `is_read` | `BOOLEAN` | Status apakah pesan sudah dibaca (default: belum) |
| `created_at` | `TIMESTAMP` | Waktu pesan dikirim (otomatis terisi) |

> **💡 Tips:** Jika kalian belum menjalankan `schema.sql`, buka MySQL Workbench atau phpMyAdmin, lalu jalankan query di atas agar tabel `messages` tersedia.

---

## 🔧 BAGIAN V: LANGKAH-LANGKAH PRAKTIKUM

### ✅ STEP 1 — Membuat Model (`contactModel.js`)

**📍 Lokasi file:** `backend/src/models/contactModel.js`

Model adalah lapisan yang bertugas **berkomunikasi langsung dengan database**. Semua query SQL ditulis di sini.

**Buat file baru** bernama `contactModel.js` di dalam folder `models/`, lalu ketikkan kode berikut:

```javascript
// ============================================
// FILE: backend/src/models/contactModel.js
// FUNGSI: Berinteraksi dengan tabel 'messages'
// ============================================

// 1. Import koneksi database
const db = require('../config/db');

// 2. Fungsi untuk mengambil SEMUA pesan
const getAllContacts = async () => {
    const [rows] = await db.query('SELECT * FROM messages ORDER BY created_at DESC');
    return rows;
};

// 3. Fungsi untuk mengambil SATU pesan berdasarkan ID
const getContactById = async (id) => {
    const [rows] = await db.query('SELECT * FROM messages WHERE id = ?', [id]);
    return rows[0];
};

// 4. Fungsi untuk MENYIMPAN pesan baru
const createContact = async (data) => {
    const { sender_name, sender_email, subject, message } = data;
    const [result] = await db.query(
        'INSERT INTO messages (sender_name, sender_email, subject, message) VALUES (?, ?, ?, ?)',
        [sender_name, sender_email, subject, message]
    );
    return result;
};

// 5. Fungsi untuk MENGHAPUS pesan berdasarkan ID
const deleteContact = async (id) => {
    const [result] = await db.query('DELETE FROM messages WHERE id = ?', [id]);
    return result;
};

// 6. Export semua fungsi agar bisa dipakai di Controller
module.exports = {
    getAllContacts,
    getContactById,
    createContact,
    deleteContact,
};
```

### 📖 Penjelasan Kode Step 1:

| Baris / Bagian | Penjelasan |
|----------------|------------|
| `const db = require('../config/db')` | Mengimpor koneksi database dari file konfigurasi yang sudah kita buat di pertemuan sebelumnya |
| `async / await` | Semua fungsi menggunakan `async` karena query database bersifat **asinkron** (butuh waktu). `await` berarti "tunggu sampai selesai" |
| `db.query('SELECT * FROM messages ...')` | Menjalankan perintah SQL ke database. `SELECT *` artinya ambil semua kolom |
| `ORDER BY created_at DESC` | Mengurutkan hasil dari yang **terbaru** ke yang terlama |
| `WHERE id = ?` | Tanda `?` adalah **placeholder** yang akan diganti dengan nilai dari parameter `[id]`. Ini mencegah **SQL Injection** (serangan keamanan) |
| `const { sender_name, sender_email, ... } = data` | **Destructuring** — mengambil nilai dari objek `data` dan menyimpannya ke variabel terpisah |
| `module.exports = { ... }` | Meng-export semua fungsi agar bisa di-`require()` dari file lain |

> **🔒 Keamanan:** Selalu gunakan tanda `?` (parameterized query), **JANGAN** pernah menulis query seperti `WHERE id = ${id}` karena rentan terhadap SQL Injection!

---

### ✅ STEP 2 — Membuat Controller (`contactController.js`)

**📍 Lokasi file:** `backend/src/controller/contactController.js`

Controller adalah lapisan yang **menerima request dari user** dan **mengirimkan response**. Controller memanggil fungsi-fungsi dari Model.

**Buat file baru** bernama `contactController.js` di dalam folder `controller/`, lalu ketikkan kode berikut:

```javascript
// ============================================
// FILE: backend/src/controller/contactController.js
// FUNGSI: Menerima request & mengirim response
// ============================================

// 1. Import model contact
const Contact = require('../models/contactModel');

// ─── HANDLER 1: Ambil Semua Pesan ───
// Dipanggil saat: GET /api/contacts
const getAll = async (req, res) => {
    try {
        const contacts = await Contact.getAllContacts();
        res.json({ success: true, data: contacts });
    } catch (err) {
        console.error(err);
        res.status(500).json({ success: false, message: 'Server error' });
    }
};

// ─── HANDLER 2: Ambil Satu Pesan by ID ───
// Dipanggil saat: GET /api/contacts/:id
const getById = async (req, res) => {
    try {
        const contact = await Contact.getContactById(req.params.id);
        if (!contact) return res.status(404).json({ success: false, message: 'Not found' });
        res.json({ success: true, data: contact });
    } catch (err) {
        console.error(err);
        res.status(500).json({ success: false, message: 'Server error' });
    }
};

// ─── HANDLER 3: Simpan Pesan Baru ───
// Dipanggil saat: POST /api/contacts
const create = async (req, res) => {
    try {
        const result = await Contact.createContact(req.body);
        res.status(201).json({
            success: true,
            message: 'Message saved',
            data: { id: result.insertId, ...req.body },
        });
    } catch (err) {
        console.error(err);
        res.status(400).json({ success: false, message: 'Invalid data' });
    }
};

// ─── HANDLER 4: Hapus Pesan ───
// Dipanggil saat: DELETE /api/contacts/:id
const remove = async (req, res) => {
    try {
        const result = await Contact.deleteContact(req.params.id);
        if (result.affectedRows === 0)
            return res.status(404).json({ success: false, message: 'Not found' });
        res.json({ success: true, message: 'Message deleted' });
    } catch (err) {
        console.error(err);
        res.status(500).json({ success: false, message: 'Server error' });
    }
};

// 2. Export semua handler
module.exports = { getAll, getById, create, remove };
```

### 📖 Penjelasan Kode Step 2:

| Baris / Bagian | Penjelasan |
|----------------|------------|
| `const Contact = require('../models/contactModel')` | Mengimpor model yang sudah kita buat di Step 1 |
| `async (req, res) => { ... }` | Setiap handler menerima 2 parameter: `req` (data dari pengguna) dan `res` (untuk mengirim balasan) |
| `try { ... } catch (err) { ... }` | **Error handling** — jika terjadi kesalahan, program tidak crash, melainkan mengirim pesan error yang rapi |
| `req.params.id` | Mengambil nilai `:id` dari URL. Contoh: `GET /api/contacts/3` → `req.params.id` bernilai `3` |
| `req.body` | Mengambil data JSON yang dikirim dari front-end (misalnya: `{ sender_name: "Budi", ... }`) |
| `res.json({ success: true, data: ... })` | Mengirim balasan berformat JSON ke front-end |
| `res.status(201)` | Kode HTTP **201 Created** — artinya data baru berhasil dibuat |
| `res.status(404)` | Kode HTTP **404 Not Found** — artinya data yang dicari tidak ditemukan |
| `res.status(500)` | Kode HTTP **500 Internal Server Error** — artinya ada kesalahan di server |
| `result.insertId` | ID otomatis dari data yang baru saja disimpan ke database |
| `result.affectedRows` | Jumlah baris yang terpengaruh oleh query. Jika `0`, berarti tidak ada data yang dihapus |

> **💡 Alur Data:**  
> User mengirim request → **Controller** menerima → Controller memanggil **Model** → Model query ke **Database** → Hasilnya dikembalikan ke Controller → Controller mengirim **response** ke user.

---

### ✅ STEP 3 — Membuat Route (`contactRoutes.js`)

**📍 Lokasi file:** `backend/src/routes/contactRoutes.js`

Route adalah **peta jalan** yang menghubungkan URL dengan fungsi controller yang tepat.

**Buat file baru** bernama `contactRoutes.js` di dalam folder `routes/`, lalu ketikkan kode berikut:

```javascript
// ============================================
// FILE: backend/src/routes/contactRoutes.js
// FUNGSI: Memetakan URL ke fungsi Controller
// ============================================

// 1. Import Express dan buat Router
const express = require('express');
const router = express.Router();

// 2. Import Controller
const ContactCtrl = require('../controller/contactController');

// 3. Definisikan route
router.get('/', ContactCtrl.getAll);           // GET    /api/contacts       → Ambil semua pesan
router.get('/:id', ContactCtrl.getById);       // GET    /api/contacts/:id   → Ambil 1 pesan
router.post('/', ContactCtrl.create);          // POST   /api/contacts       → Simpan pesan baru
router.delete('/:id', ContactCtrl.remove);     // DELETE /api/contacts/:id   → Hapus pesan

// 4. Export router
module.exports = router;
```

### 📖 Penjelasan Kode Step 3:

| Baris / Bagian | Penjelasan |
|----------------|------------|
| `express.Router()` | Membuat objek router — semacam "sub-aplikasi" yang menangani sekelompok URL |
| `router.get('/', ...)` | Ketika ada request **GET** ke URL dasar (`/`), jalankan fungsi `getAll` |
| `router.get('/:id', ...)` | `:id` adalah **parameter dinamis**. Contoh: `/api/contacts/5` → `id = 5` |
| `router.post('/', ...)` | Menangani request **POST** (untuk mengirim data baru) |
| `router.delete('/:id', ...)` | Menangani request **DELETE** (untuk menghapus data) |

> **📌 Penting:** Route ini nanti akan dipasang di `server.js` dengan prefix `/api/contacts`. Jadi `router.get('/')` sebenarnya merespons URL `/api/contacts/`.

### Tabel Ringkasan Endpoint:

| HTTP Method | URL | Fungsi | Keterangan |
|:-----------:|:---:|:------:|:----------:|
| `GET` | `/api/contacts` | `getAll` | Mengambil semua pesan masuk |
| `GET` | `/api/contacts/:id` | `getById` | Mengambil detail 1 pesan |
| `POST` | `/api/contacts` | `create` | Menyimpan pesan baru dari pengunjung |
| `DELETE` | `/api/contacts/:id` | `remove` | Menghapus pesan (fitur admin) |

---

### ✅ STEP 4 — Mendaftarkan Route di `server.js`

**📍 Lokasi file:** `backend/src/server.js`

Setelah membuat Model, Controller, dan Route, kita perlu **mendaftarkan** route tersebut di file utama server agar Express tahu bahwa route itu ada.

**Buka file `server.js`** dan tambahkan 2 baris baru:

#### Baris yang ditambahkan (ditandai dengan komentar `// ← BARU`):

```javascript
// ==========================================
// ROUTES API (Mendaftarkan route dari folder routes/)
// ==========================================
const profileRoutes = require('./routes/profileRoutes');
const projectRoutes = require('./routes/projectRoutes');
const skillRoutes = require('./routes/skillRoutes');
const experienceRoutes = require('./routes/experienceRoutes');
const contactRoutes = require('./routes/contactRoutes');       // ← BARU: Import route contact

app.use('/api/profile', profileRoutes);
app.use('/api/projects', projectRoutes);
app.use('/api/skills', skillRoutes);
app.use('/api/experiences', experienceRoutes);
app.use('/api/contacts', contactRoutes);                       // ← BARU: Daftarkan route contact
```

### 📖 Penjelasan Kode Step 4:

| Baris | Penjelasan |
|-------|------------|
| `require('./routes/contactRoutes')` | Mengimpor file route yang kita buat di Step 3 |
| `app.use('/api/contacts', contactRoutes)` | Memasang route pada prefix `/api/contacts`. Artinya semua URL di `contactRoutes.js` akan diawali dengan `/api/contacts` |

> **🧩 Analogi:** Bayangkan `server.js` adalah **papan penunjuk jalan** di sebuah gedung. Kita menambahkan petunjuk baru: *"Kalau ada yang menuju `/api/contacts`, arahkan ke ruang `contactRoutes`."*

---

### ✅ STEP 5 — Membuat Halaman Front-End (`contact.html`)

**📍 Lokasi file:** `frontend/public/contact.html`

Sekarang kita buat halaman HTML sederhana yang berisi **formulir kontak**. Formulir ini akan mengirim data ke API kita menggunakan JavaScript `fetch()`.

```html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Hubungi Saya</title>
    <style>
        /* ─── CSS Sederhana untuk Tampilan Form ─── */
        body {
            font-family: Arial, sans-serif;
            max-width: 600px;
            margin: auto;
            padding: 20px;
        }
        input, textarea {
            width: 100%;
            margin-bottom: 10px;
            padding: 8px;
        }
        button {
            padding: 10px 20px;
        }
    </style>
</head>
<body>
    <h2>📩 Formulir Kontak</h2>

    <!-- Form HTML -->
    <form id="contactForm">
        <input type="text" name="sender_name" placeholder="Nama Anda" required>
        <input type="email" name="sender_email" placeholder="Email" required>
        <input type="text" name="subject" placeholder="Subjek (opsional)">
        <textarea name="message" rows="5" placeholder="Pesan Anda" required></textarea>
        <button type="submit">Kirim</button>
    </form>

    <script>
    // ─── JavaScript: Mengirim data form ke API ───
    const form = document.getElementById('contactForm');

    form.addEventListener('submit', async (e) => {
        // 1. Cegah form melakukan reload halaman
        e.preventDefault();

        // 2. Ambil semua data dari form dan ubah jadi objek JavaScript
        const data = Object.fromEntries(new FormData(form));

        try {
            // 3. Kirim data ke API menggunakan fetch()
            const res = await fetch('/api/contacts', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(data)
            });

            // 4. Terima balasan dari server
            const json = await res.json();

            // 5. Tampilkan hasil
            if (json.success) {
                alert('✅ Pesan berhasil dikirim!');
                form.reset();  // Kosongkan form
            } else {
                alert('❌ Gagal mengirim: ' + json.message);
            }
        } catch (err) {
            console.error(err);
            alert('⚠️ Terjadi kesalahan jaringan');
        }
    });
    </script>
</body>
</html>
```

### 📖 Penjelasan Kode Step 5:

| Baris / Bagian | Penjelasan |
|----------------|------------|
| `name="sender_name"` | Atribut `name` pada input **harus sama persis** dengan nama kolom di database (`sender_name`, `sender_email`, dll.) |
| `e.preventDefault()` | Mencegah form melakukan refresh halaman (behavior default browser) |
| `new FormData(form)` | Mengambil semua nilai input dari form secara otomatis |
| `Object.fromEntries(...)` | Mengubah FormData menjadi objek JavaScript biasa. Contoh hasilnya: `{ sender_name: "Budi", sender_email: "budi@mail.com", ... }` |
| `fetch('/api/contacts', { method: 'POST', ... })` | Mengirim data ke server menggunakan method POST |
| `headers: { 'Content-Type': 'application/json' }` | Memberitahu server bahwa data yang dikirim berformat JSON |
| `JSON.stringify(data)` | Mengubah objek JavaScript menjadi string JSON (karena body fetch harus berupa string) |
| `form.reset()` | Mengosongkan semua input setelah pesan berhasil dikirim |

> **💡 Catatan:** Jika backend berjalan di port berbeda (misal `localhost:3000`), ubah URL `fetch` menjadi: `http://localhost:3000/api/contacts`

---

## 🧪 BAGIAN VI: PENGUJIAN API

### 6.1 — Jalankan Server

Buka terminal di folder `backend/`, lalu jalankan:

```bash
npm start
```

Pastikan muncul pesan:
```
========================================
🚀 Server berjalan di: http://localhost:3000
📡 Environment: development
========================================
```

### 6.2 — Uji dengan Postman / Thunder Client

#### 📌 Uji 1: Kirim Pesan Baru (POST)
- **Method:** `POST`
- **URL:** `http://localhost:3000/api/contacts`
- **Body (JSON):**
```json
{
    "sender_name": "Budi Santoso",
    "sender_email": "budi@gmail.com",
    "subject": "Pertanyaan Kerjasama",
    "message": "Halo, saya tertarik untuk bekerja sama dengan Anda. Bisa kita diskusi lebih lanjut?"
}
```
- **Expected Response:**
```json
{
    "success": true,
    "message": "Message saved",
    "data": {
        "id": 1,
        "sender_name": "Budi Santoso",
        "sender_email": "budi@gmail.com",
        "subject": "Pertanyaan Kerjasama",
        "message": "Halo, saya tertarik untuk bekerja sama dengan Anda..."
    }
}
```

#### 📌 Uji 2: Ambil Semua Pesan (GET)
- **Method:** `GET`
- **URL:** `http://localhost:3000/api/contacts`
- **Expected:** Array berisi pesan yang sudah disimpan

#### 📌 Uji 3: Ambil 1 Pesan (GET by ID)
- **Method:** `GET`
- **URL:** `http://localhost:3000/api/contacts/1`
- **Expected:** Detail 1 pesan dengan `id = 1`

#### 📌 Uji 4: Hapus Pesan (DELETE)
- **Method:** `DELETE`
- **URL:** `http://localhost:3000/api/contacts/1`
- **Expected Response:**
```json
{
    "success": true,
    "message": "Message deleted"
}
```

### 6.3 — Uji dengan Browser

Buka `http://localhost:3000/contact.html`, isi formulir, klik **Kirim**, dan pastikan muncul alert *"✅ Pesan berhasil dikirim!"*

---

## 📁 BAGIAN VII: STRUKTUR FOLDER SETELAH PERTEMUAN 8

```
porto/
├── backend/
│   ├── database/
│   │   └── schema.sql
│   ├── src/
│   │   ├── config/
│   │   │   └── db.js
│   │   ├── controller/
│   │   │   ├── profileController.js
│   │   │   ├── projectController.js
│   │   │   ├── skillController.js
│   │   │   ├── experienceController.js
│   │   │   └── contactController.js        ← BARU ✅
│   │   ├── models/
│   │   │   ├── profileModel.js
│   │   │   ├── projectModel.js
│   │   │   ├── skillModel.js
│   │   │   ├── experienceModel.js
│   │   │   └── contactModel.js             ← BARU ✅
│   │   ├── routes/
│   │   │   ├── profileRoutes.js
│   │   │   ├── projectRoutes.js
│   │   │   ├── skillRoutes.js
│   │   │   ├── experienceRoutes.js
│   │   │   └── contactRoutes.js            ← BARU ✅
│   │   ├── server.js                       ← DIUBAH ✅ (tambah 2 baris)
│   │   └── .env
│   ├── package.json
│   └── package-lock.json
├── frontend/
│   └── public/
│       └── contact.html                    ← BARU ✅
└── .gitignore
```

---

## 📊 BAGIAN VIII: ALUR DATA KESELURUHAN

```
┌─────────────────────────────────────────────────────────┐
│                    PENGGUNA (Browser)                     │
│                                                           │
│   Buka contact.html → Isi form → Klik "Kirim"           │
└───────────────────────────┬───────────────────────────────┘
                            │
                   fetch() POST /api/contacts
                   Body: { sender_name, sender_email, ... }
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│                    SERVER (Express.js)                    │
│                                                           │
│  server.js                                                │
│  └── app.use('/api/contacts', contactRoutes)             │
│                            │                              │
│  contactRoutes.js          │                              │
│  └── router.post('/', ContactCtrl.create)                │
│                            │                              │
│  contactController.js      │                              │
│  └── create(req, res)                                     │
│      └── Contact.createContact(req.body)                 │
│                            │                              │
│  contactModel.js           │                              │
│  └── INSERT INTO messages (...) VALUES (?, ?, ?, ?)      │
└───────────────────────────┬───────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│                    DATABASE (MySQL)                       │
│                                                           │
│  Tabel: messages                                          │
│  ┌────┬─────────────┬──────────────┬─────────┬──────┐   │
│  │ id │ sender_name │ sender_email │ subject │ ...  │   │
│  ├────┼─────────────┼──────────────┼─────────┼──────┤   │
│  │  1 │ Budi        │ budi@mail    │ Halo    │ ...  │   │
│  └────┴─────────────┴──────────────┴─────────┴──────┘   │
└─────────────────────────────────────────────────────────┘
```

---

## 📝 BAGIAN IX: RINGKASAN MATERI

| No | Konsep | Penjelasan Singkat |
|----|--------|--------------------|
| 1 | **Model** | Lapisan yang bertugas berkomunikasi dengan database. Semua query SQL ditulis di sini |
| 2 | **Controller** | Lapisan yang menerima request, memanggil Model, dan mengirim response |
| 3 | **Route** | Peta jalan yang menghubungkan URL + HTTP Method ke fungsi Controller |
| 4 | **Parameterized Query** | Menggunakan tanda `?` dalam SQL untuk mencegah SQL Injection |
| 5 | **try...catch** | Teknik penanganan error agar server tidak crash saat terjadi kesalahan |
| 6 | **HTTP Status Code** | `200` = OK, `201` = Created, `400` = Bad Request, `404` = Not Found, `500` = Server Error |
| 7 | **fetch()** | Fungsi JavaScript bawaan browser untuk mengirim request HTTP ke server |
| 8 | **FormData** | API bawaan browser untuk mengambil nilai dari elemen `<form>` |

---

## ✏️ BAGIAN X: SOAL LATIHAN

### Soal Teori (Jawab Singkat)
1. Apa fungsi dari `module.exports` di Node.js?
2. Mengapa kita menggunakan `?` (tanda tanya) pada query SQL, bukan langsung memasukkan nilai variabel?
3. Apa perbedaan antara `res.json()` dan `res.send()`?
4. Mengapa kita menggunakan `try...catch` di setiap fungsi controller?
5. Apa yang terjadi jika kita lupa menambahkan `app.use('/api/contacts', contactRoutes)` di `server.js`?

### Soal Praktik (Kerjakan di Komputer)
1. Tambahkan fitur **Update** pada pesan (misalnya mengubah status `is_read` menjadi `true`). Buatlah:
   - Fungsi `markAsRead(id)` di `contactModel.js`
   - Handler `markRead` di `contactController.js`
   - Route `PUT /api/contacts/:id/read` di `contactRoutes.js`

2. Modifikasi halaman `contact.html` agar **menampilkan daftar pesan** di bawah form (gunakan `fetch()` dengan method GET).

---

## 📚 REFERENSI

- **Express.js Documentation:** https://expressjs.com/
- **MySQL2 npm Package:** https://www.npmjs.com/package/mysql2
- **MDN - Fetch API:** https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API
- **MDN - FormData:** https://developer.mozilla.org/en-US/docs/Web/API/FormData

---

*Modul ini merupakan bagian dari seri Pembuatan Web Portofolio Dinamis — Pertemuan 8 dari 12.*
