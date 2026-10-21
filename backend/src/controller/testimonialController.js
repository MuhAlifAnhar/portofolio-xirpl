const testimonialModel = require('../models/testimonialModel');

// 1. GET ALL TESTIMONIALS
const getAllTestimonials = async (req, res) => {
    try {
        const testimonials = await testimonialModel.getAllTestimonials();
        res.status(200).json({
            success: true,
            total: testimonials.length,
            data: testimonials
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: 'Server Error',
            error: error.message
        });
    }
};

// 2. GET TESTIMONIAL BY ID
const getTestimonialById = async (req, res) => {
    try {
        const { id } = req.params;
        const testimonial = await testimonialModel.getTestimonialById(id);

        if (!testimonial) {
            return res.status(404).json({
                success: false,
                message: 'Data testimoni tidak ditemukan'
            });
        }

        res.status(200).json({
            success: true,
            data: testimonial
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: 'Server Error',
            error: error.message
        });
    }
};

// 3. CREATE TESTIMONIAL
const createTestimonial = async (req, res) => {
    try {
        const data = req.body;

        // Validasi input wajib: nama, jabatan/role, dan pesan testimoni
        if (!data.name || !data.role || !data.message) {
            return res.status(400).json({
                success: false,
                message: 'Nama (name), peran/jabatan (role), dan pesan (message) wajib diisi'
            });
        }

        const result = await testimonialModel.createTestimonial(data);
        res.status(201).json({
            success: true,
            message: 'Testimoni berhasil ditambahkan',
            data: { id: result.insertId }
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: 'Server Error',
            error: error.message
        });
    }
};

// 4. UPDATE TESTIMONIAL
const updateTestimonial = async (req, res) => {
    try {
        const { id } = req.params;
        const data = req.body;

        // Validasi input wajib
        if (!data.name || !data.role || !data.message) {
            return res.status(400).json({
                success: false,
                message: 'Nama (name), peran/jabatan (role), dan pesan (message) wajib diisi'
            });
        }

        const result = await testimonialModel.updateTestimonial(id, data);

        if (result.affectedRows === 0) {
            return res.status(404).json({
                success: false,
                message: 'Data testimoni tidak ditemukan'
            });
        }

        res.status(200).json({
            success: true,
            message: 'Testimoni berhasil diperbarui'
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: 'Server Error',
            error: error.message
        });
    }
};

// 5. DELETE TESTIMONIAL
const deleteTestimonial = async (req, res) => {
    try {
        const { id } = req.params;
        const result = await testimonialModel.deleteTestimonial(id);

        if (result.affectedRows === 0) {
            return res.status(404).json({
                success: false,
                message: 'Data testimoni tidak ditemukan'
            });
        }

        res.status(200).json({
            success: true,
            message: 'Testimoni berhasil dihapus'
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: 'Server Error',
            error: error.message
        });
    }
};

module.exports = {
    getAllTestimonials,
    getTestimonialById,
    createTestimonial,
    updateTestimonial,
    deleteTestimonial
};
