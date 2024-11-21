
const models = require('../models')

exports.updateUserInfo = async (req, res) => {

    try {
        const userId = 2
        const { first_name, last_name, street, city, state, zip_code, country } = req.body

        // find the user 
        const user = await models.User.findByPk(userId, {
            attributes: ['id', 'first_name', 'last_name', 'street', 'city', 'state', 'zip_code', 'country']
        })
        
        if (!user) {
            return res.status(404).json({ message: 'User not found.', success: false });
        }

        // update the product 
        await user.update({
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
            user
        });
    } catch (error) {
        console.log(error)
        return res.status(500).json({
            message: 'An error occurred while updating the user',
            success: false
        });
    }
}