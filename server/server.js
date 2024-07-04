const express = require("express");
const dotenv = require("dotenv");
const path = require("path");
const {PrismaClient} = require("@prisma/client");

dotenv.config({ path: path.resolve(__dirname, '../.env')});

const prisma = new PrismaClient();
const app = express();


app.get("/", (req, res) => {
    res.send("Hello world!");
});

app.get("/users", async (req, res) => {
    try {
        const users = await prisma.user.findMany();
        res.json(users);
      } catch (err) {
        console.error("Error fetching users", err);
        res.status(500).json({ error: "Internal Server Error" });
      }
});

const port = process.env.PORT || 3000;

app.listen(port, () => {
    console.log(`server is up and listening on port ${port}`);
});