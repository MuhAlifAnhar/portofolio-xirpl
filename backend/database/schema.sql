-- =====================================================
-- DATABASE SCHEMA: PORTOFOLIO DINAMIS
-- Pertemuan 3: Perancangan Database & Skema Tabel
-- =====================================================

-- 1. Membuat Database
CREATE DATABASE IF NOT EXISTS db_portofolio;
USE db_portofolio;

-- 2. Tabel Users (Admin untuk Pengelolaan Portofolio)
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 3. Tabel Profile (Informasi Utama Pemilik Portofolio)
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

-- 4. Tabel Skills (Daftar Keahlian / Teknologi)
CREATE TABLE IF NOT EXISTS skills (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    category ENUM('Frontend', 'Backend', 'Database', 'Tools', 'Other') DEFAULT 'Frontend',
    level INT DEFAULT 80,
    icon VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 5. Tabel Projects (Daftar Proyek / Karya yang Dibuat)
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

-- 6. Tabel Experiences (Pengalaman Kerja, Magang, atau Organisasi)
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

-- 8. Tabel Certificates (Sertifikasi & Penghargaan)
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

-- 9. Tabel Testimonials (Ulasan / Testimoni Klien atau Rekan Kerja)
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

-- =====================================================
-- DATA DUMMY AWAL (SEEDING DATA UNTUK PENGUJIAN)
-- =====================================================

-- Dummy Data Profile
INSERT INTO profile (name, role, bio, about, email, phone, address, github_url, linkedin_url, instagram_url) 
VALUES (
    'Ahmad Fauzi',
    'Junior Fullstack Web Developer',
    'Siswa Rekayasa Perangkat Lunak yang berfokus pada pengembangan backend Node.js dan frontend modern.',
    'Halo! Saya seorang web developer pemula dengan ketertarikan tinggi pada arsitektur web, REST API, dan UI/UX modern. Memiliki pengalaman membuat aplikasi web sekolah dan sistem informasi berbasis web.',
    'ahmad.fauzi@example.com',
    '+6281234567890',
    'Jakarta, Indonesia',
    'https://github.com/ahmadfauzi',
    'https://linkedin.com/in/ahmadfauzi',
    'https://instagram.com/ahmadfauzi'
);

-- Dummy Data Skills
INSERT INTO skills (name, category, level, icon) VALUES 
('HTML5 & CSS3', 'Frontend', 90, 'html5'),
('JavaScript (ES6+)', 'Frontend', 85, 'javascript'),
('React / Next.js', 'Frontend', 75, 'react'),
('Node.js & Express.js', 'Backend', 80, 'nodejs'),
('MySQL', 'Database', 80, 'mysql'),
('Git & GitHub', 'Tools', 85, 'git');

-- Dummy Data Projects
INSERT INTO projects (title, description, category, tech_stack, is_featured) VALUES 
(
    'Sistem Informasi Absensi Sekolah',
    'Aplikasi web untuk mencatat kehadiran siswa dan guru secara real-time dengan rekapitulasi otomatis.',
    'Web Development',
    'Express.js, Next.js, MySQL',
    TRUE
),
(
    'E-Commerce Toko Komputer',
    'Platform toko online sederhana dengan fitur katalog produk, keranjang belanja, dan invoice checkout.',
    'Web Development',
    'Laravel, MySQL, Bootstrap',
    FALSE
);

-- Dummy Data Experiences
INSERT INTO experiences (type, title, company, location, start_date, is_current, description) VALUES 
(
    'education',
    'Siswa Rekayasa Perangkat Lunak',
    'SMK Negeri 1 Kejuruan',
    'Jakarta',
    '2024-07-15',
    TRUE,
    'Mempelajari dasar pemrograman, algoritma, database relasional MySQL, dan pengembangan web fullstack.'
);

-- Dummy Data Certificates
INSERT INTO certificates (name, issuer, issue_date, expiration_date, credential_id, credential_url, description) VALUES 
(
    'Belajar Dasar Pemrograman JavaScript', 
    'Dicoding Indonesia', 
    '2024-05-10', 
    '2027-05-10', 
    'DICODING-JS-12345', 
    'https://www.dicoding.com/certificates/DICODING-JS-12345', 
    'Sertifikasi pemahaman dasar JavaScript ES6+, asynchronous programming, dan manipulasi objek.'
),
(
    'Junior Web Developer Certification', 
    'BNSP Indonesia', 
    '2024-08-20', 
    NULL, 
    'BNSP-JWD-98765', 
    'https://bnsp.go.id/verify/98765', 
    'Sertifikasi kompetensi keahlian web development berstandar SKKNI.'
);

-- Dummy Data Testimonials
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


