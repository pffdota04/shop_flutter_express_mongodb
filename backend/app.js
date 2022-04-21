// Importing packages
const express = require("express");
const mongoose = require("mongoose");
const morgan = require("morgan");
const path = require("path");

//Importing routes
const userRoute = require("./routes/user");
const productsRoute = require("./routes/products");
const ordersRoute = require("./routes/orders");

const app = express();

//Connecting mongo Atlas
mongoose
  .connect(
    "mongodb+srv://aman:" +
      process.env.MONGO_ATLAS_PW +
      "@flutterdb.qau8e.mongodb.net/FlutterDB?retryWrites=true&w=majority",
    {
      useNewUrlParser: true,
      useUnifiedTopology: true,
      useCreateIndex: true,
    }
  )
  .then(() => {
    console.log("Connected to the database"); // successful connection to mongo atlas
  })
  .catch(() => {
    console.log("Failed"); // unsuccessful
  });

//Setting up parser to parse the body  (express.json replaced old body-parser)
app.use(express.json());
app.use(express.urlencoded({ extended: false }));

//Setting up CORS Policy
app.use((req, res, next) => {
  res.header("Access-Control-Allow-Origin", "*");
  res.header(
    "Access-Control-Allow-Methods",
    "GET,HEAD,OPTIONS,POST,PUT,DELETE,PATCH"
  );
  res.header(
    "Access-Control-Allow-Headers",
    "Origin, X-Requested-With, Content-Type, Accept, Authorization"
  );
  next();
});

//Using morgan to log every request
//It is middleware which uses next function after logging the request
app.use(morgan("dev"));

//making uploads directory public
app.use("/uploads", express.static("uploads"));

//Using routes
app.use("/user", userRoute);
app.use("/products", productsRoute);
app.use("/orders", ordersRoute);

//Handling error likes invalid pages
app.use((req, res, next) => {
  let err = new Error("Not Found");
  err.status = 404;
  next(err);
});

//Handling error in database
app.use((err, req, res, next) => {
  res.status(err.status || 500);
  res.json({
    error: err.message
  });
});

module.exports = app;
