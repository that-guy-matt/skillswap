const express = require("express");
const dotenv = require("dotenv");
const path = require("path");
const bcrypt = require("bcrypt");
const bodyParser = require("body-parser");
const {PrismaClient} = require("@prisma/client");

// load environment variables from .env file
dotenv.config({ path: path.resolve(__dirname, '../.env')});

// initialize prisma and express application
const prisma = new PrismaClient();
const app = express();

// middleware to parse JSON and URL encoded data
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended: true}));

/**
 * Root endpoint
 * Currently responds only with hello world for testing
 */
app.get("/", (req, res) => {
    res.send("Hello world!");
});

/**
 * Users endpoint
 * fetches all users from database for testing purposes
 */
app.get("/users", async (req, res) => {
    try {

        const users = await prisma.user.findMany();
        res.json(users);

      } catch (err) {

        console.error("Error fetching users", err);
        res.status(500).json({ error: "Internal Server Error" });

      }
});

/**
 * User signup endpoint
 * creates a new user with hashed password
 */
app.post("/signup", async (req, res) => {

  const {email, password} = req.body;
  try {

    const hashedPassword = await bcrypt.hash(password, 10);
    const newUser = await prisma.user.create({

      data: {
        email: email,
        password: hashedPassword
      }

    });

    // console.log({ email: email, password: hashedPassword }); // for testing
    res.status(201).json(newUser);

  } catch (e) {

    console.error("Error creating user", e);
    res.status(500).json({error: "Internal server error"});

  }
  
});

/**
 * Login endpoint
 * authenticate user with email and password
 */
app.post("/login", async (req, res) => {

  const {email, password} = req.body;
  try {

    const user = await prisma.user.findUnique({
      where: { email: email }

    });

    if (!user) {

      return res.status(404).json({error: "User not found"});

    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {

      res.status(200).json({error: "Invalid credentials"});

    }

    res.status(200).json({message: "Login successful"});

  } catch (e) {

    console.error("Error logging in", e);
    res.status(500).json({error: "Internal server error"});

  }

});

// define port to listen on and start server
const port = process.env.PORT || 3000;

app.listen(port, () => {
    console.log(`server is up and listening on port ${port}`);
});