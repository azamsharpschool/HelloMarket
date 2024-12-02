'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class OrderItem extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      
      // Define a belongsTo association with Product
      OrderItem.belongsTo(models.Product, {
        foreignKey: 'product_id',
        as: 'product', // Alias for accessing associated product
      });
    }
  };
  OrderItem.init({
    product_id: DataTypes.INTEGER,
    quantity: DataTypes.INTEGER,
    order_id: DataTypes.INTEGER
  }, {
    sequelize,
    modelName: 'OrderItem',
  });
  return OrderItem;
};