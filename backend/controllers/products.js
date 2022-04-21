const Product = require("../models/product");
const fs = require("fs");

exports.products_get_all = (req, res, next) => {
  Product.find()
    .populate("sellerId", "firstname lastname")
    .select(
      "id name price description category productImage sellerId"
    )
    .exec()
    .then((docs) => {
      const response = {
        count: docs.length,
        products: docs.map((doc) => {
          console.log(doc);
          return {
            id: doc._id,
            name: doc.name,
            price: doc.price,
            description: doc.description,
            category: doc.category,
            sellerId: doc.sellerId._id,
            seller:
              doc.sellerId.firstname +
              " " +
              doc.sellerId.lastname,
            productImage:
              "https://fluttershop-backend.herokuapp.com/" +
              doc.productImage,
          };
        }),
      };
      res.status(200).json(response);
    })
    .catch((error) => {
      res.status(500).json({ error: error });
    });
};

exports.products_add_product = (req, res, next) => {
  if (req.userData.role == 0) {
    const product = new Product({
      name: req.body.name,
      price: req.body.price,
      description: req.body.description,
      category: req.body.category,
      sellerName: req.body.sellerName,
      sellerId: req.userData.userId,
      productImage:
        req.file.destination + req.file.filename,
    });
    product
      .save()
      .then((result) => {
        res.status(201).json({
          message: "Product created!",
          product: result,
        });
      })
      .catch((error) => {
        res
          .status(error.status || 500)
          .json({ error: error });
      });
  } else {
    res.status(401).json({
      message: "You are not authenticated",
    });
  }
};

exports.products_get_one = (req, res, next) => {
  Product.findById(req.params.id)
    .exec()
    .then((doc) => {
      if (doc) {
        res.status(200).json({
          id: doc._id,
          name: doc.name,
          price: doc.price,
          description: doc.description,
          category: doc.category,
          sellerName: doc.sellerName,
          productImage:
            "https://fluttershop-backend.herokuapp.com/" +
            doc.productImage,
        });
      } else {
        res.status(404).json({
          message: "No valid entry found",
        });
      }
    })
    .catch((error) => {
      res.status(500).json({ error: error });
    });
};

exports.products_patch_product_without_image = (
  req,
  res,
  next
) => {
  if (req.userData.userId == process.env.ADMIN_ID) {
    Product.updateOne(
      { _id: req.params.id },
      { $set: req.body }
    )
      .exec()
      .then((result) => {
        if (result.nModified == 0) {
          res.status(404).json({
            error: "Product not found!",
          });
        }
        res.status(200).json({
          message: "Product updated successfully",
        });
      })
      .catch((err) => {
        res.status(500).json({
          error: err,
        });
      });
  } else {
    Product.updateOne(
      { _id: req.params.id, sellerId: req.userData.userId },
      { $set: req.body }
    )
      .exec()
      .then((result) => {
        if (result.nModified == 0) {
          res.status(404).json({
            error: "Product not found!",
          });
        }
        res.status(200).json({
          message: "Product updated successfully",
        });
      })
      .catch((err) => {
        res.status(500).json({
          error: err,
        });
      });
  }
};

exports.products_delete_product = (req, res, next) => {
  if (req.userData.userId == process.env.ADMIN_ID) {
    Product.deleteOne({
      _id: req.params.id,
    })
      .then((result) => {
        if (result.deletedCount == 0) {
          return res.status(404).json({
            error: "Product not found!",
          });
        }
        return res.status(200).json({
          message: "Product deleted successfully!",
        });
      })
      .catch((err) => {
        // console.log(err);
        return res.status(500).json({ error: err });
      });
  } else {
    console.log(req.userData.userId);
    console.log(req.params.id);
    Product.findOne({ _id: req.params.id })
      .then((result) => {
        if (result == null) {
          return res.status(404).json({
            error: "Unauthorized action or item not found!",
          });
        }
        if (result.sellerId != req.userData.userId) {
          return res.status(404).json({
            error: "Unauthorized action or item not found!",
          });
        }
        Product.deleteOne({ _id: req.params.id })
          .then(() => {
            res.status(200).json({
              message: "Product deleted successfully",
            });
          })
          .catch((err) => {
            res.status(500).json({
              error: err,
            });
          });
      })
      .catch((err) => {
        return res.status(500).json(err);
      });
  }
};

exports.products_patch_product_with_image = (
  req,
  res,
  next
) => {
  Product.findOne({ _id: req.params.id })
    .then((doc) => {
      try {
        if (doc["productImage"] != null) {
          fs.unlinkSync(doc["productImage"]);
        }
        doc["name"] =
          req.body.name == null
            ? doc["name"]
            : req.body.name;
        doc["price"] =
          req.body.price == null
            ? doc["price"]
            : req.body.price;
        doc["category"] =
          req.body.category == null
            ? doc["category"]
            : req.body.category;
        doc["description"] =
          req.body.description == null
            ? doc["description"]
            : req.body.description;
        doc["productImage"] =
          req.file.destination + req.file.filename;
        doc.save();
        res.status(200).json({
          message: "Product updated!",
        });
      } catch (err) {
        // handle the error
        return res
          .status(400)
          .send({
            error: "Image not Found!\nContact admin!",
          });
      }
    })
    .catch((err) => {
      res.status(500).json({
        error: err,
      });
    });
};
