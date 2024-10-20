const express = require('express')
const router = express.Router() 
const authController = require('../controllers/authenticationController')
const { registerValidator, loginValidator } = require('../utils/validators/validators');
const validationErrorsMiddleware = require('../middlewares/validationErrorsMiddleware');

router.post('/login', loginValidator, validationErrorsMiddleware, authController.login);
router.post('/register', registerValidator, validationErrorsMiddleware, authController.register);

module.exports = router 