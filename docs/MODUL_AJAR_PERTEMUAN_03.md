# 📄 MODUL AJAR & LEMBAR KERJA PRAKTIKUM (LKS)
## PEMROGRAMAN WEB DAN PERANGKAT BERGERAK (BACKEND)
**Proyek:** Pembuatan Web Portofolio Dinamis  
**Stack Teknologi:** Express.js, MySQL, Next.js  
**Tingkat / Fase:** SMK Kelas XI / XII - Rekayasa Perangkat Lunak (Fase F)  
**Pertemuan:** 3 dari 12 Pertemuan  
**Alokasi Waktu:** 4 Jam Pelajaran (4 x 45 Menit)  
**Materi Pokok:** Perancangan Database MySQL (`db_portofolio`), Skema Tabel, & Data Awal (*Seeding*)  

---

## 🎯 BAGIAN I: IDENTITAS & TUJUAN PEMBELAJARAN

### A. Capaian Pembelajaran (CP)
Peserta didik mampu merancang struktur basis data relasional (*Relational Database Management System - RDBMS*), menentukan tipe data dan constraint yang tepat, serta mengeksekusi perintah SQL DDL (*Data Definition Language*) dan DML (*Data Manipulation Language*) untuk kebutuhan backend API.

### B. Tujuan Pembelajaran Khusus (TP)
1. Siswa dapat memahami kebutuhan struktur data untuk aplikasi web portofolio dinamis.
2. Siswa dapat menjelaskan fungsi masing-masing tabel (`users`, `profile`, `skills`, `projects`, `experiences`, `messages`).
3. Siswa dapat memilih tipe data yang sesuai (`INT`, `VARCHAR`, `TEXT`, `BOOLEAN`, `ENUM`, `DATE`, `TIMESTAMP`).
4. Siswa dapat membuat database `db_portofolio` dan tabel-tabelnya menggunakan script SQL DDL.
5. Siswa dapat memasukkan data awal (*initial/dummy data*) menggunakan perintah SQL DML `INSERT`.
6. Siswa dapat memverifikasi isi tabel menggunakan perintah `SELECT` melalui phpMyAdmin, MySQL CLI, atau database client.

---

## 🗺️ BAGIAN II: POSISI PERTEMUAN DALAM SILABUS

| Pertemuan | Status | Materi Pokok | Target Output |
| :---: | :---: | :--- | :--- |
| **01** | Selesai | Inisialisasi Proyek Backend & Frontend | Folder & Node.js Siap |
| **02** | Selesai | Dasar Express.js, Routing & JSON Respon | Web Server Aktif |
| **03** | **Hari Ini** | **Perancangan Database MySQL & Skema Tabel** | **Database `db_portofolio` & 6 Tabel Siap** |
| **04** | Berikutnya| Koneksi Database Pool (`mysql2`) & Pola MVC | Backend Terhubung DB |

---

## 📚 BAGIAN III: LANDASAN TEORI SINGKAT

### 1. Mengapa Kita Membutuhkan Database?
Pada Pertemuan 2, data respon API ditulis langsung (*hardcoded*) di dalam kode JavaScript. Jika server dimatikan, semua perubahan data akan hilang. **Database MySQL** berfungsi sebagai media penyimpanan data yang **permanen (persisten)**, aman, dan mudah dicari/dimanipulasi melalui query SQL.

### 2. Tipe Data Penting di MySQL:
- **`INT AUTO_INCREMENT`**: Angka bulat yang otomatis bertambah 1 setiap ada baris baru, cocok untuk `PRIMARY KEY (id)`.
- **`VARCHAR(N)`**: Teks pendek dengan batas maksimal `N` karakter (contoh: nama, email, judul proyek).
- **`TEXT`**: Teks panjang tanpa batasan kaku (contoh: deskripsi proyek, isi pesan, artikel bio).
- **`ENUM('a', 'b')`**: Membatasi input data hanya pada pilihan tertentu (contoh: kategori skill `Frontend`, `Backend`, `Tools`).
- **`BOOLEAN`**: Bernilai benar/salah (`TRUE` atau `FALSE`), cocok untuk status `is_featured` atau `is_read`.
- **`DATE`**: Menyimpan tanggal dengan format `YYYY-MM-DD`.
- **`TIMESTAMP DEFAULT CURRENT_TIMESTAMP`**: Otomatis mencatat tanggal dan jam saat data dibuat/diedit.

---

## 🏗️ BAGIAN IV: RANCANGAN SKEMA TABEL PORTOFOLIO

Berikut adalah 6 tabel utama yang dirancang untuk mendukung seluruh fitur portofolio dinamis:

```
+-------------------+        +-------------------+        +-------------------+
|      profile      |        |      skills       |        |     projects      |
+-------------------+        +-------------------+        +-------------------+
| id (PK)           |        | id (PK)           |        | id (PK)           |
| name              |        | name              |        | title             |
| role              |        | category (ENUM)   |        | description       |
| bio               |        | level (INT)       |        | category          |
| about             |        | icon              |        | image_url         |
| avatar_url        |        | created_at        |        | demo_url          |
| email, phone      |        +-------------------+        | github_url        |
| github, linkedin  |                                     | tech_stack        |
+-------------------+                                     | is_featured (BOOL)|
                                                          +-------------------+
+-------------------+        +-------------------+        +-------------------+
|    experiences    |        |     messages      |        |       users       |
+-------------------+        +-------------------+        +-------------------+
| id (PK)           |        | id (PK)           |        | id (PK)           |
| type (ENUM)       |        | sender_name       |        | username (UNIQUE) |
| title             |        | sender_email      |        | email (UNIQUE)    |
| company           |        | subject           |        | password (HASH)   |
| start_date        |        | message           |        | created_at        |
| is_current (BOOL) |        | is_read (BOOL)    |        +-------------------+
+-------------------+        +-------------------+
```

---

## 🛠️ BAGIAN V: LANGKAH KERJA PRAKTIKUM (STEP-BY-STEP)

---

### **Langkah 1: Menyalakan Service MySQL (XAMPP / Laragon / Standalone MySQL)**
1. Buka aplikasi **XAMPP Control Panel** (atau Laragon).
2. Klik tombol **Start** pada modul **MySQL** (dan Apache jika menggunakan phpMyAdmin).
3. Pastikan port MySQL berjalan di port default `3306`.

---

### **Langkah 2: Membuka File Skema SQL di Proyek**
File skema database telah disiapkan di dalam folder proyek Anda:  
📁 Lokasi: `backend/database/schema.sql`

Mari kita pelajari isi kodenya:

```sql
-- =====================================================
-- 1. MEMBUAT DATABASE
-- =====================================================
CREATE DATABASE IF NOT EXISTS db_portofolio;
USE db_portofolio;

-- =====================================================
-- 2. TABEL USERS (ADMIN UNTUK LOGIN BACKEND)
-- =====================================================
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =====================================================
-- 3. TABEL PROFILE (INFORMASI PROFIL PEMILIK)
-- =====================================================
CREATE TABLE IF NOT EXISTS profile (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    role VARCHAR(100) NOT NULL,
    bio TEXT,
    about TEXT,
    avatar_url VARCHAR(255),
    resume_url VARCHAR(255),
    email VARCHAR(100),
    phone VARCHAR(20),
    address VARCHAR(255),
    github_url VARCHAR(255),
    linkedin_url VARCHAR(255),
    instagram_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =====================================================
-- 4. TABEL SKILLS (DAFTAR KEAHLIAN / TEKNOLOGI)
-- =====================================================
CREATE TABLE IF NOT EXISTS skills (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    category ENUM('Frontend', 'Backend', 'Database', 'Tools', 'Other') DEFAULT 'Frontend',
    level INT DEFAULT 80,
    icon VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =====================================================
-- 5. TABEL PROJECTS (DAFTAR KARYA / PROYEK)
-- =====================================================
CREATE TABLE IF NOT EXISTS projects (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    description TEXT,
    category VARCHAR(50) DEFAULT 'Web Development',
    image_url VARCHAR(255),
    demo_url VARCHAR(255),
    github_url VARCHAR(255),
    tech_stack VARCHAR(255),
    is_featured BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =====================================================
-- 6. TABEL EXPERIENCES (PENGALAMAN KERJA / PENDIDIKAN)
-- =====================================================
CREATE TABLE IF NOT EXISTS experiences (
    id INT AUTO_INCREMENT PRIMARY KEY,
    type ENUM('work', 'education', 'organization') DEFAULT 'work',
    title VARCHAR(100) NOT NULL,
    company VARCHAR(100) NOT NULL,
    location VARCHAR(100),
    start_date DATE,
    end_date DATE,
    is_current BOOLEAN DEFAULT FALSE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =====================================================
-- 7. TABEL MESSAGES (PESAN DARI PENGUNJUNG)
-- =====================================================
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

---

### **Langkah 3: Mengeksekusi Script SQL**
Ada dua cara mudah untuk mengeksekusi script SQL ini:

#### **Opsi A: Melalui phpMyAdmin (Browser)**
1. Buka browser dan masuk ke `http://localhost/phpmyadmin/`.
2. Klik tab **Import** (atau tab **SQL**).
3. Salin (*copy*) seluruh isi file `backend/database/schema.sql`, tempel di kotak query SQL, lalu klik tombol **Go / Kirim**.

#### **Opsi B: Melalui Terminal MySQL CLI**
Buka terminal dan jalankan perintah berikut:
```bash
mysql -u root -p < backend/database/schema.sql
```
*(Tekan Enter jika user root tidak menggunakan password).*

---

### **Langkah 4: Memasukkan Data Awal (Dummy Data Seeding)**
Agar saat membuat REST API di pertemuan berikutnya kita langsung bisa melihat data saat di-`GET`, kita masukkan data awal berikut:

```sql
-- Memasukkan Data Profil Siswa
INSERT INTO profile (name, role, bio, about, email, phone, address, github_url, linkedin_url, instagram_url) 
VALUES (
    'Ahmad Fauzi',
    'Junior Fullstack Web Developer',
    'Siswa RPL yang antusias membangun backend Express.js dan antarmuka modern.',
    'Halo! Saya seorang siswa SMK jurusan RPL dengan minat tinggi pada pemrograman web dan arsitektur REST API.',
    'ahmad.fauzi@example.com',
    '+6281234567890',
    'Jakarta, Indonesia',
    'https://github.com/ahmadfauzi',
    'https://linkedin.com/in/ahmadfauzi',
    'https://instagram.com/ahmadfauzi'
);

-- Memasukkan Data Skills Awal
INSERT INTO skills (name, category, level, icon) VALUES 
('HTML5 & CSS3', 'Frontend', 90, 'html5'),
('JavaScript (ES6+)', 'Frontend', 85, 'javascript'),
('React / Next.js', 'Frontend', 75, 'react'),
('Node.js & Express.js', 'Backend', 80, 'nodejs'),
('MySQL', 'Database', 80, 'mysql'),
('Git & GitHub', 'Tools', 85, 'git');

-- Memasukkan Data Proyek Awal
INSERT INTO projects (title, description, category, tech_stack, is_featured) VALUES 
(
    'Sistem Informasi Absensi Sekolah',
    'Aplikasi web untuk mencatat kehadiran siswa dan rekapitulasi data.',
    'Web Development',
    'Express.js, Next.js, MySQL',
    TRUE
),
(
    'E-Commerce Toko Komputer',
    'Platform toko online sederhana dengan katalog produk dan checkout.',
    'Web Development',
    'Laravel, MySQL, Bootstrap',
    FALSE
);
```

---

### **Langkah 5: Memverifikasi Data dengan Query `SELECT`**
Jalankan query pengujian berikut di phpMyAdmin atau SQL tab:

```sql
-- Cek apakah tabel profile terisi
SELECT * FROM profile;

-- Cek daftar keahlian
SELECT name, category, level FROM skills WHERE category = 'Frontend';

-- Cek proyek yang di-featured
SELECT title, tech_stack FROM projects WHERE is_featured = TRUE;
```

---

## 📝 BAGIAN VI: LEMBAR KERJA SISWA (LKS) & TUGAS MANDIRI

**Nama Siswa:** ___________________________  
**Kelas / No. Presensi:** ___________________________  
**Tanggal Pengerjaan:** ___________________________  

### Instruksi Tugas Mandiri:
1. **Latihan 1 (Kustomisasi Data Diri):**  
   Ubah data dummy di tabel `profile` menggunakan query `UPDATE` agar sesuai dengan nama lengkap, nomor telepon, dan bio profil asli Anda:
   ```sql
   UPDATE profile 
   SET name = 'Nama Lengkap Anda', 
       role = 'Web Developer & Siswa RPL',
       email = 'email.anda@gmail.com'
   WHERE id = 1;
   ```
2. **Latihan 2 (Menambahkan Data Skill & Pengalaman Baru):**  
   Tuliskan perintah `INSERT` untuk menambahkan 2 keahlian baru ke tabel `skills` (misal: *Figma* pada kategori *Tools* dan *PHP* pada kategori *Backend*).
3. **Latihan 3 (Studi Kasus Relasi):**  
   Jelaskan mengapa password pada tabel `users` dibuat bertipe `VARCHAR(255)` dan tidak boleh disimpan dalam bentuk teks biasa (*plain text*)!

---

## 📊 BAGIAN VII: RUBRIK PENILAIAN PRAKTIKUM

| No | Aspek Penilaian | Kriteria Evaluasi | Skor Maks | Skor Perolehan |
| :---: | :--- | :--- | :---: | :---: |
| 1 | **Pembuatan Database** | Database `db_portofolio` berhasil dibuat tanpa error | 20 | |
| 2 | **Kelengkapan 6 Tabel** | Seluruh tabel beserta tipe data dan constraint terpasang lengkap | 30 | |
| 3 | **Eksekusi Data Dummy** | Data awal (*seeding*) berhasil masuk ke tabel | 20 | |
| 4 | **Tugas Mandiri (Query)** | Berhasil melakukan kustomisasi data dengan query `UPDATE` & `INSERT` | 20 | |
| 5 | **Jawaban Analisis** | Menjawab pertanyaan analisis keamanan password dengan tepat | 10 | |
| **TOTAL SKOR** | | | **100** | |

---

## ❓ BAGIAN VIII: TROUBLESHOOTING

| Gejala Masalah | Penyebab | Cara Mengatasi |
| :--- | :--- | :--- |
| `MySQL shutdown unexpectedly` di XAMPP | Port 3306 sedang dipakai aplikasi lain (misal: MySQL service bawaan Windows). | Buka `Config` MySQL di XAMPP $\rightarrow$ ubah port menjadi `3307`, atau matikan service MySQL lokal di `services.msc`. |
| `Access denied for user 'root'@'localhost'` | Username atau password MySQL salah. | Cek apakah MySQL Anda memiliki password (default XAMPP tanpa password). |
| `Data truncated for column` | Nilai data yang dimasukkan melebihi batas panjang karakter `VARCHAR`. | Periksa panjang karakter yang di-input atau tingkatkan batas `VARCHAR(N)`. |
