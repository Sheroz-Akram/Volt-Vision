const express = require('express');
const cors = require('cors');
const dbConnection = require('./utils/db')
const fs = require('fs');

require("dotenv").config();

const userRoutes = require("./routes/user")
const meterRoutes = require("./routes/meter")

const app = express();

//Middleware
app.set('view engine', 'pug');
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

//Connections
const PORT = "1122"
const HOST = "127.0.0.1";

dbConnection().catch((error) => console.log(error));

// Create uploads directory if it doesn't exist
if (!fs.existsSync('uploads')) {
    fs.mkdirSync('uploads');
}

app.listen(PORT, HOST, () => {
  console.log(`Server is listening on ${HOST}:${PORT}`);
});

app.get("/", (req, res) => {
  res.send("Server Working....")
})

//Routes
app.use("/users", userRoutes);
app.use("/meters", meterRoutes);