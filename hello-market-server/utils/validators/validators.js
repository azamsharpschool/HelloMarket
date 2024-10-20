const { body } = require('express-validator');
const { param } = require('express-validator');

const registerValidator = [
    body('username', 'username cannot be empty.').not().isEmpty(),
    body('password', 'password cannot be empty.').not().isEmpty()
];
  
const loginValidator = [
    body('username', 'username cannot be empty.').not().isEmpty(),
    body('password', 'password cannot be empty.').not().isEmpty()
];

const createProductValidator = [
    body('name', 'name cannot be empty.').not().isEmpty(), 
    body('description', 'description cannot be empty.').not().isEmpty(), 
    body('price', 'price cannot be empty.').not().isEmpty(), 
    body('photo_url')
      .notEmpty().withMessage('photoUrl cannot be empty.')
]

const deleteProductValidator = [
    param('productId')
    .notEmpty().withMessage('Product Id is required')
    .isNumeric().withMessage('Product Id must be a number')
]

const updateProductValidator = [
    param('productId'), 
    body('name', 'name cannot be empty.').not().isEmpty(), 
    body('description', 'description cannot be empty.').not().isEmpty(), 
    body('price', 'price cannot be empty.').not().isEmpty(), 
    body('photo_url')
      .notEmpty().withMessage('photoUrl cannot be empty.')
]

module.exports = {
    registerValidator,
    loginValidator, 
    createProductValidator, 
    deleteProductValidator, 
    updateProductValidator
};