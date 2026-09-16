# 📄 MODUL AJAR & LEMBAR KERJA PRAKTIKUM (LKS)
## PEMROGRAMAN WEB DAN PERANGKAT BERGERAK (BACKEND)
**Proyek:** Pembuatan Web Portofolio Dinamis  
**Stack Teknologi:** Express.js, MySQL, Next.js  
**Tingkat / Fase:** SMK Kelas XI / XII - Rekayasa Perangkat Lunak (Fase F)  
**Pertemuan:** 6 dari 12 Pertemuan  
**Alokasi Waktu:** 4 Jam Pelajaran (4 x 45 Menit)  
**Materi Pokok:** Implementasi Arsitektur MVC & CRUD Lengkap — Modul Proyek (*Projects/Portofolio Karya*)

---

## 🎯 BAGIAN I: TUJUAN PEMBELAJARAN

### Tujuan Pembelajaran Khusus (TP)
1. Siswa dapat menerapkan fungsionalitas CRUD (Create, Read, Update, Delete) secara utuh dalam arsitektur MVC.
2. Siswa mampu membuat file **Model** untuk mengeksekusi lima tipe query: GET ALL, GET BY ID, INSERT, UPDATE, dan DELETE pada tabel `projects`.
3. Siswa mampu membuat file **Controller** untuk menangani kelima operasi tersebut dengan validasi data dasar.
4. Siswa mampu mendaftarkan **Routes** untuk operasi CRUD dengan benar, termasuk route dengan parameter dinamis (`/:id`).
5. Siswa dapat melakukan pengujian menyeluruh (End-to-End API Testing) menggunakan Postman atau Thunder Client untuk semua rute *Projects*.

---

## 🗺️ BAGIAN II: POSISI PERTEMUAN DALAM SILABUS

| Pertemuan | Status | Materi Pokok | Target Output |
| :---: | :---: | :--- | :--- |
| **05** | Selesai | CRUD 1: Modul Profil Diri (*About Me*) | Endpoint GET & PUT Profile |
| **06** | **Hari Ini** | **CRUD 2: Modul Proyek (*Portofolio Karya*)** | **Endpoint CRUD Penuh (5 Rute)** |
| **07** | Berikutnya| CRUD 3: Modul Skills & Experiences | Endpoint CRUD Skills & Exp |

---

## 📚 BAGIAN III: LANDASAN TEORI

### Membangun Modul dengan CRUD Lengkap
Pada pertemuan 5, kita hanya menggunakan dua buah operasi (GET dan PUT) pada tabel `profile` karena data profil hanya berisi satu baris. Berbeda halnya dengan tabel `projects`, di mana kita akan memiliki *banyak* baris data. Oleh karena itu, kita membutuhkan semua operasi standar yang biasa disebut **CRUD**:

- **C**reate (`POST`) → Menambahkan data proyek baru.
- **R**ead (`GET`) → Menampilkan data proyek. Biasanya dibagi dua:
  - Tampilkan *semua* proyek (GET ALL).
  - Tampilkan *satu* proyek berdasarkan ID (GET BY ID).
- **U**pdate (`PUT`) → Memperbarui data proyek tertentu berdasarkan ID.
- **D**elete (`DELETE`) → Menghapus data proyek tertentu berdasarkan ID.

Total kita akan membuat **5 Fungsi Model**, **5 Fungsi Controller**, dan **5 Alamat Route**.

---

## 🛠️ BAGIAN IV: LANGKAH KERJA PRAKTIKUM (STEP-BY-STEP)

```
[Struktur File yang Akan Dibuat/Diperbarui Hari Ini]
backend/
└── src/
    ├── models/
    │   └── projectModel.js      ◄── BARU (Langkah 1)
    ├── controller/
    │   └── projectController.js ◄── BARU (Langkah 2)
    ├── routes/
    │   └── projectRoutes.js     ◄── BARU (Langkah 3)
    └── server.js                ◄── DIPERBARUI (Langkah 4)
```

---

### **Langkah 1: Membuat Model Proyek (`models/projectModel.js`)**
Buat file baru bernama `projectModel.js` di dalam folder `backend/src/models/`, lalu ketik kode berikut:

```javascript
const db = require('../config/db');

// 1. Mengambil SEMUA data proyek (Diurutkan dari yang terbaru)
const getAllProjects = async () => {
    const [rows] = await db.query('SELECT * FROM projects ORDER BY created_at DESC');
    return rows; // Mengembalikan array berisi daftar proyek
};

// 2. Mengambil SATU data proyek berdasarkan ID
const getProjectById = async (id) => {
    const [rows] = await db.query('SELECT * FROM projects WHERE id = ?', [id]);
    return rows[0]; // Hanya ambil baris pertama yang cocok
};

// 3. Menambahkan proyek baru (CREATE)
const createProject = async (data) => {
    const { title, description, category, image_url, demo_url, github_url, tech_stack, is_featured } = data;

    const [result] = await db.query(
        `INSERT INTO projects (title, description, category, image_url, demo_url, github_url, tech_stack, is_featured)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
        [title, description, category, image_url, demo_url, github_url, tech_stack, is_featured || false]
    );
    return result; 
};

// 4. Memperbarui data proyek (UPDATE)
const updateProject = async (id, data) => {
    const { title, description, category, image_url, demo_url, github_url, tech_stack, is_featured } = data;

    const [result] = await db.query(
        `UPDATE projects SET 
            title = ?, description = ?, category = ?, 
            image_url = ?, demo_url = ?, github_url = ?, 
            tech_stack = ?, is_featured = ?
        WHERE id = ?`,
        [title, description, category, image_url, demo_url, github_url, tech_stack, is_featured, id]
    );
    return result;
};

// 5. Menghapus proyek (DELETE)
const deleteProject = async (id) => {
    const [result] = await db.query('DELETE FROM projects WHERE id = ?', [id]);
    return result;
};

module.exports = {
    getAllProjects,
    getProjectById,
    createProject,
    updateProject,
    deleteProject
};
```
> 💡 **Penjelasan Singkat:** Model ini bertugas menangani interaksi langsung dengan tabel `projects` menggunakan parameterisasi `?` untuk keamanan dari serangan *SQL Injection*.

---

### **Langkah 2: Membuat Controller Proyek (`controller/projectController.js`)**
Buat file baru bernama `projectController.js` di dalam folder `backend/src/controller/`, lalu ketik kode berikut:

```javascript
const projectModel = require('../models/projectModel');

// 1. GET ALL
const getAllProjects = async (req, res) => {
    try {
        const projects = await projectModel.getAllProjects();
        res.status(200).json({
            success: true,
            message: 'Berhasil mengambil semua data proyek.',
            total: projects.length, // Tambahan info jumlah data
            data: projects
        });
    } catch (error) {
        console.error('Error getAllProjects:', error.message);
        res.status(500).json({ success: false, message: 'Server Error', error: error.message });
    }
};

// 2. GET BY ID
const getProjectById = async (req, res) => {
    try {
        const { id } = req.params; // Ambil ID dari URL
        const project = await projectModel.getProjectById(id);

        if (!project) {
            return res.status(404).json({ success: false, message: `Proyek ID ${id} tidak ditemukan.` });
        }
        res.status(200).json({ success: true, message: 'Berhasil mengambil data proyek.', data: project });
    } catch (error) {
        console.error('Error getProjectById:', error.message);
        res.status(500).json({ success: false, message: 'Server Error', error: error.message });
    }
};

// 3. CREATE / POST
const createProject = async (req, res) => {
    try {
        const data = req.body;
        if (!data.title) {
            return res.status(400).json({ success: false, message: 'Kolom "title" wajib diisi!' });
        }

        const result = await projectModel.createProject(data);
        res.status(201).json({
            success: true,
            message: 'Proyek baru berhasil ditambahkan!',
            data: { id: result.insertId } // Kembalikan ID data yang baru masuk
        });
    } catch (error) {
        console.error('Error createProject:', error.message);
        res.status(500).json({ success: false, message: 'Server Error', error: error.message });
    }
};

// 4. UPDATE / PUT
const updateProject = async (req, res) => {
    try {
        const { id } = req.params;
        const data = req.body;

        if (!data.title) {
            return res.status(400).json({ success: false, message: 'Kolom "title" wajib diisi!' });
        }

        const result = await projectModel.updateProject(id, data);
        if (result.affectedRows === 0) {
            return res.status(404).json({ success: false, message: `Proyek ID ${id} tidak ditemukan.` });
        }
        res.status(200).json({ success: true, message: 'Data proyek berhasil diperbarui.' });
    } catch (error) {
        console.error('Error updateProject:', error.message);
        res.status(500).json({ success: false, message: 'Server Error', error: error.message });
    }
};

// 5. DELETE
const deleteProject = async (req, res) => {
    try {
        const { id } = req.params;
        const result = await projectModel.deleteProject(id);

        if (result.affectedRows === 0) {
            return res.status(404).json({ success: false, message: `Proyek ID ${id} tidak ditemukan.` });
        }
        res.status(200).json({ success: true, message: 'Proyek berhasil dihapus.' });
    } catch (error) {
        console.error('Error deleteProject:', error.message);
        res.status(500).json({ success: false, message: 'Server Error', error: error.message });
    }
};

module.exports = { getAllProjects, getProjectById, createProject, updateProject, deleteProject };
```

---

### **Langkah 3: Membuat Routes Proyek (`routes/projectRoutes.js`)**
Buat file `projectRoutes.js` di folder `routes/` untuk mengatur jalurnya:

```javascript
const express = require('express');
const router = express.Router();
const projectController = require('../controller/projectController');

// Daftar Rute CRUD
router.get('/', projectController.getAllProjects);          // READ ALL
router.get('/:id', projectController.getProjectById);       // READ ONE
router.post('/', projectController.createProject);          // CREATE
router.put('/:id', projectController.updateProject);        // UPDATE
router.delete('/:id', projectController.deleteProject);     // DELETE

module.exports = router;
```

---

### **Langkah 4: Mendaftarkan Rute di `server.js`**
Buka `server.js` dan panggil `projectRoutes` persis di bawah rute profil yang kita buat pertemuan lalu:

```javascript
// ...
const profileRoutes = require('./routes/profileRoutes');
const projectRoutes = require('./routes/projectRoutes'); // BARU

app.use('/api/profile', profileRoutes);
app.use('/api/projects', projectRoutes); // BARU
// ... (pastikan blok 404 tetap ada di bagian paling bawah)
```

---

### **Langkah 5: Uji Coba API di Postman / Thunder Client**
Jalankan server (`npm run dev`), dan coba uji semua operasi CRUD:

| Method | URL | Body (JSON) | Ekspektasi |
| :--- | :--- | :--- | :--- |
| **GET** | `/api/projects` | *(kosong)* | Menampilkan array berisi data proyek (dummy) yang dibuat saat pertemuan 3. |
| **POST** | `/api/projects` | `{"title": "Proyek Uji Coba", "category": "Backend"}` | Menambahkan proyek baru. Akan mengembalikan ID baru (misal `id: 2`). |
| **GET** | `/api/projects/2` | *(kosong)* | Menampilkan detail proyek yang baru saja ditambahkan (berdasarkan ID). |
| **PUT** | `/api/projects/2` | `{"title": "Judul Diubah", "category": "Frontend"}` | Mengubah isi proyek ber-ID 2. |
| **DELETE** | `/api/projects/2` | *(kosong)* | Menghapus proyek ber-ID 2. |

---

## 📝 BAGIAN V: LEMBAR KERJA SISWA (LKS) & TUGAS MANDIRI

**Nama Siswa:** ___________________________  
**Kelas / No. Presensi:** ___________________________  

### Instruksi Tugas:
1. Lakukan operasi **POST** untuk menambahkan karya/proyek nyata milikmu sendiri ke dalam database melalui API. Sertakan screenshot respon dari Postman.
2. Lakukan operasi **DELETE** pada proyek percobaan, buktikan dengan melakukan GET kembali dan pastikan data sudah hilang (atau berikan screenshot *affectedRows*).
3. **Analisis Kode:** Pada method POST, data ID tidak dikirimkan melalui body JSON, tapi bisa tersimpan dengan nomor yang benar. Mengapa demikian? Berhubungan dengan fitur apa pada pembuatan tabel di Pertemuan 3?

---

## 📊 BAGIAN VI: RUBRIK PENILAIAN PRAKTIKUM

| No | Aspek Penilaian | Kriteria Evaluasi | Skor Maks | Skor Perolehan |
| :---: | :--- | :--- | :---: | :---: |
| 1 | **Model CRUD** | Kelima query SQL (Select, Insert, Update, Delete) benar | 20 | |
| 2 | **Controller CRUD** | Menangani 5 endpoint dengan validasi dan `try...catch` | 20 | |
| 3 | **Routing** | Penulisan method HTTP GET, POST, PUT, DELETE benar | 20 | |
| 4 | **Pengujian API** | Semua endpoint dites sukses di Postman / Thunder Client | 20 | |
| 5 | **Tugas Mandiri** | Siswa dapat mengisi LKS dan menjawab dengan analisis yang baik | 20 | |
| **TOTAL SKOR** | | | **100** | |
