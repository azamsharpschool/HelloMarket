const models = require('../models')

exports.addCartItem = async (req, res) => {

    const productId = req.body.product_id
    const quantity = parseInt(req.body.quantity) 

    req.userId = 2 

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
                    attributes: ['id', 'name', 'description', 'price', 'photo_url']
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