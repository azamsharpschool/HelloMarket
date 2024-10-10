const express = require('express')
const router = express.Router() 
const productController = require('../controllers/productController')
const { body } = require('express-validator');

const productValidator = [
    body('name', 'name cannot be empty.').not().isEmpty(), 
    body('description', 'description cannot be empty.').not().isEmpty(), 
    body('price', 'price cannot be empty.').not().isEmpty(), 
    body('photoUrl')
      .optional({ checkFalsy: true }) 
      .isURL().withMessage('photoUrl must be a valid URL if provided.')
]

router.post('/', productValidator, productController.create)
router.get('/', productController.getAllProducts)
router.get('/user/:userId', productController.getMyProducts)
router.post('/upload', productController.upload)

module.exports = router 