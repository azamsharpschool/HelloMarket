const express = require('express')
const router = express.Router() 
const productController = require('../controllers/productController')
const { body } = require('express-validator');
const { productValidator } = require('../utils/validators/validators') 

router.post('/', productValidator, productController.create)
router.get('/', productController.getAllProducts)
router.get('/user/:userId', productController.getMyProducts)
router.post('/upload', productController.upload)

module.exports = router 