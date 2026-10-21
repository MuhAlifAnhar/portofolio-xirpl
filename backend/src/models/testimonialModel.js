const db = require('../config/db');

// 1. GET ALL - Mengambil semua testimonial (diurutkan dari yang terbaru)
const getAllTestimonials = async () => {
    const [rows] = await db.query('SELECT * FROM testimonials ORDER BY created_at DESC');
    return rows;
};

// 2. GET BY ID - Mengambil 1 testimonial berdasarkan ID
const getTestimonialById = async (id) => {
    const [rows] = await db.query('SELECT * FROM testimonials WHERE id = ?', [id]);
    return rows[0];
};

// 3. CREATE - Menambahkan testimoni baru ke database
const createTestimonial = async (data) => {
    const { name, role, company, message, avatar_url, rating } = data;
    const [result] = await db.query(
        'INSERT INTO testimonials (name, role, company, message, avatar_url, rating) VALUES (?, ?, ?, ?, ?, ?)',
        [name, role, company || null, message, avatar_url || null, rating || 5]
    );
    return result;
};

// 4. UPDATE - Memperbarui data testimonial berdasarkan ID
const updateTestimonial = async (id, data) => {
    const { name, role, company, message, avatar_url, rating } = data;
    const [result] = await db.query(
        'UPDATE testimonials SET name = ?, role = ?, company = ?, message = ?, avatar_url = ?, rating = ? WHERE id = ?',
        [name, role, company || null, message, avatar_url || null, rating || 5, id]
    );
    return result;
};

// 5. DELETE - Menghapus testimonial berdasarkan ID
const deleteTestimonial = async (id) => {
    const [result] = await db.query('DELETE FROM testimonials WHERE id = ?', [id]);
    return result;
};

module.exports = {
    getAllTestimonials,
    getTestimonialById,
    createTestimonial,
    updateTestimonial,
    deleteTestimonial
};
