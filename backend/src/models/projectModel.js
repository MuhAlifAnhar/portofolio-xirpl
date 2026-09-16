const db = require('../config/db');

// =============================================
// FUNGSI 1: Mengambil SEMUA data proyek
// =============================================
const getAllProjects = async () => {
    const [rows] = await db.query('SELECT * FROM projects ORDER BY created_at DESC');
    return rows;
};

// =============================================
// FUNGSI 2: Mengambil SATU proyek berdasarkan ID
// =============================================
const getProjectById = async (id) => {
    const [rows] = await db.query('SELECT * FROM projects WHERE id = ?', [id]);
    return rows[0];
};

// =============================================
// FUNGSI 3: Menambahkan proyek baru (CREATE)
// =============================================
const createProject = async (data) => {
    const { title, description, category, image_url, demo_url, github_url, tech_stack, is_featured } = data;

    const [result] = await db.query(
        `INSERT INTO projects (title, description, category, image_url, demo_url, github_url, tech_stack, is_featured)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
        [title, description, category, image_url, demo_url, github_url, tech_stack, is_featured || false]
    );
    return result;
};

// =============================================
// FUNGSI 4: Memperbarui data proyek (UPDATE)
// =============================================
const updateProject = async (id, data) => {
    const { title, description, category, image_url, demo_url, github_url, tech_stack, is_featured } = data;

    const [result] = await db.query(
        `UPDATE projects SET 
            title = ?, description = ?, category = ?, 
            image_url = ?, demo_url = ?, github_url = ?, 
            tech_stack = ?, is_featured = ?
        WHERE id = ?`,
        [title, description, category, image_url, demo_url, github_url, tech_stack, is_featured, id]
    );
    return result;
};

// =============================================
// FUNGSI 5: Menghapus proyek (DELETE)
// =============================================
const deleteProject = async (id) => {
    const [result] = await db.query('DELETE FROM projects WHERE id = ?', [id]);
    return result;
};

module.exports = {
    getAllProjects,
    getProjectById,
    createProject,
    updateProject,
    deleteProject
};
