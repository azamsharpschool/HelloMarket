// fileUtils.js
const fs = require('fs');
const path = require('path');

// Function to extract file name from URL
const getFileNameFromUrl = (photoUrl) => {
  try {
    const url = new URL(photoUrl); // Parse the URL
    const fileName = path.basename(url.pathname); // Get the file name from the path
    return fileName;
  } catch (error) {
    console.error('Invalid URL:', error);
    return null;
  }
};

// Helper function to delete an image file
const deleteImageFile = (fileName) => {
  return new Promise((resolve, reject) => {
    if (!fileName) {
      return resolve(); // No image to delete
    }

    const fullImagePath = path.join(__dirname, '../uploads', fileName);

    // Check if the file exists before trying to delete it
    fs.access(fullImagePath, fs.constants.F_OK, (accessErr) => {
      if (accessErr) {
        console.error('File does not exist:', fullImagePath);
        return resolve(); // If the file doesn't exist, we consider it successfully "deleted"
      }

      // If the file exists, delete it
      fs.unlink(fullImagePath, (unlinkErr) => {
        if (unlinkErr) {
          console.error('Error deleting image:', unlinkErr);
          return reject(unlinkErr);
        } else {
          console.log('Image deleted successfully');
          return resolve();
        }
      });
    });
  });
};

// Export both functions
module.exports = {
  getFileNameFromUrl,
  deleteImageFile
};
