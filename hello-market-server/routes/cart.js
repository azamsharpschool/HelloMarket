const express = require('express')
const router = express.Router() 
const cartController = require('../controllers/cartController')
const { addCartItemValidator } = require('../utils/validators/validators');
const validationErrorsMiddleware = require('../middlewares/validationErrorsMiddleware');
const authenticate = require('../middlewares/authMiddleware');

// add authenticate later 
const cartItemMiddlewares = [addCartItemValidator, validationErrorsMiddleware];
router.post('/items', cartItemMiddlewares, cartController.addCartItem);

// loadCart
router.get('/', cartController.loadCart)

module.exports = router 