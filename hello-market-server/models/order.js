'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class Order extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      Order.hasMany(models.OrderItem, {
        foreignKey: 'order_id', 
        as: 'items', 
        onDelete: 'CASCADE'
      })
    }
  };
  Order.init({
    user_id: DataTypes.INTEGER,
    total: DataTypes.FLOAT
  }, {
    sequelize,
    modelName: 'Order',
  });
  return Order;
};