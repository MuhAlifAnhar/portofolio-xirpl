# 📄 MODUL AJAR & LEMBAR KERJA PRAKTIKUM (LKS)
## PEMROGRAMAN WEB DAN PERANGKAT BERGERAK (BACKEND)
**Proyek:** Pembuatan Web Portofolio Dinamis  
**Stack Teknologi:** Express.js, MySQL, Next.js  
**Tingkat / Fase:** SMK Kelas XI / XII - Rekayasa Perangkat Lunak (Fase F)  
**Pertemuan:** 7 dari 12 Pertemuan  
**Alokasi Waktu:** 4 Jam Pelajaran (4 x 45 Menit)  
**Materi Pokok:** Implementasi CRUD 3 & 4 — Modul Skills dan Experiences

---

## 🎯 BAGIAN I: TUJUAN PEMBELAJARAN

### Tujuan Pembelajaran Khusus (TP)
1. Siswa mampu membuat fungsionalitas CRUD secara utuh untuk tabel `skills` dan `experiences`.
2. Siswa mampu menerapkan kembali konsep MVC untuk tabel yang memiliki banyak baris data.
3. Siswa mampu mendaftarkan Routes baru di dalam file utama server.
4. Siswa mampu melakukan pengujian untuk endpoint *Skills* dan *Experiences* menggunakan Postman/Thunder Client.

---

## 🗺️ BAGIAN II: POSISI PERTEMUAN DALAM SILABUS

| Pertemuan | Status | Materi Pokok | Target Output |
| :---: | :---: | :--- | :--- |
| **06** | Selesai | CRUD 2: Modul Proyek (*Portofolio Karya*) | Endpoint CRUD Penuh (5 Rute) |
| **07** | **Hari Ini** | **CRUD 3: Modul Skills & Experiences** | **Endpoint CRUD Skills & Exp** |
| **08** | Berikutnya| CRUD 4: Modul Pesan Kontak (*Contact Messages*) | Endpoint Contact Messages |

---

## 📚 BAGIAN III: LANDASAN TEORI

Pada pertemuan sebelumnya, kita sudah berhasil membuat CRUD lengkap untuk tabel `projects`. Hari ini, kita akan melakukan hal yang serupa untuk tabel `skills` dan `experiences`.

Prosesnya sama persis:
1. Buat **Model** untuk eksekusi query (GET, INSERT, UPDATE, DELETE).
2. Buat **Controller** untuk logika (req, res).
3. Buat **Routes** untuk mapping URL.
4. Daftarkan di **server.js**.

Pengulangan ini penting agar Anda semakin terbiasa dan hafal dengan alur kerja arsitektur **MVC (Model-View-Controller)**.

---

## 🛠️ BAGIAN IV: LANGKAH KERJA PRAKTIKUM (STEP-BY-STEP)

```
[Struktur File yang Akan Dibuat/Diperbarui Hari Ini]
backend/
└── src/
    ├── models/
    │   ├── skillModel.js           ◄── BARU (Langkah 1)
    │   └── experienceModel.js      ◄── BARU (Langkah 2)
    ├── controller/
    │   ├── skillController.js      ◄── BARU (Langkah 1)
    │   └── experienceController.js ◄── BARU (Langkah 2)
    ├── routes/
    │   ├── skillRoutes.js          ◄── BARU (Langkah 1)
    │   └── experienceRoutes.js     ◄── BARU (Langkah 2)
    └── server.js                   ◄── DIPERBARUI (Langkah 3)
```

---

### **Langkah 1: Membuat Modul Skills**

#### A. Membuat Model `skillModel.js`
Buat file baru: `backend/src/models/skillModel.js`

```javascript
const db = require('../config/db');

// GET ALL
const getAllSkills = async () => {
    const [rows] = await db.query('SELECT * FROM skills ORDER BY category, name');
    return rows;
};

// GET BY ID
const getSkillById = async (id) => {
    const [rows] = await db.query('SELECT * FROM skills WHERE id = ?', [id]);
    return rows[0];
};

// CREATE
const createSkill = async (data) => {
    const { name, category, percentage, icon_url } = data;
    const [result] = await db.query(
        'INSERT INTO skills (name, category, percentage, icon_url) VALUES (?, ?, ?, ?)',
        [name, category || 'Other', percentage || 0, icon_url]
    );
    return result;
};

// UPDATE
const updateSkill = async (id, data) => {
    const { name, category, percentage, icon_url } = data;
    const [result] = await db.query(
        'UPDATE skills SET name = ?, category = ?, percentage = ?, icon_url = ? WHERE id = ?',
        [name, category, percentage, icon_url, id]
    );
    return result;
};

// DELETE
const deleteSkill = async (id) => {
    const [result] = await db.query('DELETE FROM skills WHERE id = ?', [id]);
    return result;
};

module.exports = { getAllSkills, getSkillById, createSkill, updateSkill, deleteSkill };
```

#### B. Membuat Controller `skillController.js`
Buat file baru: `backend/src/controller/skillController.js`

```javascript
const skillModel = require('../models/skillModel');

const getAllSkills = async (req, res) => {
    try {
        const skills = await skillModel.getAllSkills();
        res.status(200).json({ success: true, total: skills.length, data: skills });
    } catch (error) {
        res.status(500).json({ success: false, message: 'Server Error', error: error.message });
    }
};

const getSkillById = async (req, res) => {
    try {
        const { id } = req.params;
        const skill = await skillModel.getSkillById(id);
        if (!skill) return res.status(404).json({ success: false, message: 'Data tidak ditemukan' });
        res.status(200).json({ success: true, data: skill });
    } catch (error) {
        res.status(500).json({ success: false, message: 'Server Error', error: error.message });
    }
};

const createSkill = async (req, res) => {
    try {
        const data = req.body;
        if (!data.name) return res.status(400).json({ success: false, message: 'Nama skill wajib diisi' });
        const result = await skillModel.createSkill(data);
        res.status(201).json({ success: true, message: 'Skill ditambahkan', data: { id: result.insertId } });
    } catch (error) {
        res.status(500).json({ success: false, message: 'Server Error', error: error.message });
    }
};

const updateSkill = async (req, res) => {
    try {
        const { id } = req.params;
        const data = req.body;
        if (!data.name) return res.status(400).json({ success: false, message: 'Nama skill wajib diisi' });
        
        const result = await skillModel.updateSkill(id, data);
        if (result.affectedRows === 0) return res.status(404).json({ success: false, message: 'Data tidak ditemukan' });
        res.status(200).json({ success: true, message: 'Skill diperbarui' });
    } catch (error) {
        res.status(500).json({ success: false, message: 'Server Error', error: error.message });
    }
};

const deleteSkill = async (req, res) => {
    try {
        const { id } = req.params;
        const result = await skillModel.deleteSkill(id);
        if (result.affectedRows === 0) return res.status(404).json({ success: false, message: 'Data tidak ditemukan' });
        res.status(200).json({ success: true, message: 'Skill dihapus' });
    } catch (error) {
        res.status(500).json({ success: false, message: 'Server Error', error: error.message });
    }
};

module.exports = { getAllSkills, getSkillById, createSkill, updateSkill, deleteSkill };
```

#### C. Membuat Routes `skillRoutes.js`
Buat file baru: `backend/src/routes/skillRoutes.js`

```javascript
const express = require('express');
const router = express.Router();
const skillController = require('../controller/skillController');

router.get('/', skillController.getAllSkills);
router.get('/:id', skillController.getSkillById);
router.post('/', skillController.createSkill);
router.put('/:id', skillController.updateSkill);
router.delete('/:id', skillController.deleteSkill);

module.exports = router;
```

---

### **Langkah 2: Membuat Modul Experiences**

#### A. Membuat Model `experienceModel.js`
Buat file baru: `backend/src/models/experienceModel.js`

```javascript
const db = require('../config/db');

// GET ALL
const getAllExperiences = async () => {
    const [rows] = await db.query('SELECT * FROM experiences ORDER BY start_date DESC');
    return rows;
};

// GET BY ID
const getExperienceById = async (id) => {
    const [rows] = await db.query('SELECT * FROM experiences WHERE id = ?', [id]);
    return rows[0];
};

// CREATE
const createExperience = async (data) => {
    const { title, company, location, start_date, end_date, is_current, description } = data;
    const [result] = await db.query(
        'INSERT INTO experiences (title, company, location, start_date, end_date, is_current, description) VALUES (?, ?, ?, ?, ?, ?, ?)',
        [title, company, location, start_date, end_date, is_current || false, description]
    );
    return result;
};

// UPDATE
const updateExperience = async (id, data) => {
    const { title, company, location, start_date, end_date, is_current, description } = data;
    const [result] = await db.query(
        'UPDATE experiences SET title = ?, company = ?, location = ?, start_date = ?, end_date = ?, is_current = ?, description = ? WHERE id = ?',
        [title, company, location, start_date, end_date, is_current, description, id]
    );
    return result;
};

// DELETE
const deleteExperience = async (id) => {
    const [result] = await db.query('DELETE FROM experiences WHERE id = ?', [id]);
    return result;
};

module.exports = { getAllExperiences, getExperienceById, createExperience, updateExperience, deleteExperience };
```

#### B. Membuat Controller `experienceController.js`
Buat file baru: `backend/src/controller/experienceController.js`

```javascript
const experienceModel = require('../models/experienceModel');

const getAllExperiences = async (req, res) => {
    try {
        const experiences = await experienceModel.getAllExperiences();
        res.status(200).json({ success: true, total: experiences.length, data: experiences });
    } catch (error) {
        res.status(500).json({ success: false, message: 'Server Error', error: error.message });
    }
};

const getExperienceById = async (req, res) => {
    try {
        const { id } = req.params;
        const experience = await experienceModel.getExperienceById(id);
        if (!experience) return res.status(404).json({ success: false, message: 'Data tidak ditemukan' });
        res.status(200).json({ success: true, data: experience });
    } catch (error) {
        res.status(500).json({ success: false, message: 'Server Error', error: error.message });
    }
};

const createExperience = async (req, res) => {
    try {
        const data = req.body;
        if (!data.title || !data.company) return res.status(400).json({ success: false, message: 'Title dan company wajib diisi' });
        const result = await experienceModel.createExperience(data);
        res.status(201).json({ success: true, message: 'Experience ditambahkan', data: { id: result.insertId } });
    } catch (error) {
        res.status(500).json({ success: false, message: 'Server Error', error: error.message });
    }
};

const updateExperience = async (req, res) => {
    try {
        const { id } = req.params;
        const data = req.body;
        if (!data.title || !data.company) return res.status(400).json({ success: false, message: 'Title dan company wajib diisi' });
        
        const result = await experienceModel.updateExperience(id, data);
        if (result.affectedRows === 0) return res.status(404).json({ success: false, message: 'Data tidak ditemukan' });
        res.status(200).json({ success: true, message: 'Experience diperbarui' });
    } catch (error) {
        res.status(500).json({ success: false, message: 'Server Error', error: error.message });
    }
};

const deleteExperience = async (req, res) => {
    try {
        const { id } = req.params;
        const result = await experienceModel.deleteExperience(id);
        if (result.affectedRows === 0) return res.status(404).json({ success: false, message: 'Data tidak ditemukan' });
        res.status(200).json({ success: true, message: 'Experience dihapus' });
    } catch (error) {
        res.status(500).json({ success: false, message: 'Server Error', error: error.message });
    }
};

module.exports = { getAllExperiences, getExperienceById, createExperience, updateExperience, deleteExperience };
```

#### C. Membuat Routes `experienceRoutes.js`
Buat file baru: `backend/src/routes/experienceRoutes.js`

```javascript
const express = require('express');
const router = express.Router();
const experienceController = require('../controller/experienceController');

router.get('/', experienceController.getAllExperiences);
router.get('/:id', experienceController.getExperienceById);
router.post('/', experienceController.createExperience);
router.put('/:id', experienceController.updateExperience);
router.delete('/:id', experienceController.deleteExperience);

module.exports = router;
```

---

### **Langkah 3: Mendaftarkan Rute di `server.js`**
Buka file `backend/src/server.js`, dan tambahkan pendaftaran rute untuk `skills` dan `experiences` di bawah rute proyek:

```javascript
// ...
const profileRoutes = require('./routes/profileRoutes');
const projectRoutes = require('./routes/projectRoutes');
const skillRoutes = require('./routes/skillRoutes'); // BARU
const experienceRoutes = require('./routes/experienceRoutes'); // BARU

app.use('/api/profile', profileRoutes);
app.use('/api/projects', projectRoutes);
app.use('/api/skills', skillRoutes); // BARU
app.use('/api/experiences', experienceRoutes); // BARU
// ... (pastikan blok 404 tetap ada di bagian paling bawah)
```

---

### **Langkah 4: Uji Coba API di Postman / Thunder Client**
Jalankan server (`npm run dev`), dan coba uji endpoint baru:

| Method | URL API | Input Body (JSON) | Ekspektasi Hasil |
| :---: | :--- | :--- | :--- |
| **POST** | `/api/skills` | `{"name": "ReactJS", "category": "Frontend", "percentage": 85}` | Menambahkan skill baru. |
| **GET** | `/api/skills` | *(kosong)* | Menampilkan daftar skills. |
| **POST** | `/api/experiences` | `{"title": "Junior Developer", "company": "PT Maju Jaya", "start_date": "2023-01-01", "is_current": true}` | Menambahkan pengalaman baru. |
| **GET** | `/api/experiences` | *(kosong)* | Menampilkan daftar pengalaman. |

---

## 📝 BAGIAN V: LEMBAR KERJA SISWA (LKS) & TUGAS MANDIRI

**Nama Siswa:** ___________________________  
**Kelas / No. Presensi:** ___________________________  

### Instruksi Tugas:
1. **Tugas Praktik 1 (Skills):** Masukkan minimal 3 skill/kemampuan komputermu melalui method `POST` di tabel `skills`.
2. **Tugas Praktik 2 (Experiences):** Masukkan riwayat kepanitiaan, ekstrakurikuler, atau PKL-mu di tabel `experiences` melalui method `POST`.
3. **Analisis Kode:** Pada Model `skills`, pada fungsi `getAllSkills`, terdapat perintah `ORDER BY category, name`. Jelaskan maksud dari perintah pengurutan tersebut!

---

## 📊 BAGIAN VI: RUBRIK PENILAIAN PRAKTIKUM

| No | Aspek Penilaian | Kriteria Evaluasi | Skor Maks | Skor Perolehan |
| :---: | :--- | :--- | :---: | :---: |
| 1 | **Modul Skills** | Mampu membuat model, controller, dan routes untuk skills dengan benar | 30 | |
| 2 | **Modul Experiences** | Mampu membuat model, controller, dan routes untuk experiences dengan benar | 30 | |
| 3 | **Routing** | Routes didaftarkan di server.js dengan prefix URL yang benar | 10 | |
| 4 | **Pengujian API** | Berhasil melakukan testing pada endpoint skills dan experiences | 15 | |
| 5 | **Tugas Mandiri** | Melengkapi LKS dengan input data relevan dan jawaban analisis yang tepat | 15 | |
| **TOTAL SKOR** | | | **100** | |
