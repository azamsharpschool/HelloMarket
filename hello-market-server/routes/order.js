
const express = require('express')
const router = express.Router() 
const orderController = require('../controllers/orderController');
const authenticate = require('../middlewares/authMiddleware');
const { validateCreateOrder } = require('../utils/validators/validators');
const validationErrorsMiddleware = require('../middlewares/validationErrorsMiddleware');

// Load all orders 
router.get('/', orderController.loadOrders)

// Create a new order
router.post(
    '/',
    validateCreateOrder, 
    validationErrorsMiddleware,
    orderController.createOrder
  );

  module.exports = router 