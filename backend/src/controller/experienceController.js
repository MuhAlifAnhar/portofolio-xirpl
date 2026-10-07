const experienceModel = require('../models/experienceModel');

const getAllExperiences = async (req, res) => {
    try {
        const experiences = await experienceModel.getAllExperiences();
        res.status(200).json({ success: true, total: experiences.length, data: experiences });
    } catch (error) {
        res.status(500).json({ success: false, message: 'Server Error', error: error.message });
    }
};

const getExperienceById = async (req, res) => {
    try {
        const { id } = req.params;
        const experience = await experienceModel.getExperienceById(id);
        if (!experience) return res.status(404).json({ success: false, message: 'Data tidak ditemukan' });
        res.status(200).json({ success: true, data: experience });
    } catch (error) {
        res.status(500).json({ success: false, message: 'Server Error', error: error.message });
    }
};

const createExperience = async (req, res) => {
    try {
        const data = req.body;
        if (!data.title || !data.company) return res.status(400).json({ success: false, message: 'Title dan company wajib diisi' });
        const result = await experienceModel.createExperience(data);
        res.status(201).json({ success: true, message: 'Experience ditambahkan', data: { id: result.insertId } });
    } catch (error) {
        res.status(500).json({ success: false, message: 'Server Error', error: error.message });
    }
};

const updateExperience = async (req, res) => {
    try {
        const { id } = req.params;
        const data = req.body;
        if (!data.title || !data.company) return res.status(400).json({ success: false, message: 'Title dan company wajib diisi' });
        
        const result = await experienceModel.updateExperience(id, data);
        if (result.affectedRows === 0) return res.status(404).json({ success: false, message: 'Data tidak ditemukan' });
        res.status(200).json({ success: true, message: 'Experience diperbarui' });
    } catch (error) {
        res.status(500).json({ success: false, message: 'Server Error', error: error.message });
    }
};

const deleteExperience = async (req, res) => {
    try {
        const { id } = req.params;
        const result = await experienceModel.deleteExperience(id);
        if (result.affectedRows === 0) return res.status(404).json({ success: false, message: 'Data tidak ditemukan' });
        res.status(200).json({ success: true, message: 'Experience dihapus' });
    } catch (error) {
        res.status(500).json({ success: false, message: 'Server Error', error: error.message });
    }
};

module.exports = { getAllExperiences, getExperienceById, createExperience, updateExperience, deleteExperience };
