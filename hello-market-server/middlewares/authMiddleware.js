
const jwt = require('jsonwebtoken');
const models = require('../models') 

const authenticate = async (req, res, next) => {

    console.log("authenticate")
    // get the authorization header 
    const authHeader = req.headers['authorization']

    if(!authHeader) {
        return res.status(401).json({ message: 'No token provided' });
    }

    const token = authHeader.split(' ')[1]

    if(!token) {
        return res.status(401).json({ message: 'Invalid token format' });
    }

    try {

        const decoded = jwt.verify(token, 'SECRETKEY');
        const user = await models.User.findByPk(decoded.userId)
        console.log(user)
        if(!user) {
            return res.status(404).json({ message: 'User not found' });
        }

        req.userId = user.id 
        console.log(req.userId)
        next() 

    } catch (error) {
        console.log(error)
        return res.status(403).json({ message: 'Invalid or expired token' });
    }

}

module.exports = authenticate 