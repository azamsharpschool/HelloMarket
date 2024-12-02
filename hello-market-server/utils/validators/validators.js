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

const addCartItemValidator = [
    body('product_id')
      .not()
      .isEmpty()
      .withMessage('Product Id cannot be empty.')
      .isInt()
      .withMessage('Product Id must be an integer.'),
    
    body('quantity')
      .not()
      .isEmpty()
      .withMessage('Quantity cannot be empty.')
  ];

  const updateUserInfoValidator = [
    body('first_name', 'First name cannot be empty.').notEmpty(),
    body('last_name', 'Last name cannot be empty.').notEmpty(),
    body('street', 'Street cannot be empty.').notEmpty(),
    body('city', 'City cannot be empty.').notEmpty(),
    body('state', 'State cannot be empty.').notEmpty(),
    body('zip_code', 'Zip code cannot be empty.').notEmpty(),
    body('country', 'Country cannot be empty.').notEmpty()
  ];

  // Validation rules for createOrder
const validateCreateOrder = [
  body('user_id')
      .isInt({ gt: 0 })
      .withMessage('user_id must be a positive integer'),
  body('total')
      .isFloat({ gt: 0 })
      .withMessage('total must be a positive number'),
  body('order_items')
      .isArray({ min: 1 })
      .withMessage('order_items must be a non-empty array'),
  body('order_items.*.product_id')
      .isInt({ gt: 0 })
      .withMessage('Each order item must have a valid product_id'),
  body('order_items.*.quantity')
      .isInt({ gt: 0 })
      .withMessage('Each order item must have a valid quantity greater than 0'),
  // Custom validation example
  body('order_items').custom((items) => {
      if (!Array.isArray(items) || items.length === 0) {
          throw new Error('order_items must be a non-empty array');
      }
      items.forEach(item => {
          if (!item.product_id || !item.quantity) {
              throw new Error('Each order item must have a product_id and quantity');
          }
      });
      return true;
  }),
];

module.exports = {
    registerValidator,
    loginValidator, 
    createProductValidator, 
    deleteProductValidator, 
    updateProductValidator, 
    addCartItemValidator, 
    updateUserInfoValidator, 
    validateCreateOrder
};