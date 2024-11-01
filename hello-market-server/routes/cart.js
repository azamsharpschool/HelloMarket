const express = require('express')
const router = express.Router() 
const cartController = require('../controllers/cartController')
const { addCartItemValidator } = require('../utils/validators/validators');
const validationErrorsMiddleware = require('../middlewares/validationErrorsMiddleware');

router.post('/items', addCartItemValidator, validationErrorsMiddleware, cartController.addCartItem)

module.exports = router 