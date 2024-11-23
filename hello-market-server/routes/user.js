
const express = require('express')
const router = express.Router() 
const userController = require('../controllers/userController')

router.put('/', userController.updateUserInfo)
router.get('/', userController.loadUserInfo)

module.exports = router 