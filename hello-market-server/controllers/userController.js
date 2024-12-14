
const models = require('../models')

exports.loadUserInfo = async (req, res) => {
    try {

        const userInfo = await models.User.findByPk(req.userId, {
            attributes: ['id', 'first_name', 'last_name', 'street', 'city', 'state', 'zip_code', 'country']
        })

        if (!userId) {
            return res.status(404).json({ message: 'User not found.', success: false });
        }

        return res.status(200).json({
            success: true,
            userInfo
        });

    } catch (error) {
        console.error(error)
        return res.status(500).json({
            message: 'An error occurred while loading user info.',
            success: false
        });
    }
}

exports.updateUserInfo = async (req, res) => {

    try {
        const userId = req.userId 
        const { first_name, last_name, street, city, state, zip_code, country } = req.body

        // find the user 
        const userInfo = await models.User.findByPk(userId, {
            attributes: ['id', 'first_name', 'last_name', 'street', 'city', 'state', 'zip_code', 'country']
        })
        
        if (!userInfo) {
            return res.status(404).json({ message: 'User not found.', success: false });
        }

        // update the user 
        await userInfo.update({
            userId, 
            first_name,
            last_name,
            street,
            city,
            state,
            zip_code, 
            country
        })

        return res.status(200).json({
            message: 'User updated successfully',
            success: true,
            userInfo
        });
    } catch (error) {
        console.log(error)
        return res.status(500).json({
            message: 'An error occurred while updating the user',
            success: false
        });
    }
}