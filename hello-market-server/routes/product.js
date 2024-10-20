const express = require('express')
const router = express.Router() 
const productController = require('../controllers/productController')
const { createProductValidator, deleteProductValidator, updateProductValidator } = require('../utils/validators/validators'); 
const authenticate = require('../middlewares/authMiddleware');
const validationErrorsMiddleware = require('../middlewares/validationErrorsMiddleware');


router.post('/', authenticate, createProductValidator,validationErrorsMiddleware , productController.create)
router.get('/', productController.getAllProducts)
router.get('/user/:userId', authenticate, productController.getMyProducts)
router.post('/upload', productController.upload)

// /products/34 
router.delete('/:productId', deleteProductValidator, productController.deleteProduct)

// update product 
// /products/34 
router.put('/:productId', updateProductValidator, validationErrorsMiddleware, productController.updateProduct)

module.exports = router 