const express = require("express");
const router = express.Router();
const multer = require('multer');
const path = require('path');
const { uploadImage, processImage, detailMeterReading } = require("../controllers/meter");
const {VerifyToken} = require ("../utils/tokenVerify")

const storage = multer.diskStorage({
    destination: (req, file, cb) => {
      cb(null, 'uploads/'); 
    },
    filename: (req, file, cb) => {
      const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
      cb(null, file.fieldname + '-' + uniqueSuffix + path.extname(file.originalname));
    }
});

const upload = multer({ 
    storage: storage,
});

router.post("/upload", upload.single('image'), uploadImage);
router.post("/process", VerifyToken , processImage);
router.post("/readings", VerifyToken , detailMeterReading);

module.exports = router;