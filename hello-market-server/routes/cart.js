const express = require('express')
const router = express.Router() 
const cartController = require('../controllers/cartController')
const { addCartItemValidator } = require('../utils/validators/validators');
const validationErrorsMiddleware = require('../middlewares/validationErrorsMiddleware');
const authenticate = require('../middlewares/authMiddleware');

// add authenticate later 
router.post('/items', authenticate, addCartItemValidator,validationErrorsMiddleware, cartController.addCartItem);

// load cart 
router.get('/', authenticate, validationErrorsMiddleware, cartController.loadCart)

// delete cart item 
router.delete('/item/:cartItemId', authenticate, validationErrorsMiddleware, cartController.removeCartItem)

module.exports = router 