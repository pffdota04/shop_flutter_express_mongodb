const express = require("express");

const User = require("../models/user");

const checkAuth = require("../middleware/auth");
const adminCheck = require("../middleware/adminCheck");

const UserController = require("../controllers/user");

const router = express.Router();

router.get(
  "/",
  checkAuth,
  adminCheck,
  UserController.user_admin_get
);

router.post("/signup", UserController.user_signup);

router.post("/login", UserController.user_login);

router.get("/:id",checkAuth, UserController.user_detail);

router.delete("/:id",checkAuth,adminCheck,UserController.user_delete);

router.post("/add/:pid",checkAuth,UserController.user_add_fav);

router.post("/remove/:pid",checkAuth,UserController.user_rem_fav);

router.post("/update",checkAuth,UserController.user_update_detail);

module.exports = router;
