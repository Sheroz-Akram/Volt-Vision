let axios = require('axios');
let fs = require('fs');
require("dotenv").config();

async function roboflowInference(imagePath, confidence = 40, overlap = 30) {
    try {
        const image = fs.readFileSync(imagePath, {
            encoding: "base64"
        });

        const response = await axios({
            method: "POST",
            url: `https://detect.roboflow.com/${process.env.ROBOFLOW_MODEL_ID}`,
            params: {
                api_key: process.env.ROBOFLOW_API_KEY,
                confidence: confidence,
                overlap: overlap
            },
            data: image,
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            }
        });
        const predictions = response.data.predictions;
        
        // Sort predictions by x value and extract only class values as numbers
        const sortedClasses = predictions
            .sort((a, b) => a.x - b.x)
            .map(p => {
                const num = Number(p.class);
                if (isNaN(num)) {
                    return null;
                }
                return num;
            })
            .filter(num => num !== null);

        return sortedClasses;
    } catch (error) {
        if (error.code === 'ENOENT') {
            throw new Error("Image file not found");
        }
        if (error.response) {
            throw new Error(`Roboflow API Error: ${error.response.data}`);
        }
        throw new Error(`Error in Roboflow Inference: ${error.message}`);
    }
}

module.exports = {
    roboflowInference
}
