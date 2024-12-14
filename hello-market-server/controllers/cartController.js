const models = require('../models')


exports.updateCartStatus = async (cartId, isActive, transaction) => {
    return await models.Cart.update(
        { is_active: isActive },
        {
            where: { id: cartId, is_active: !isActive },
            transaction,
        }
    );
};

exports.clearCartItems = async (cartId, transaction) => {
    return await models.CartItem.destroy({
        where: { cart_id: cartId },
        transaction,
    });
};

exports.removeCartItem = async (req, res) => {

    try {
        const { cartItemId } = req.params

        const deletedItem = await models.CartItem.destroy({
            where: {
                id: cartItemId
            }
        })

        if (!deletedItem) {
            return res.status(404).json({ message: 'Cart item not found', success: false });
        }

        // Respond with a success message
        res.status(200).json({ success: true }); // 204 No Content
    } catch (error) {
        res.status(500).json({ message: 'An error occurred while removing the cart item', success: false });
    }
}

exports.loadCart = async (req, res) => {

    try {
        const cart = await models.Cart.findOne({
            where: {
                user_id: req.userId, 
                is_active: true 
            },
            attributes: ['id', 'user_id', 'is_active'],
            include: [
                {
                    model: models.CartItem,
                    as: 'cartItems',
                    attributes: ['id', 'cart_id', 'product_id', 'quantity'],
                    include: [
                        {
                            model: models.Product,
                            as: 'product',
                            attributes: ['id', 'name', 'description', 'price', 'photo_url', 'user_id'] // Specify product fields
                        }
                    ]
                }
            ]
        })

        res.status(200).json({ success: true, cart: cart })

    } catch (error) {
        res.status(500).json({ message: error, success: false });
    }

}

exports.addCartItem = async (req, res) => {

    const productId = req.body.product_id
    const quantity = parseInt(req.body.quantity)
    
    try {
        // get the cart if it is already available for this user 
        let cart = await models.Cart.findOne({
            where: {
                user_id: req.userId,
                is_active: true
            }
        })

        if (!cart) {
            // create a new cart 
            cart = await models.Cart.create({
                user_id: req.userId,
                is_active: true
            })
        }

        // add item to the cart 
        const [cartItem, created] = await models.CartItem.findOrCreate({
            where: {
                cart_id: cart.id,
                product_id: productId,
            },
            defaults: { quantity }
        })

        if (!created) {
            // item already exists 
            cartItem.quantity += quantity
            // save it 
            await cartItem.save()
        }

        // get cartItem with product details 
        const cartItemWithProduct = await models.CartItem.findOne({
            where: {
                id: cartItem.id
            },
            include: [
                {
                    model: models.Product,
                    as: 'product',
                    attributes: ['id', 'name', 'description', 'price', 'photo_url', 'user_id']
                }
            ]
        })

        res.status(201).json({
            message: 'Item added to the cart.',
            success: true,
            cartItem: cartItemWithProduct
        })
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
    }


}