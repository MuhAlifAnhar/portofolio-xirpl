# 📝 LEMBAR EVALUASI & SOAL ESSAY PRAKTIKUM
## PERTEMUAN 1: SETUP ENVIRONMENT, INISIALISASI PROYEK, & STRUKTUR FOLDER
**Mata Pelajaran:** Pemrograman Web dan Perangkat Bergerak (PWPB / Backend)  
**Kelas / Jurusan:** XI / XII Rekayasa Perangkat Lunak (RPL)  
**Topik:** Setup Node.js, Express.js Backend, Next.js Frontend, & Arsitektur Direktori Proyek  

---

## 📋 DAFTAR 10 SOAL ESSAY PRAKTIKUM

### **Soal 1 (Konsep Runtime Node.js)**
Jelaskan apa fungsi **Node.js** dalam arsitektur pengembangan web modern, dan mengapa kita bisa menjalankan kode JavaScript di sisi server (*backend*) tanpa memerlukan web browser!

---

### **Soal 2 (Inisialisasi Proyek & `package.json`)**
Saat memulai proyek backend di Pertemuan 1, kita menjalankan perintah `npm init -y`. 
Jelaskan:
1. Apa fungsi dari perintah `npm init` tersebut?
2. Apa kegunaan flag `-y` pada perintah tersebut?
3. Mengapa file `package.json` disebut sebagai "identitas utama" dari sebuah proyek Node.js?

---

### **Soal 3 (Pemisahan Direktori Backend & Frontend)**
Pada proyek web portofolio ini, kita memisahkan struktur proyek menjadi dua folder terpisah, yaitu folder `backend/` dan `frontend/`. Jelaskan keuntungan arsitektur pemisahan (*Decoupled / Separation of Concerns*) ini dibandingkan dengan menggabungkan kode tampilan dan backend dalam satu folder yang sama!

---

### **Soal 4 (Struktur Folder Arsitektur Backend)**
Di dalam folder `backend/src/`, kita telah membuat 4 subfolder utama: `config`, `controller`, `models`, dan `routes`. Jelaskan fungsi spesifik dari masing-masing folder tersebut dalam pola perancangan backend!

---

### **Soal 5 (Dependencies vs DevDependencies)**
Jelaskan perbedaan mendasar antara **`dependencies`** dan **`devDependencies`** di dalam file `package.json`! Berikan contoh 1 paket untuk masing-masing kategori yang digunakan dalam proyek Express.js kita!

---

### **Soal 6 (Fungsi File `.gitignore` & `node_modules`)**
Mengapa folder `node_modules` memiliki ukuran file yang sangat besar dan **wajib** dimasukkan ke dalam file `.gitignore` agar tidak terunggah ke repositori Git/GitHub? Bagaimana cara orang lain yang mengunduh proyek kita dapat memulihkan folder `node_modules` tersebut?

---

### **Soal 7 (Peran File `package-lock.json`)**
Setelah kita menginstal paket seperti `express`, secara otomatis muncul file `package-lock.json`. Jelaskan apa perbedaan fungsi antara `package.json` dan `package-lock.json`, serta mengapa file `package-lock.json` tidak boleh dihapus!

---

### **Soal 8 (Inisialisasi Frontend Next.js)**
Pada tahap setup frontend di Pertemuan 1, kita menginisialisasi framework **Next.js**. 
Jelaskan:
1. Mengapa kita memilih Next.js sebagai framework frontend untuk mendampingi backend Express.js?
2. Apa peran Next.js dalam proyek portofolio dinamis ini?

---

### **Soal 9 (Analisis Alur Kerja Perintah Script)**
Perhatikan potongan file `package.json` berikut:
```json
"scripts": {
  "start": "node src/server.js",
  "dev": "nodemon src/server.js"
}
```
Jelaskan perbedaan fungsi dan skenario penggunaan antara perintah terminal `npm start` dan `npm run dev` saat seorang programmer sedang bekerja!

---

### **Soal 10 (Studi Kasus & Troubleshooting)**
Seorang siswa baru saja meng-clone (mengunduh) folder proyek backend temannya dari GitHub. Saat siswa tersebut menjalankan perintah `node src/server.js`, terminal menampilkan pesan error:
```text
Error: Cannot find module 'express'
Require stack:
- C:\porto\backend\src\server.js
```
Analisis penyebab terjadinya error tersebut dan tuliskan langkah-langkah konkret yang harus dilakukan siswa tersebut di terminal untuk memperbaikinya!

---

<br>

================================================================================

# 🔑 KUNCI JAWABAN & PEDOMAN PENSKORAN (UNTUK GURU)

---

### **Kunci Jawaban 1 (Bobot: 10 Poin)**
- **Jawaban:** Node.js adalah *JavaScript Runtime Environment* yang dibangun di atas mesin V8 milik Google Chrome. Fungsinya memungkinkan bahasa JavaScript dieksekusi di luar web browser (pada level sistem operasi/server).
- **Alasan bisa berjalan tanpa browser:** Karena Node.js mengemas mesin V8 dengan pustaka C++ bawaan untuk menangani operasi sistem seperti File System (I/O), Jaringan (Networking HTTP), dan manajemen memori sistem operasi.

---

### **Kunci Jawaban 2 (Bobot: 10 Poin)**
1. `npm init` berfungsi untuk menginisialisasi proyek Node.js baru dan membuat file `package.json`.
2. Flag `-y` (*yes*) berfungsi untuk otomatis menyetujui semua pertanyaan konfigurasi default tanpa harus menekan Enter berulang kali.
3. `package.json` disebut identitas utama karena mencatat seluruh metadata proyek (nama proyek, versi, author, skrip eksekusi, serta daftar pustaka/dependensi yang dibutuhkan agar aplikasi dapat berjalan).

---

### **Kunci Jawaban 3 (Bobot: 10 Poin)**
Keuntungan pemisahan folder `backend` dan `frontend`:
1. **Separation of Concerns:** Kode logika bisnis/database terisolasi dari kode tampilan visual.
2. **Fleksibilitas:** Frontend dan Backend dapat dikembangkan, di-update, atau diganti teknologinya secara independen tanpa merusak sistem lainnya.
3. **Standar Industri REST API:** Backend bertindak murni sebagai penyedia data (API JSON) yang kelak bisa dikonsumsi tidak hanya oleh web Next.js, tapi juga aplikasi mobile (Android/iOS).

---

### **Kunci Jawaban 4 (Bobot: 10 Poin)**
- **`config/`**: Menyimpan konfigurasi global aplikasi, seperti koneksi database MySQL, variabel `.env`, dan pengaturan CORS.
- **`models/`**: Mengelola struktur data dan logika query ke database (contoh: `SELECT`, `INSERT`, `UPDATE`, `DELETE`).
- **`controller/`**: Otak pengendali logika bisnis yang menerima request dari routes, memanggil model, lalu menyusun format response JSON.
- **`routes/`**: Menentukan daftar alamat URL endpoint API dan method HTTP-nya (GET, POST, PUT, DELETE) serta mengarahkannya ke controller yang tepat.

---

### **Kunci Jawaban 5 (Bobot: 10 Poin)**
- **`dependencies`**: Paket-paket utama yang wajib ada agar aplikasi backend dapat berjalan di server produksi. Contoh: `express` (web framework) atau `dotenv`.
- **`devDependencies`**: Paket-paket pembantu yang hanya digunakan selama proses pengembangan/coding oleh programmer dan tidak dibutuhkan di produksi. Contoh: `nodemon` (auto-reload server).

---

### **Kunci Jawaban 6 (Bobot: 10 Poin)**
- **Alasan diabaikan di Git:** `node_modules` berisi ribuan file dependensi beserta sub-dependensinya dengan ukuran puluhan hingga ratusan Megabyte. Mengunggahnya ke GitHub akan membebani bandwidth dan memperlambat proses upload/download repository.
- **Cara memulihkannya:** Cukup buka terminal di folder proyek yang memiliki file `package.json`, lalu jalankan perintah `npm install`. NPM akan otomatis mengunduh ulang seluruh paket sesuai daftar yang tercatat di `package.json`.

---

### **Kunci Jawaban 7 (Bobot: 10 Poin)**
- **Perbedaan:** `package.json` mencatat versi dependensi secara umum (menggunakan tanda *caret* `^` atau *tilde* `~`), sedangkan `package-lock.json` mengunci secara presisi versi eksak (*exact version*) hingga hash integritas dari setiap paket dan seluruh sub-dependensinya.
- **Alasan tidak boleh dihapus:** Agar semua pengembang dalam satu tim dan server produksi selalu menginstal versi modul yang 100% sama persis, mencegah terjadinya bug *"it works on my machine"*.

---

### **Kunci Jawaban 8 (Bobot: 10 Poin)**
1. **Alasan memilih Next.js:** Next.js adalah framework React modern yang mendukung Server-Side Rendering (SSR), performa tinggi, optimasi SEO yang unggul, sistem routing berbasis App Router yang rapi, dan mudah dihubungkan dengan Tailwind CSS.
2. **Peran Next.js:** Bertindak sebagai *Client Layer* (antarmuka pengguna) yang bertugas mengambil (*fetching*) data portofolio dari backend Express.js lalu menampilkannya menjadi halaman web yang interaktif, responsif, dan menarik.

---

### **Kunci Jawaban 9 (Bobot: 10 Poin)**
- **`npm run dev`**: Digunakan selama proses *development/ngoding*. Perintah ini menjalankan `nodemon` yang aktif memantau perubahan file kode dan otomatis me-restart server setiap kali file disimpan (`Ctrl + S`).
- **`npm start`**: Digunakan saat aplikasi sudah selesai dan siap dijalankan di server *production*. Menggunakan perintah standar `node src/server.js` yang lebih hemat sumber daya memori karena tidak menjalankan proses file-watcher.

---

### **Kunci Jawaban 10 (Bobot: 10 Poin)**
- **Penyebab:** Folder `node_modules` belum ada di komputer siswa tersebut karena folder tersebut tidak ikut di-upload ke GitHub oleh pemilik repositori.
- **Langkah Perbaikan Konkret:**
  1. Buka terminal VS Code.
  2. Pastikan posisi direktori berada di dalam folder backend:
     ```bash
     cd backend
     ```
  3. Jalankan perintah instalasi ulang seluruh paket:
     ```bash
     npm install
     ```
  4. Setelah proses selesai, jalankan kembali servernya:
     ```bash
     npm run dev
     ```

---

## 📊 RUBRIK PENILAIAN TOTAL:
- **Total Soal:** 10 Butir Soal Essay
- **Skor Maksimal Tiap Soal:** 10 Poin
- **Skor Total Maksimal:** 100 Poin
- **Predikat Kelulusan:**
  - **90 - 100:** Sangat Kompeten (A)
  - **75 - 89:** Kompeten (B)
  - **60 - 74:** Cukup Kompeten (C)
  - **< 60:** Belum Kompeten / Remedial (D)
