import multer from 'multer';

import CustomError from '../common/CustomError.js';

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'public/uploads/images');
  },
  filename: function (req, file, cb) {
    const extension = file.mimetype.split('/')[1];
    req.savedProfileImage = `image_${req.user.id}_${Date.now()}.${extension}`;
    cb(null, req.savedProfileImage);
  },
});

const fileFilter = (req, file, cb) => {
  let allowedTypes = ['image/jpg', 'image/jpeg', 'image/png'];

  if (!allowedTypes.includes(file.mimetype)) {
    return cb(new CustomError('Please provide a valid image file', 400), false);
  }
  return cb(null, true);
};

const profileImageUpload = multer({ storage, fileFilter });

export default profileImageUpload;
