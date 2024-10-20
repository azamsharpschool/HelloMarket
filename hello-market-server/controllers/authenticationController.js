const jwt = require('jsonwebtoken')
const bcrypt = require('bcryptjs')
const models = require('../models')
const { Op } = require('sequelize');
const { validationResult } = require('express-validator');

exports.login = async (req, res) => {
    try {
       
        const { username, password } = req.body;
        console.log(username, password)

        // Check if username exists
        const existingUser = await models.User.findOne({ where: { username } });
        if (!existingUser) {
            return res.status(401).json({ message: 'Username or password is incorrect', success: false });
        }

        // Check the password
        const isPasswordValid = await bcrypt.compare(password, existingUser.password);
        if (!isPasswordValid) {
            return res.status(401).json({ message: 'Username or password is incorrect', success: false });
        }

        // Generate JWT token
        const token = jwt.sign({ userId: existingUser.id }, 'SECRETKEY', {
            expiresIn: '1h', // Token expiration time
        });

        return res.status(200).json({ userId: existingUser.id, username: existingUser.username, token, success: true });
    } catch (error) {
        return res.status(500).json({ message: 'Internal server error', success: false });
    }
};


exports.register = async (req, res) => {
   
    try {
        const { username, password } = req.body;

        // Check if the user already exists
        const existingUser = await models.User.findOne({
            where: {
                username: { [Op.iLike]: username },
            },
        });

        if (existingUser) {
            return res.json({ message: 'Username taken!', success: false });
        }

        // Create a password hash
        const salt = await bcrypt.genSalt(10);
        const hash = await bcrypt.hash(password, salt);

        // Create a new user
        const newUser = await models.User.create({
            username: username,
            password: hash,
        });

        res.status(201).json({ success: true });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error', success: false });
    }
};