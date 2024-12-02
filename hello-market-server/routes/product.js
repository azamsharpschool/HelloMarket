const express = require('express')
const router = express.Router() 
const productController = require('../controllers/productController')
const { createProductValidator, deleteProductValidator, updateProductValidator } = require('../utils/validators/validators'); 
const authenticate = require('../middlewares/authMiddleware');
const validationErrorsMiddleware = require('../middlewares/validationErrorsMiddleware');

// Create a new product
router.post(
    '/',
    authenticate,
    createProductValidator,
    validationErrorsMiddleware,
    productController.create
  );
  
  // Get all products
  router.get('/', productController.getAllProducts);
  
  // Get products for a specific user
  router.get(
    '/user/:userId',
    authenticate,
    productController.getMyProducts
  );
  
  // Upload product data
  router.post(
    '/upload',
    authenticate,
    productController.upload
  );
  
  // Delete a product by ID
  router.delete(
    '/:productId',
    authenticate,
    deleteProductValidator,
    validationErrorsMiddleware,
    productController.deleteProduct
  );
// update product 
// /products/34 
router.put(
    '/:productId',
    authenticate,
    updateProductValidator,
    validationErrorsMiddleware,
    productController.updateProduct
)

module.exports = router 