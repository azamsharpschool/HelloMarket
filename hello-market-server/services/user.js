const models = require('../models');

var methods = {};

methods.getByUsername = async function(username){
    return await models.User.findOne({ where: { username } });
}

methods.create = async function(data){
    return await models.User.create(data);
}

exports.service = methods;