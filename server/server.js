const express = require("express");
const dotenv = require("dotenv");
const path = require("path");
const bcrypt = require("bcrypt");
const bodyParser = require("body-parser");
const cors = require("cors");
const {PrismaClient} = require("@prisma/client");
const jwt = require("jsonwebtoken");

// load environment variables from .env file
dotenv.config({ path: path.resolve(__dirname, '../.env')});

// initialize prisma and express application
const prisma = new PrismaClient();
const app = express();

// middleware to parse JSON and URL encoded data
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended: true}));

// middleware to server static files
app.use(express.static(path.join(__dirname, "../client/public")));
app.use('/src', express.static(path.join(__dirname, "../client/src")))

// CORS config
app.use(cors({
  origin: process.env.FRONTEND_URL,
  methods: 'GET, POST, PUT, DELETE',
  credentials: true
}));
/**
 * Root endpoint
 * Currently responds only with hello world for testing
 */
app.get("/", (req, res) => {
    res.send("Hello world!");
});

app.get("/signup", (req, res) => {
  res.sendFile(path.join(__dirname, '../client/public/signup.html'));
});

app.get("/login", (req, res) => {
  res.sendFile(path.join(__dirname, '../client/public/login.html'));
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
      res.status(401).json({error: "Invalid credentials"});
    }

    // generate JWT
    const token = jwt.sign(
      { userId: user.id },
      process.env.JWT_SECRET,
      { expiresIn: '1h' }
    );

    res.status(200).json({message: `Logged in as: ${user.email}`, token});

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