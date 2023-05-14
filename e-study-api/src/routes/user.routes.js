import express from 'express';
import {
  getAllUsers,
  getUserById,
  editProfile,
} from '../controllers/user.controller.js';
import {
  checkAccessToRoute,
  getAdminAccess,
} from '../middlewares/auth.middleware.js';
import {
  checkUserExists,
  isValidId,
  validateUserUpdateData,
} from '../middlewares/validation.middleware.js';

const router = express.Router();

// OPEN ROUTES
router.get('/:id', [isValidId], getUserById);

// PROTECTED ROUTES
router.use(checkAccessToRoute);
router.get('/getAllUsers', [checkAccessToRoute], getAllUsers);
router.patch('/', [validateUserUpdateData, checkUserExists], editProfile);

export default router;
