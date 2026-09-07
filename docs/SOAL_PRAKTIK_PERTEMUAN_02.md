# 📝 LEMBAR EVALUASI & SOAL ESSAY PRAKTIKUM
## PERTEMUAN 2: WEB SERVER EXPRESS.JS, ROUTING DASAR & JSON RESPONSE
**Mata Pelajaran:** Pemrograman Web dan Perangkat Bergerak (PWPB / Backend)  
**Kelas / Jurusan:** XI / XII Rekayasa Perangkat Lunak (RPL)  
**Topik:** Pembuatan Server Lokal, Konfigurasi `.env`, Middleware, dan Routing Express.js  

---

## 📋 DAFTAR 10 SOAL ESSAY PRAKTIKUM

### **Soal 1 (Konsep Framework Express.js)**
Express.js dikenal sebagai framework backend yang "minimalis dan fleksibel". Jelaskan mengapa developer Node.js lebih memilih menggunakan Express.js dibandingkan menulis kode web server menggunakan modul bawaan (native `http`) Node.js!

---

### **Soal 2 (Konfigurasi `.env` & `dotenv`)**
Pada kode `server.js`, kita menulis perintah `dotenv.config()` dan menyimpan nilai `PORT=5000` di dalam file `.env`. 
1. Apa kegunaan utama dari file `.env`?
2. Mengapa informasi penting seperti PORT atau password database tidak disarankan ditulis langsung (di-hardcode) ke dalam file `server.js`?

---

### **Soal 3 (Pemahaman Parameter `req` dan `res`)**
Perhatikan struktur dasar routing berikut: 
`app.get('/', (req, res) => { ... })`
Jelaskan secara rinci apa kepanjangan dan peran dari objek **`req`** dan objek **`res`** dalam siklus komunikasi web server tersebut!

---

### **Soal 4 (Status Code HTTP)**
Dalam memberikan respon, kita sering menyisipkan perintah seperti `res.status(200)` atau `res.status(404)`. Jelaskan makna dari **Status Code 200** dan **Status Code 404**, serta berikan contoh kapan server harus mengembalikan status 404!

---

### **Soal 5 (Format Data JSON)**
Kita menggunakan format JSON saat mengirimkan respon ke klien, contohnya: `res.json({ success: true, message: "Halo" })`. Mengapa JSON (JavaScript Object Notation) saat ini menjadi format standar komunikasi data antar aplikasi modern, mengalahkan format lain seperti HTML mentah atau XML?

---

### **Soal 6 (Middleware `cors`)**
Di baris awal kode, kita menambahkan instruksi `app.use(cors())`. Jelaskan apa itu masalah CORS (Cross-Origin Resource Sharing) dan mengapa middleware ini sangat wajib dipasang jika backend kita kelak akan diakses oleh frontend (seperti React/Next.js) yang berjalan di port atau domain yang berbeda!

---

### **Soal 7 (Middleware Pengurai Body / Body-Parser)**
Sebelum menerima request, kita mendaftarkan `app.use(express.json())`. Jelaskan skenario atau kondisi di mana middleware ini bekerja dan apa yang akan terjadi jika kita lupa menambahkan baris ini namun klien mengirimkan data pendaftaran pengguna dalam bentuk JSON!

---

### **Soal 8 (Urutan Middleware 404 Not Found)**
Untuk menangani rute alamat URL yang tidak ada (Error 404), kita menempatkan middleware `app.use((req, res) => { ... })` di baris **paling bawah**, tepat sebelum `app.listen()`. Mengapa blok kode penanganan Error 404 ini harus diletakkan di akhir kode, dan bukan di paling atas?

---

### **Soal 9 (Perintah `app.listen`)**
Di akhir file `server.js`, kita memanggil fungsi `app.listen(PORT, () => { ... })`. Jelaskan apa tugas utama dari fungsi `listen()` ini bagi sistem operasi komputer server!

---

### **Soal 10 (Pengujian API via Tools)**
Di lab praktik, guru menyarankan pengujian endpoint menggunakan aplikasi seperti **Postman** atau ekstensi **Thunder Client**, bukan sekadar membuka alamat `http://localhost:5000/` di web browser biasa (Chrome/Edge). Jelaskan 2 keuntungan utama melakukan testing API menggunakan alat khusus seperti Postman dibandingkan web browser biasa!

---

<br>

================================================================================

# 🔑 KUNCI JAWABAN & PEDOMAN PENSKORAN (UNTUK GURU)

---

### **Kunci Jawaban 1 (Bobot: 10 Poin)**
Express.js lebih disukai karena menyediakan berbagai fitur siap pakai (*built-in*) yang memudahkan pembuatan rute (routing), penanganan format JSON, dan penerapan middleware. Jika memakai modul native `http` Node.js, developer harus menulis kode yang sangat panjang dan manual hanya untuk merespon teks sederhana, sehingga Express.js menghemat waktu dan menjadikan kode lebih rapi.

---

### **Kunci Jawaban 2 (Bobot: 10 Poin)**
1. **Kegunaan `.env`**: Tempat menyimpan variabel konfigurasi lingkungan (Environment Variables) rahasia yang bisa berubah-ubah tergantung di mana aplikasi berjalan (lokal vs server produksi).
2. **Alasan tidak di-hardcode**: Untuk menghindari kebocoran data sensitif (seperti password database) saat source code diunggah ke repositori publik seperti GitHub, serta agar konfigurasi server mudah diganti tanpa perlu mengedit isi kode program.

---

### **Kunci Jawaban 3 (Bobot: 10 Poin)**
- **`req` (Request)**: Objek yang memuat semua informasi PERMINTAAN yang dikirim oleh klien (browser/Postman) kepada server. Termasuk URL yang diketik, header, method, dan isi data (body).
- **`res` (Response)**: Objek yang digunakan oleh server untuk merakit dan mengirimkan BALASAN kembali kepada klien, yang meliputi penetapan status code dan isi data balasan (biasanya format JSON).

---

### **Kunci Jawaban 4 (Bobot: 10 Poin)**
- **200 (OK)**: Menandakan bahwa permintaan klien berhasil diterima, dipahami, dan berhasil diproses oleh server tanpa masalah.
- **404 (Not Found)**: Menandakan bahwa sumber daya / alamat URL yang dicari oleh klien tidak ditemukan di server. Contoh: Klien mengetik `http://localhost:5000/halaman-asal-asalan` yang route-nya belum pernah didaftarkan oleh programmer.

---

### **Kunci Jawaban 5 (Bobot: 10 Poin)**
JSON (JavaScript Object Notation) menjadi standar karena format teksnya sangat ringan, sangat mudah dibaca oleh manusia, dan bisa langsung dipahami (di-parsing) oleh hampir semua bahasa pemrograman modern secara instan (terutama JavaScript di Frontend). Berbeda dengan HTML yang hanya menampilkan visual, JSON fokus mengirimkan **data mentah** yang terstruktur dengan key-value.

---

### **Kunci Jawaban 6 (Bobot: 10 Poin)**
Browser memiliki sistem keamanan dasar bernama *Same-Origin Policy* yang secara default memblokir aplikasi Frontend (misal jalan di `localhost:3000`) yang mencoba menarik data dari Backend yang berjalan di alamat berbeda (`localhost:5000`). Middleware `cors()` memberitahu browser bahwa backend kita mengizinkan aplikasi dari luar (*cross-origin*) untuk meminta dan mengambil data dengan aman.

---

### **Kunci Jawaban 7 (Bobot: 10 Poin)**
Middleware `express.json()` bekerja ketika klien mengirim sebuah request (seperti `POST` atau `PUT`) dengan membawa beban data (*payload*) berformat JSON. Jika middleware ini lupa dipasang, maka aplikasi Node.js tidak akan mengerti data yang dikirimkan, sehingga objek `req.body` akan bernilai `undefined` atau kosong, dan menyebabkan error pendaftaran data gagal.

---

### **Kunci Jawaban 8 (Bobot: 10 Poin)**
Express.js membaca file kode dan rute dari atas ke bawah secara berurutan (*sequential*). Jika request URL tidak cocok dengan satupun daftar rute di atasnya, permintaan akan jatuh ke baris yang paling bawah. Oleh karena itu, *fallback* middleware 404 harus ditempatkan paling akhir sebagai "jaring penangkap" semua rute sisa yang tak dikenal. Jika ditaruh di paling atas, semua rute sah di bawahnya akan terblokir dan divonis 404.

---

### **Kunci Jawaban 9 (Bobot: 10 Poin)**
Fungsi `app.listen(PORT)` menugaskan Node.js untuk "mengikat" aplikasi ke saluran nomor port komunikasi tertentu di dalam sistem operasi (misalnya Port 5000). Dengan perintah ini, server akan hidup terus-menerus dan siap "mendengarkan" setiap koneksi atau lalu lintas data HTTP masuk yang mengetuk saluran port tersebut.

---

### **Kunci Jawaban 10 (Bobot: 10 Poin)**
1. **Mendukung Segala HTTP Method**: Browser biasa (tanpa form HTML) umumnya hanya bisa melakukan uji coba request `GET`. Alat seperti Postman memungkinkan kita menguji method `POST`, `PUT`, `PATCH`, dan `DELETE` dengan mudah.
2. **Kustomisasi Request Body & Header**: Dengan Postman, developer dapat dengan mudah merakit dan mengirimkan simulasi data pendaftaran berformat JSON (*Body Request*), serta menyisipkan token otorisasi ke dalam Header, hal yang mustahil dilakukan di bar pengetikan alamat browser biasa.

---

## 📊 RUBRIK PENILAIAN TOTAL:
- **Total Soal:** 10 Butir Soal Essay Analitis & Teknis
- **Skor Maksimal Tiap Soal:** 10 Poin
- **Skor Total Maksimal:** 100 Poin
- **Predikat Kelulusan SMK RPL:**
  - **90 - 100:** Sangat Kompeten (A)
  - **75 - 89:** Kompeten (B)
  - **60 - 74:** Cukup Kompeten (C)
  - **< 60:** Belum Kompeten / Remedial (D)
