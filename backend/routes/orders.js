const express = require("express");

const checkAuth = require("../middleware/auth");

const OrderController = require("../controllers/orders");

const router = express.Router();

router.get(
  "/",
  checkAuth,
  OrderController.orders_get_orders
);

router.post(
  "/",
  checkAuth,
  OrderController.orders_place_order
);

router.get(
  "/:id",
  checkAuth,
  OrderController.orders_get_order
);

router.delete(
  "/:id",
  checkAuth,
  OrderController.orders_delete_order
);

module.exports = router;
