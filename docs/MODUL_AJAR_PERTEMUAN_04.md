# 📄 MODUL AJAR & LEMBAR KERJA PRAKTIKUM (LKS)
## PEMROGRAMAN WEB DAN PERANGKAT BERGERAK (BACKEND)
**Proyek:** Pembuatan Web Portofolio Dinamis  
**Stack Teknologi:** Express.js, MySQL, Next.js  
**Tingkat / Fase:** SMK Kelas XI / XII - Rekayasa Perangkat Lunak (Fase F)  
**Pertemuan:** 4 dari 12 Pertemuan  
**Alokasi Waktu:** 4 Jam Pelajaran (4 x 45 Menit)  
**Materi Pokok:** Koneksi Database MySQL (Pool Connection), Arsitektur MVC, & Helper Database

---

## 🎯 BAGIAN I: IDENTITAS & TUJUAN PEMBELAJARAN

### A. Tujuan Pembelajaran Khusus (TP)
1. Siswa memahami konsep Arsitektur MVC (Model-View-Controller) dalam pengembangan Backend API.
2. Siswa mampu menginstal paket `mysql2` untuk menghubungkan aplikasi Node.js dengan database MySQL.
3. Siswa dapat memperbarui konfigurasi `.env` dengan kredensial database.
4. Siswa mampu membuat konfigurasi koneksi menggunakan metode *Connection Pool* untuk kinerja yang lebih efisien.
5. Siswa dapat memverifikasi bahwa server backend telah berhasil terhubung dengan database `db_portofolio`.

---

## 🗺️ BAGIAN II: POSISI PERTEMUAN DALAM SILABUS

| Pertemuan | Status | Materi Pokok | Target Output |
| :---: | :---: | :--- | :--- |
| **03** | Selesai | Perancangan Database MySQL & Skema Tabel | Database & Tabel Terbentuk |
| **04** | **Hari Ini** | **Koneksi Database Pool (`mysql2`) & Pola MVC** | **Backend Terhubung Database** |
| **05** | Berikutnya| CRUD Modul Profil Diri (*About Me*) | API Profil Lengkap |

---

## 📚 BAGIAN III: LANDASAN TEORI SINGKAT

### 1. Apa itu Arsitektur MVC?
MVC (*Model-View-Controller*) adalah pola desain arsitektur perangkat lunak yang memisahkan aplikasi menjadi tiga komponen utama:
*   **Model**: Bertanggung jawab mengelola data dan interaksi dengan database (query SQL seperti SELECT, INSERT, dll).
*   **View**: Bertanggung jawab atas tampilan antarmuka pengguna (UI). Dalam proyek kita, *View* akan ditangani oleh *Frontend Next.js* nantinya.
*   **Controller**: Bertindak sebagai "otak" atau jembatan. Menerima *Request* dari pengguna, meminta data dari *Model*, lalu mengembalikan *Response* dalam bentuk JSON.

### 2. Apa itu `mysql2`?
`mysql2` adalah pustaka (library) untuk Node.js yang berfungsi sebagai *driver* untuk berkomunikasi dengan server MySQL. Pustaka ini lebih cepat dan mendukung fitur modern seperti *Promises* (sehingga kita bisa menggunakan `async/await` alih-alih *callback* yang rumit).

### 3. Connection Pool vs Koneksi Biasa
*   **Koneksi Biasa**: Membuka koneksi baru setiap kali ada pengguna yang meminta data, lalu menutupnya setelah selesai. Ini lambat dan membebani server jika banyak pengunjung.
*   **Connection Pool**: Menyediakan sekumpulan koneksi (misal 10 koneksi) yang selalu siap sedia (*standby*). Jika ada permintaan, server meminjamkan koneksi yang kosong, dan mengembalikannya ke *pool* setelah selesai. Sangat efisien!

---

## 🛠️ BAGIAN IV: LANGKAH KERJA PRAKTIKUM (STEP-BY-STEP)

---

### **Langkah 1: Instalasi Paket `mysql2`**
Buka terminal VS Code Anda, pastikan berada di folder `backend`, lalu jalankan perintah instalasi:

```bash
npm install mysql2
```
> 💡 **Penjelasan:**
> Perintah ini akan mengunduh paket `mysql2` ke dalam folder `node_modules` agar aplikasi Express kita mengerti cara "berbicara" dengan database MySQL.

---

### **Langkah 2: Menambahkan Kredensial Database ke File `.env`**
Buka file `backend/src/.env` (atau `backend/.env` sesuai lokasi file Anda) lalu tambahkan informasi database di bagian bawahnya:

```env
# Konfigurasi Server
PORT=5000
NODE_ENV=development

# Konfigurasi Database MySQL
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=
DB_NAME=db_portofolio
```
> 💡 **Penjelasan:**
> *   `DB_HOST`: Alamat server database (karena di komputer sendiri, nilainya `localhost`).
> *   `DB_USER`: Username default XAMPP/MySQL adalah `root`.
> *   `DB_PASSWORD`: Kosongkan jika MySQL bawaan XAMPP Anda tidak dipasangi password. Jika ada, isi sesuai passwordnya.
> *   `DB_NAME`: Nama database yang kita buat di Pertemuan 3.

---

### **Langkah 3: Membuat File Konfigurasi Database (`db.js`)**
Buat file baru bernama `db.js` di dalam folder `backend/src/config/`.

Tuliskan kode berikut:

```javascript
// 1. Import library mysql2 dan dotenv
const mysql = require('mysql2');
require('dotenv').config();

// 2. Membuat connection pool
const pool = mysql.createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    waitForConnections: true,
    connectionLimit: 10, // Maksimal 10 koneksi bersamaan
    queueLimit: 0
});

// 3. Menggunakan promise wrapper (untuk async/await)
const db = pool.promise();

// 4. Mengetes koneksi ke database saat file ini dipanggil
pool.getConnection((err, connection) => {
    if (err) {
        console.error('❌ Kesalahan Koneksi Database:', err.message);
    } else {
        console.log('✅ Berhasil terhubung ke Database MySQL (db_portofolio)');
        connection.release(); // Mengembalikan koneksi ke dalam pool
    }
});

// 5. Export module agar bisa digunakan di file lain (seperti Controller / Model)
module.exports = db;
```
> 💡 **Penjelasan Baris Penting:**
> *   `mysql.createPool(...)`: Membuat kolam koneksi dengan maksimal 10 antrian (`connectionLimit: 10`).
> *   `pool.promise()`: Mengubah mode query menjadi *Promise*, sehingga penulisan kode di pertemuan selanjutnya menjadi jauh lebih rapi menggunakan blok `try...catch` dan `async/await`.
> *   `pool.getConnection(...)`: Baris ini sekadar mengetes (memancing) koneksi saat file dibaca. Jika sukses, terminal akan menampilkan pesan "✅ Berhasil".

---

### **Langkah 4: Memanggil Koneksi Database di File Utama Server**
Agar pesan sukses atau gagalnya koneksi langsung terlihat saat kita menyalakan server, panggil file `db.js` tadi di dalam file `server.js`.

Buka file `backend/src/server.js`, dan tambahkan baris `const db = require('./config/db');` tepat di bawah pemuatan `.env`:

```javascript
// 2. Load file konfigurasi .env
dotenv.config();

// Tambahkan baris ini untuk meload/mengetes koneksi database!
const db = require('./config/db');

// 3. Inisialisasi aplikasi Express
const app = express();
// ... baris kode lainnya ke bawah ...
```

---

### **Langkah 5: Pengujian (Verifikasi Koneksi)**
Pastikan **XAMPP / MySQL Service** Anda dalam keadaan hidup (*Start*).

Lalu, jalankan server pengembangan di terminal:
```bash
npm run dev
```

**Output Terminal yang Diharapkan:**
```text
[nodemon] starting `node src/server.js`
✅ Berhasil terhubung ke Database MySQL (db_portofolio)
========================================
🚀 Server berjalan di: http://localhost:5000
📡 Environment: development
========================================
```
*Jika pesan `✅ Berhasil` muncul, selamat! Backend Node.js Anda sudah tersambung dengan mulus ke Database MySQL!*

---

## 📝 BAGIAN V: LEMBAR KERJA SISWA (LKS) & TUGAS MANDIRI

**Nama Siswa:** ___________________________  
**Kelas / No. Presensi:** ___________________________  

### Instruksi Tugas Mandiri & Eksperimen:
1. **Eksperimen Error Koneksi (Troubleshooting):**
   *   Matikan (*Stop*) service MySQL di aplikasi XAMPP Anda.
   *   Lihat apa pesan error yang muncul di terminal VS Code!
   *   Tuliskan pesan error tersebut di bawah ini, lalu jelaskan mengapa error itu terjadi!
   *   *Jawaban/Pesan Error:* ..............................................................
2. **Eksperimen Salah Password:**
   *   Nyalakan kembali MySQL di XAMPP.
   *   Ubah file `.env` bagian `DB_PASSWORD=12345` (padahal password aslinya kosong).
   *   Simpan, lalu perhatikan pesan error di terminal. Tuliskan pesan error-nya!
   *   *Jawaban/Pesan Error:* ..............................................................
   *   *(Jangan lupa mengosongkan kembali passwordnya setelah selesai bereksperimen).*

---

## 📊 BAGIAN VI: RUBRIK PENILAIAN PRAKTIKUM

| No | Aspek Penilaian | Kriteria Evaluasi | Skor Maks | Skor Perolehan |
| :---: | :--- | :--- | :---: | :---: |
| 1 | **Instalasi Paket** | Berhasil menginstal `mysql2` | 20 | |
| 2 | **Konfigurasi `.env`** | Kredensial DB_HOST, USER, NAME ditulis dengan tepat | 20 | |
| 3 | **Pembuatan `db.js`** | Menerapkan `createPool` dan `promise()` dengan benar | 30 | |
| 4 | **Uji Coba Koneksi** | Menampilkan log sukses ✅ di terminal tanpa error | 10 | |
| 5 | **Tugas Eksperimen** | Menyelesaikan LKS skenario error MySQL & salah kredensial | 20 | |
| **TOTAL SKOR** | | | **100** | |
