const certificateModel = require('../models/certificateModel');

// 1. GET ALL CERTIFICATES
const getAllCertificates = async (req, res) => {
    try {
        const certificates = await certificateModel.getAllCertificates();
        res.status(200).json({
            success: true,
            total: certificates.length,
            data: certificates
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: 'Server Error',
            error: error.message
        });
    }
};

// 2. GET CERTIFICATE BY ID
const getCertificateById = async (req, res) => {
    try {
        const { id } = req.params;
        const certificate = await certificateModel.getCertificateById(id);

        if (!certificate) {
            return res.status(404).json({
                success: false,
                message: 'Data sertifikat tidak ditemukan'
            });
        }

        res.status(200).json({
            success: true,
            data: certificate
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: 'Server Error',
            error: error.message
        });
    }
};

// 3. CREATE CERTIFICATE
const createCertificate = async (req, res) => {
    try {
        const data = req.body;

        // Validasi input wajib
        if (!data.name || !data.issuer || !data.issue_date) {
            return res.status(400).json({
                success: false,
                message: 'Nama sertifikat (name), penerbit (issuer), dan tanggal terbit (issue_date) wajib diisi'
            });
        }

        const result = await certificateModel.createCertificate(data);
        res.status(201).json({
            success: true,
            message: 'Sertifikat berhasil ditambahkan',
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

// 4. UPDATE CERTIFICATE
const updateCertificate = async (req, res) => {
    try {
        const { id } = req.params;
        const data = req.body;

        // Validasi input wajib
        if (!data.name || !data.issuer || !data.issue_date) {
            return res.status(400).json({
                success: false,
                message: 'Nama sertifikat (name), penerbit (issuer), dan tanggal terbit (issue_date) wajib diisi'
            });
        }

        const result = await certificateModel.updateCertificate(id, data);

        if (result.affectedRows === 0) {
            return res.status(404).json({
                success: false,
                message: 'Data sertifikat tidak ditemukan'
            });
        }

        res.status(200).json({
            success: true,
            message: 'Sertifikat berhasil diperbarui'
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: 'Server Error',
            error: error.message
        });
    }
};

// 5. DELETE CERTIFICATE
const deleteCertificate = async (req, res) => {
    try {
        const { id } = req.params;
        const result = await certificateModel.deleteCertificate(id);

        if (result.affectedRows === 0) {
            return res.status(404).json({
                success: false,
                message: 'Data sertifikat tidak ditemukan'
            });
        }

        res.status(200).json({
            success: true,
            message: 'Sertifikat berhasil dihapus'
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
    getAllCertificates,
    getCertificateById,
    createCertificate,
    updateCertificate,
    deleteCertificate
};
