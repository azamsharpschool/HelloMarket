const models = require('../models')



exports.loadCart = async (req, res) => {

    try {
        const cart = await models.Cart.findOne({
            where: {
                user_id: req.userId
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
            cartItem.quantity = quantity
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