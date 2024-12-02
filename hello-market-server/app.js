const express = require('express')
const app = express() 
const cors = require('cors')
const authRoutes = require('./routes/auth')
const productRoutes = require('./routes/product')
const cartRoutes = require('./routes/cart')
const userRoutes = require('./routes/user')
const paymentRoutes = require('./routes/payment') 
const orderRoutes = require('./routes/order')

const authenticate = require('./middlewares/authMiddleware')

// use static resources 
app.use(express.static('public'))
app.use('/uploads',express.static('uploads'))

require('dotenv').config() 

app.use(cors())
app.use(express.json())

app.use('/api/auth', authRoutes);
app.use('/api/products', productRoutes)
app.use('/api/cart', authenticate, cartRoutes)
app.use('/api/user', authenticate, userRoutes)
app.use('/api/payment', authenticate, paymentRoutes)
app.use('/api/orders', authenticate, orderRoutes)

app.listen(8080, () => {
    console.log('Server is running...')
})