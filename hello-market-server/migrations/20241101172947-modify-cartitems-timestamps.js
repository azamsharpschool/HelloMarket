module.exports = {
  up: async (queryInterface, Sequelize) => {
    // Remove the added_at column
    await queryInterface.removeColumn('CartItems', 'added_at');

    // Add the createdAt and updatedAt columns
    await queryInterface.addColumn('CartItems', 'createdAt', {
      allowNull: false,
      type: Sequelize.DATE,
      defaultValue: Sequelize.NOW,
    });

    await queryInterface.addColumn('CartItems', 'updatedAt', {
      allowNull: false,
      type: Sequelize.DATE,
      defaultValue: Sequelize.NOW,
    });
  },

  down: async (queryInterface, Sequelize) => {
    // Revert changes: add the added_at column back
    await queryInterface.addColumn('CartItems', 'added_at', {
      type: Sequelize.DATE,
      defaultValue: Sequelize.NOW,
    });

    // Remove createdAt and updatedAt columns
    await queryInterface.removeColumn('CartItems', 'createdAt');
    await queryInterface.removeColumn('CartItems', 'updatedAt');
  },
};
