const sharp = require('sharp');
const path = require('path');

const compressImage = async (req, res, next) => {
    if (!req.file) {
        return res
            .status(200)
            .send({ message: "File Not Found.", success: false });
    };
    try {
        const dir = path.dirname(req.file.path);
        const ext = path.extname(req.file.path);
        const filename = path.basename(req.file.path, ext);
        const compressedPath = path.join(dir, `${filename}-compressed${ext}`);
        const compressedImage = await sharp(req.file.path)
            .rotate()
            .jpeg({ quality: 80 })
            .resize(1024, 1024, {
                fit: 'inside',
                withoutEnlargement: true
            })
            .toBuffer();
        await sharp(compressedImage).toFile(compressedPath);
        req.compressedFilePath = compressedPath;
        next();
    } catch (error) {
        console.log(error);
        return res
            .status(200)
            .send({ message: "Error Compressing Image.", success: false });
    }
};

module.exports = { compressImage };