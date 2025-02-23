const express = require('express');
const router = express.Router();

const userController = require('../controllers/userController');
const { updateUserInfoValidator } = require('../utils/validators/validators');
const validationErrorsMiddleware = require('../middlewares/validationErrorsMiddleware');
const authenticate = require('../middlewares/authMiddleware');

// Update user information
router.put(
  '/',
  updateUserInfoValidator,
  validationErrorsMiddleware,
  userController.updateUserInfo
);

// Load user information
router.get('/', userController.loadUserInfo);

module.exports = router;
