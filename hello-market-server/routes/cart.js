const express = require('express')
const router = express.Router() 
const cartController = require('../controllers/cartController')
const { addCartItemValidator } = require('../utils/validators/validators');
const validationErrorsMiddleware = require('../middlewares/validationErrorsMiddleware');
const authenticate = require('../middlewares/authMiddleware');

// add authenticate later 
const cartItemMiddlewares = [authenticate, addCartItemValidator, validationErrorsMiddleware];
router.post('/items', cartItemMiddlewares, cartController.addCartItem);

// load cart 
router.get('/', cartItemMiddlewares, cartController.loadCart)

// delete cart item 
router.delete('/item/:cartItemId', cartItemMiddlewares, cartController.removeCartItem)

module.exports = router 