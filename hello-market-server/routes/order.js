
const express = require('express')
const router = express.Router() 
const orderController = require('../controllers/orderController')

// Create a new order
router.post(
    '/',
    orderController.createOrder
  );

  module.exports = router 