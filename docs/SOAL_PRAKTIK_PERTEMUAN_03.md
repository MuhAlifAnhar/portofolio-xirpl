# 📝 LEMBAR EVALUASI & SOAL ESSAY PRAKTIKUM
## PERTEMUAN 3: PERANCANGAN DATABASE MySQL & SKEMA TABEL
**Mata Pelajaran:** Pemrograman Web dan Perangkat Bergerak (PWPB / Backend)  
**Kelas / Jurusan:** XI / XII Rekayasa Perangkat Lunak (RPL)  
**Topik:** Skema RDBMS, Tipe Data MySQL, DDL (Data Definition Language) & DML Dasar  

---

## 📋 DAFTAR 10 SOAL ESSAY PRAKTIKUM

### **Soal 1 (Konsep Persistensi Data)**
Pada Pertemuan 2, kita menuliskan data respon JSON langsung ke dalam kode JavaScript (*hardcoded*). Pada Pertemuan 3, kita beralih menggunakan **Database MySQL**. Jelaskan kerugian utama menyimpan data secara *hardcoded* dan sebutkan 2 keuntungan utama menggunakan database untuk aplikasi web dinamis!

---

### **Soal 2 (Primary Key & AUTO_INCREMENT)**
Hampir seluruh tabel yang kita buat (`profile`, `skills`, `projects`, dll) memiliki satu kolom yang bernama `id` dengan aturan `INT AUTO_INCREMENT PRIMARY KEY`. 
Jelaskan apa fungsi dari atribut **PRIMARY KEY** dan bagaimana cara kerja fitur **AUTO_INCREMENT** saat ada data baru yang masuk!

---

### **Soal 3 (Pemilihan Tipe Data: VARCHAR vs TEXT)**
Dalam merancang tabel `profile`, kolom `name` menggunakan tipe data `VARCHAR(100)`, sedangkan kolom `bio` dan `about` menggunakan tipe data `TEXT`. Jelaskan perbedaan mendasar antara kedua tipe data tersebut dan mengapa pemilihan tipe data yang tepat sangat penting dalam database!

---

### **Soal 4 (Tipe Data ENUM)**
Pada tabel `skills`, terdapat pengaturan kategori menggunakan perintah: 
`category ENUM('Frontend', 'Backend', 'Database', 'Tools', 'Other') DEFAULT 'Frontend'`.
Apa yang dimaksud dengan tipe data **ENUM**, dan apa yang akan terjadi jika kita mencoba memasukkan kategori "Mobile" ke dalam tabel tersebut?

---

### **Soal 5 (Keamanan Password)**
Pada tabel `users` yang berfungsi sebagai akun admin portofolio, panjang tipe data untuk kolom `password` diset sangat panjang, yaitu `VARCHAR(255)`. Jelaskan alasan keamanan (*security*) mengapa password tidak boleh dibatasi terlalu pendek atau disimpan dalam bentuk teks biasa (*plain text*)!

---

### **Soal 6 (Pencatatan Waktu Otomatis)**
Setiap tabel yang kita buat diakhiri dengan dua kolom tambahan, yaitu:
```sql
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
```
Jelaskan fungsi dari fitur `CURRENT_TIMESTAMP` tersebut dan bagaimana kolom `updated_at` bekerja saat administrator mengubah data proyek!

---

### **Soal 7 (DDL - Data Definition Language)**
Seorang developer junior ingin membuat sebuah database baru bernama `db_sekolah` jika database tersebut belum ada, kemudian ia ingin mengaktifkan database tersebut agar tabel-tabelnya bisa diisi. Tuliskan dua baris perintah SQL yang tepat untuk mewujudkan hal tersebut!

---

### **Soal 8 (Konsep Data Seeding)**
Setelah struktur tabel portofolio selesai dibuat, langkah selanjutnya yang diajarkan pada Pertemuan 3 adalah melakukan proses *Data Seeding* (menggunakan perintah `INSERT`). Jelaskan apa yang dimaksud dengan *Data Seeding* dalam pengembangan backend dan apa manfaat utamanya saat aplikasi masih dalam tahap pengembangan!

---

### **Soal 9 (DML - UPDATE)**
Identitas siswa pada data dummy tabel `profile` saat ini masih menggunakan nama 'Ahmad Fauzi'. Tuliskan perintah SQL lengkap untuk mengubah data `name` tersebut menjadi "Nama Kamu Sendiri" dengan patokan `id = 1`!

---

### **Soal 10 (DML - SELECT dengan Kondisi)**
Kamu memiliki banyak data proyek di dalam tabel `projects`. Tuliskan satu buah perintah SQL (`SELECT`) yang akan menampilkan HANYA kolom `title` dan `tech_stack` dari tabel `projects`, tetapi dengan syarat hanya menampilkan proyek yang memiliki nilai `is_featured = TRUE`!

---

<br>

================================================================================

# 🔑 KUNCI JAWABAN & PEDOMAN PENSKORAN (UNTUK GURU)

---

### **Kunci Jawaban 1 (Bobot: 10 Poin)**
- **Kerugian Hardcoded:** Jika server dimatikan (restart), semua perubahan data akan hilang. Data juga sulit dimanipulasi atau di-update tanpa harus menyentuh/mengubah kode aslinya.
- **Keuntungan Database:** Data bersifat persisten (permanen dan tersimpan aman di harddisk), dan data sangat mudah dicari, disaring, serta diperbarui menggunakan instruksi SQL tanpa perlu mengotak-atik source code program.

---

### **Kunci Jawaban 2 (Bobot: 10 Poin)**
- **PRIMARY KEY:** Berfungsi sebagai identitas unik utama (*kunci primer*) untuk setiap baris di dalam sebuah tabel, sehingga tidak akan pernah ada 2 baris data dengan identitas (id) yang kembar.
- **AUTO_INCREMENT:** Bertugas mengisikan nilai id berupa angka secara otomatis yang terus bertambah 1 setiap kali ada penambahan baris data baru, sehingga developer tidak perlu mengisinya secara manual.

---

### **Kunci Jawaban 3 (Bobot: 10 Poin)**
- **Perbedaan:** `VARCHAR` adalah teks berdurasi pendek dengan batasan jumlah karakter yang kaku (misal 100 karakter), sedangkan `TEXT` dapat menampung jumlah teks/kalimat yang jauh lebih panjang (cocok untuk paragraf).
- **Pentingnya Pemilihan:** Untuk efisiensi ruang penyimpanan harddisk dan mempercepat performa pencarian database (query). Jika semua memakai TEXT, pencarian data akan menjadi sangat lambat.

---

### **Kunci Jawaban 4 (Bobot: 10 Poin)**
- **Definisi ENUM:** Tipe data string/teks yang nilainya dibatasi *hanya* pada daftar pilihan yang sudah ditentukan sejak awal.
- **Yang terjadi jika menginput "Mobile":** MySQL akan menolak input tersebut (mengalami *Error Data Truncated*) atau memasukkan nilai kosong, karena kata "Mobile" tidak terdaftar di dalam pilihan kategori ENUM yang diizinkan.

---

### **Kunci Jawaban 5 (Bobot: 10 Poin)**
Password di database tidak boleh disimpan secara telanjang (*plain text*), melainkan harus diacak (dihash) menggunakan algoritma seperti `bcrypt`. Hasil acakan bcrypt (*hash code*) ini umumnya memakan panjang hingga 60-100 karakter, sehingga kita wajib menyiapkan kapasitas `VARCHAR(255)` agar string kode acak tersebut muat dan tidak terpotong (yang mana akan menyebabkan admin gagal login).

---

### **Kunci Jawaban 6 (Bobot: 10 Poin)**
- **CURRENT_TIMESTAMP:** Berfungsi merekam waktu dan tanggal saat ini dari sistem komputer (server) secara otomatis.
- **Fungsi ON UPDATE:** Ketika data di baris tersebut diubah (di-update) oleh perintah SQL, maka kolom `updated_at` akan secara otomatis memperbarui dirinya dengan tanggal/jam terbaru saat perombakan data itu terjadi, tanpa perlu kita atur ulang secara manual.

---

### **Kunci Jawaban 7 (Bobot: 10 Poin)**
Perintah SQL yang benar:
```sql
CREATE DATABASE IF NOT EXISTS db_sekolah;
USE db_sekolah;
```

---

### **Kunci Jawaban 8 (Bobot: 10 Poin)**
- **Definisi:** *Data Seeding* adalah proses menyuntikkan atau memasukkan data contoh (*dummy data*) palsu ke dalam tabel database yang baru saja dibuat.
- **Manfaat:** Agar pengembang bisa langsung menguji endpoint API, mengecek bentuk JSON response-nya, dan melakukan penyesuaian desain Frontend tanpa harus menunggu tersedianya data asli.

---

### **Kunci Jawaban 9 (Bobot: 10 Poin)**
Perintah SQL yang benar:
```sql
UPDATE profile 
SET name = 'Nama Kamu Sendiri' 
WHERE id = 1;
```

---

### **Kunci Jawaban 10 (Bobot: 10 Poin)**
Perintah SQL yang benar:
```sql
SELECT title, tech_stack 
FROM projects 
WHERE is_featured = TRUE;
```

---

## 📊 RUBRIK PENILAIAN TOTAL:
- **Total Soal:** 10 Butir Soal Essay Analitis & Teknis DDL/DML
- **Skor Maksimal Tiap Soal:** 10 Poin
- **Skor Total Maksimal:** 100 Poin
- **Predikat Kelulusan SMK RPL:**
  - **90 - 100:** Sangat Kompeten (A)
  - **75 - 89:** Kompeten (B)
  - **60 - 74:** Cukup Kompeten (C)
  - **< 60:** Belum Kompeten / Remedial (D)
