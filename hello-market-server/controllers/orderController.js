
const models = require('../models')
const cartController = require('./cartController')

exports.loadOrders = async (req, res) => {

    const orders = await models.Order.findAll({
        where: {
            user_id: req.userId 
        }, 
        attributes: ['id', 'user_id', 'total'], 
        include: [
            {
                model: models.OrderItem, 
                as: 'items', 
                attributes: ['id', 'quantity'],
                include: [
                    {
                        model: models.Product, 
                        as: 'product', 
                        attributes: ['id', 'user_id','name', 'description', 'price', 'photo_url']
                    }, 

                ]
            }
        ]
    })

    res.json(orders)

}

exports.createOrder = async (req, res) => {

    const userId = req.userId 

    const { total, order_items } = req.body;

    // Start a transaction for atomicity
    const transaction = await models.Order.sequelize.transaction();

    try {
        // Create the new order
        const newOrder = await models.Order.create(
            {
                user_id: userId,
                total: total,
            },
            { transaction } // Ensure this operation is part of the transaction
        );

        // Add order items
        const orderItemsData = order_items.map(item => ({
            product_id: item.product_id,
            quantity: item.quantity,
            order_id: newOrder.id, // Associate with the newly created order
        }));

        await models.OrderItem.bulkCreate(orderItemsData, { transaction });

        // get active cart_id 
        let cart = await models.Cart.findOne({
            where: {
                user_id: userId, 
                is_active: true 
            },
            attributes: ['id', 'user_id', 'is_active'],
        })

        console.log('CART')
        console.log(cart)

        // Update cart status
        await cartController.updateCartStatus(cart.id, false, transaction);

        // Clear cart items
        await cartController.clearCartItems(cart.id, transaction);

        // Commit the transaction
        await transaction.commit();

        // get the new order and then return it 

        // Return success response
        return res.status(201).json({ success: true });
    } catch (error) {
        // Rollback the transaction in case of an error
        await transaction.rollback();
        console.error(error);
        return res.status(500).json({ message: 'Internal server error', success: false });
    }
};
