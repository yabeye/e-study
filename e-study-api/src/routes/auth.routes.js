import express from 'express';

import { checkAccessToRoute } from '../middlewares/auth.middleware.js';
import {
  checkUserExists,
  validateLoginBody,
  validateRegisterBody,
} from '../middlewares/validation.middleware.js';
import {
  register,
  login,
  uploadProfile,
} from '../controllers/auth.controller.js';
import profileImageUpload from '../middlewares/imageUpload.middleware.js';

const router = express.Router();

router.post('/register', validateRegisterBody, register);
router.post('/login', [validateLoginBody, checkUserExists], login);
router.post(
  '/uploadProfile',
  [checkAccessToRoute, profileImageUpload.single('profileImage')],
  uploadProfile
);

export default router;
