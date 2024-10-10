const express = require('express')
const router = express.Router() 
const authController = require('../controllers/authenticationController')
const { body } = require('express-validator');

const registerValidator = [
    body('username', 'username cannot be empty.').not().isEmpty(), 
    body('password', 'password cannot be empty.').not().isEmpty()  
]

const loginValidator = [
    body('username', 'username cannot be empty.').not().isEmpty(), 
    body('password', 'password cannot be empty.').not().isEmpty()  
]

router.post('/login', loginValidator, authController.login)
router.post('/register', registerValidator, authController.register)

module.exports = router 