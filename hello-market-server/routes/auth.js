const express = require('express')
const router = express.Router() 
const authController = require('../controllers/authenticationController')
const { registerValidator, loginValidator } = require('../utils/validators/authValidators');

router.post('/login', loginValidator, authController.login);
router.post('/register', registerValidator, authController.register);

module.exports = router 