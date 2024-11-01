const express = require('express')
const app = express() 
const cors = require('cors')
const authRoutes = require('./routes/auth')
const productRoutes = require('./routes/product')
const cartRoutes = require('./routes/cart')

// use static resources 
app.use(express.static('public'))
app.use('/uploads',express.static('uploads'))

require('dotenv').config() 

app.use(cors())
app.use(express.json())

app.use('/api/auth', authRoutes);
app.use('/api/products', productRoutes)
app.use('/api/cart', cartRoutes)

app.listen(8080, () => {
    console.log('Server is running...')
})