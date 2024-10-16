const express = require('express')
const router = express.Router() 
const productController = require('../controllers/productController')
const { productValidator } = require('../utils/validators/validators'); 
const authenticate = require('../middlewares/authMiddleware');


router.post('/', productValidator, productController.create)
router.get('/', productController.getAllProducts)
router.get('/user/:userId', authenticate, productController.getMyProducts)
router.post('/upload', productController.upload)

module.exports = router 