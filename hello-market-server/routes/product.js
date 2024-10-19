const express = require('express')
const router = express.Router() 
const productController = require('../controllers/productController')
const { createProductValidator, deleteProductValidator } = require('../utils/validators/validators'); 
const authenticate = require('../middlewares/authMiddleware');


router.post('/', authenticate, createProductValidator, productController.create)
router.get('/', productController.getAllProducts)
router.get('/user/:userId', authenticate, productController.getMyProducts)
router.post('/upload', productController.upload)

// /products/34 
router.delete('/:productId', deleteProductValidator, productController.deleteProduct)

module.exports = router 