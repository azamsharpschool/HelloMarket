
const express = require('express')
const router = express.Router() 
const userController = require('../controllers/userController')
const { updateUserInfoValidator } = require('../utils/validators/validators')
const validationErrorsMiddleware = require('../middlewares/validationErrorsMiddleware');

router.put('/', updateUserInfoValidator, validationErrorsMiddleware, userController.updateUserInfo)
router.get('/', userController.loadUserInfo)

module.exports = router 