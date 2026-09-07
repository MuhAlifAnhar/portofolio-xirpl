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
