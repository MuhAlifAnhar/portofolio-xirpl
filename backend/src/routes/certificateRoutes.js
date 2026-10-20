const express = require('express');
const router = express.Router();
const certificateController = require('../controller/certificateController');

// 1. GET /api/certificates - Ambil semua data sertifikat
router.get('/', certificateController.getAllCertificates);

// 2. GET /api/certificates/:id - Ambil 1 sertifikat berdasarkan ID
router.get('/:id', certificateController.getCertificateById);

// 3. POST /api/certificates - Tambah data sertifikat baru
router.post('/', certificateController.createCertificate);

// 4. PUT /api/certificates/:id - Update data sertifikat berdasarkan ID
router.put('/:id', certificateController.updateCertificate);

// 5. DELETE /api/certificates/:id - Hapus data sertifikat berdasarkan ID
router.delete('/:id', certificateController.deleteCertificate);

module.exports = router;
