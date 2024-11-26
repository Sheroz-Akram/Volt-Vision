const express = require("express");
const router = express.Router();

// Controller, Middleware and Utils
const { uploadImage, processImage, detailMeterReading, downloadStatement, billPrediction } = require("../controllers/meter");
const { VerifyTokenPOST, VerifyTokenGET } = require("../utils/tokenVerify");
const { compressImage } = require("../utils/compressImage");
const { upload } = require("../utils/storeUpload");

// Meters Routes
router.post("/upload", [upload.single('image'), compressImage], uploadImage);
router.post("/process", VerifyTokenPOST, processImage);
router.post("/readings", VerifyTokenPOST, detailMeterReading);
router.get("/statement/:token/:billNumber", VerifyTokenGET, downloadStatement);
router.get("/prediction/:token", VerifyTokenGET, billPrediction);

module.exports = router;