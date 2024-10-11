const models = require('../models');

var methods = {};

methods.findAll = async function(query){
    return await models.Product.findAll(query)
}

methods.create = async function(data){
    return await models.Product.create(data);
}

exports.service = methods;