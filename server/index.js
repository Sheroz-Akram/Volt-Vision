const express = require('express');
const cors = require('cors');
const dbConnection = require('./utils/db')
const generateStatement = require("./utils/generate-statement")

// generateStatement(100, {
//   accountNumber: "1234567890",
//   name: "Sheroz Akram",
//   address: "Harbanspura, Lahore, Pakistan",
// }, {
//   billNumber: "1234567890",
//   billDate: "2024-01-01",
//   dueDate: "2024-01-15",
// }, {
//   basic: 0.15,
//   service: 10,
//   tax: 0.05,
// });

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
app.use("/meters", meterRoutes);