const db = require('../config/db');

// GET ALL
const getAllExperiences = async () => {
    const [rows] = await db.query('SELECT * FROM experiences ORDER BY start_date DESC');
    return rows;
};

// GET BY ID
const getExperienceById = async (id) => {
    const [rows] = await db.query('SELECT * FROM experiences WHERE id = ?', [id]);
    return rows[0];
};

// CREATE
const createExperience = async (data) => {
    const { type, title, company, location, start_date, end_date, is_current, description } = data;
    const [result] = await db.query(
        'INSERT INTO experiences (type, title, company, location, start_date, end_date, is_current, description) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
        [type, title, company, location, start_date, end_date, is_current || false, description]
    );
    return result;
};

// UPDATE
const updateExperience = async (id, data) => {
    const { title, company, location, start_date, end_date, is_current, description } = data;
    const [result] = await db.query(
        'UPDATE experiences SET title = ?, company = ?, location = ?, start_date = ?, end_date = ?, is_current = ?, description = ? WHERE id = ?',
        [title, company, location, start_date, end_date, is_current, description, id]
    );
    return result;
};

// DELETE
const deleteExperience = async (id) => {
    const [result] = await db.query('DELETE FROM experiences WHERE id = ?', [id]);
    return result;
};

module.exports = { getAllExperiences, getExperienceById, createExperience, updateExperience, deleteExperience };
