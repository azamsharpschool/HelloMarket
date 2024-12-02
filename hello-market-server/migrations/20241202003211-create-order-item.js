'use strict';
module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.createTable('OrderItems', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      product_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'Products', // Name of the Products table
          key: 'id'          // Column in the Products table
        },
        onUpdate: 'CASCADE', // Update OrderItems if the Products table is updated
        onDelete: 'CASCADE'  // Delete OrderItems if the referenced Product is deleted
      },
      quantity: {
        type: Sequelize.INTEGER,
        allowNull: false,
        defaultValue: 1      // Default quantity is 1
      },
      order_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'Orders',    // Name of the Orders table
          key: 'id'           // Column in the Orders table
        },
        onUpdate: 'CASCADE', // Update OrderItems if the Orders table is updated
        onDelete: 'CASCADE'  // Delete OrderItems if the referenced Order is deleted
      },
      createdAt: {
        allowNull: false,
        type: Sequelize.DATE,
        defaultValue: Sequelize.NOW
      },
      updatedAt: {
        allowNull: false,
        type: Sequelize.DATE,
        defaultValue: Sequelize.NOW
      }
    });
  },
  down: async (queryInterface, Sequelize) => {
    await queryInterface.dropTable('OrderItems');
  }
};
