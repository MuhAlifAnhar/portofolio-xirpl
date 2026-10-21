const express = require('express');
const router = express.Router();
const testimonialController = require('../controller/testimonialController');

// 1. GET /api/testimonials - Ambil semua testimonial
router.get('/', testimonialController.getAllTestimonials);

// 2. GET /api/testimonials/:id - Ambil detail 1 testimonial berdasarkan ID
router.get('/:id', testimonialController.getTestimonialById);

// 3. POST /api/testimonials - Tambah testimonial baru
router.post('/', testimonialController.createTestimonial);

// 4. PUT /api/testimonials/:id - Update testimonial berdasarkan ID
router.put('/:id', testimonialController.updateTestimonial);

// 5. DELETE /api/testimonials/:id - Hapus testimonial berdasarkan ID
router.delete('/:id', testimonialController.deleteTestimonial);

module.exports = router;
