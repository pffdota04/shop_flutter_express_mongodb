const express = require("express");
const multer = require("multer");

const ProductController = require("../controllers/products");
const auth = require("../middleware/auth");

// setting up storage location and filename pattern
const stroage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, "uploads/");
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + file.originalname);
  },
});

// setting up file filter using mimetype
const fileFilter = (req, file, cb) => {
  if (
    file.mimetype === "image/jpeg" ||
    file.mimetype === "image/jpg" ||
    file.mimetype === "image/png"
  ) {
    cb(null, true);
  } else {
    cb(null, false);
  }
};

const upload = multer({
  storage: stroage,
  limits: {
    fileSize: 1024 * 1024 * 2,
  },
  // fileFilter: fileFilter,
});

const router = express.Router();

// returns the list of products when successful request is made
router.get("/", ProductController.products_get_all);

// request is in form-data type (contains key value pair wher value can be text or file) which
// is different from json to upload image file
router.post(
  "/",
  auth,
  upload.single("productImage"),
  ProductController.products_add_product
);

//return the detail of requested product
router.get("/:id", ProductController.products_get_one);

// patch the requested properties in the given product
router.patch(
  "/withoutImage/:id",
  auth,
  ProductController.products_patch_product_without_image
);

router.patch(
  "/withImage/:id",
  auth,
  upload.single("productImage"),
  ProductController.products_patch_product_with_image
);

// delete the product
router.delete(
  "/:id",
  auth,
  ProductController.products_delete_product
);

module.exports = router;
