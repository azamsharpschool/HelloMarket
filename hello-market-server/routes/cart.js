const express = require('express');
const router = express.Router();

const cartController = require('../controllers/cartController');
const { addCartItemValidator } = require('../utils/validators/validators');
const validationErrorsMiddleware = require('../middlewares/validationErrorsMiddleware');
const authenticate = require('../middlewares/authMiddleware');

// Add a cart item
router.post(
  '/items',
  authenticate,
  addCartItemValidator,
  validationErrorsMiddleware,
  cartController.addCartItem
);

// Load cart
router.get(
  '/',
  validationErrorsMiddleware,
  cartController.loadCart
);

// Delete a cart item
router.delete(
  '/item/:cartItemId',
  validationErrorsMiddleware,
  cartController.removeCartItem
);

module.exports = router;
