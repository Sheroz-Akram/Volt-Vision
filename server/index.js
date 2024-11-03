const express = require('express');
const cors = require('cors');
const dbConnection = require('./utils/db'); 

require("dotenv").config();

const userRoutes= require("./routes/user")

const app = express();

//Middleware
app.use(cors());
app.use(express.json());

//Connections
const PORT = process.env.PORT || 3000;
const HOST = process.env.HOST || "0.0.0.0";

dbConnection().catch((error) => console.log(error));

app.listen(PORT, HOST, () => {
  console.log(`Server is listening on ${HOST}:${PORT}`);
});

app.get("/", (req, res) => {
  res.send("Server Working....")
})

//Routes
app.use("/users", userRoutes);