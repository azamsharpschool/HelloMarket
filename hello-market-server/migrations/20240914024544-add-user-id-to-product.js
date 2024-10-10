'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.addColumn('Products', 'user_id', {
      type: Sequelize.INTEGER,
      allowNull: true,
      defaultValue: 1, 
      references: {
        model: 'Users',
        key: 'id',
      }
    });
  },

  down: async (queryInterface, Sequelize) => {
    await queryInterface.removeColumn('Products', 'user_id');
  },
};
