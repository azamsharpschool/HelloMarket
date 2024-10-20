
const { validationResult } = require('express-validator');

const validationErrorsMiddleware = (req, res, next) => {
    
    const errors = validationResult(req);
  
    if (!errors.isEmpty()) {
      const msg = errors.array().map(error => error.msg).join(' ');
      return res.status(422).json({ message: msg, success: false });
    }
  
    // If no validation errors, proceed to the next middleware/route handler
    next();
}

module.exports = validationErrorsMiddleware 