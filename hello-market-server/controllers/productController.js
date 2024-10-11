const multer = require('multer')
const path =  require('path')
const { validationResult } = require('express-validator');
const product = require('../services/product')

// Configure multer for file storage
const storage = multer.diskStorage({
    destination: function (req, file, cb) {
      // Specify the destination folder for uploaded images
      cb(null, 'uploads/');
    },
    filename: function (req, file, cb) {
      // Generate a unique filename for each uploaded file
      cb(null, file.fieldname + '-' + Date.now() + path.extname(file.originalname));
    }
  });

const uploadImage = multer({
    storage: storage,
    limits: { fileSize: 5 * 1024 * 1024 }, // Limit file size to 5MB
    fileFilter: function (req, file, cb) {
      // Accept only images (jpeg, jpg, png)
      const fileTypes = /jpeg|jpg|png/;
      const extname = fileTypes.test(path.extname(file.originalname).toLowerCase());
      const mimeType = fileTypes.test(file.mimetype);
      
      if (mimeType && extname) {
        return cb(null, true);
      } else {
        cb(new Error('Only images are allowed!'));
      }
    }
  }).single('image');

exports.upload = async (req, res) => {
    console.log('upload is called.')
    uploadImage(req, res, (err) => {
        if (err) {
          return res.status(400).send({ message: err.message });
        }
        if (!req.file) {
          return res.status(400).send({ message: 'No file uploaded' });
        }
        res.send({ message: 'File uploaded successfully', fileName: req.file.filename });
      });
}

exports.getAllProducts = async (req, res) => {
    const products = await product.service.findAll({});
    res.json(products);
}

exports.getMyProducts = async (req, res) => {
    try {
        const userId = req.params.userId
        const products = await product.service.findAll({
          user_id: userId
        });
        res.json(products)
    } catch (error) {
        res.status(500).json({ message: 'Error retrieving products', success: false });
    }
}

exports.create = async (req, res) => {

    const errors = validationResult(req);

    if (!errors.isEmpty()) {
        const msg = errors.array().map(error => error.msg).join('')
        return res.status(422).json({ message: msg, success: false });
    }

    const { name, description, price, photoUrl } = req.body

    try {
        const newProduct =  await product.service.create({
          name: name,
          description: description,
          price: price,
          photo_url: photoUrl
        });
        // Return success response with the created product
        return res.status(201).json({ success: true, product: newProduct });
    } catch (error) {
        return res.status(500).json({ message: "Internal server error", success: false });
    }
}