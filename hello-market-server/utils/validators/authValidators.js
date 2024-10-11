const { body } = require('express-validator');

const registerValidator = [
    body('username', 'username cannot be empty.').not().isEmpty(),
    body('password', 'password cannot be empty.').not().isEmpty()
];
  
const loginValidator = [
    body('username', 'username cannot be empty.').not().isEmpty(),
    body('password', 'password cannot be empty.').not().isEmpty()
];

module.exports = {
    registerValidator,
    loginValidator
};