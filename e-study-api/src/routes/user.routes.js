import express from 'express';
import {
  getAllUsers,
  getUserById,
  editProfile,
  deleteUser,
} from '../controllers/user.controller.js';
import {
  checkAccessToRoute,
  checkBlock,
  getAdminAccess,
} from '../middlewares/auth.middleware.js';
import {
  checkUserExists,
  checkUserExistsFromId,
  isValidId,
  validateUserUpdateData,
} from '../middlewares/validation.middleware.js';

const router = express.Router();

// OPEN ROUTES
router.get('/:id', [isValidId], getUserById);
router.get('/', getAllUsers);

// PROTECTED ROUTES
router.use(checkAccessToRoute);
router.patch(
  '/',
  [validateUserUpdateData, checkBlock, checkUserExists],
  editProfile
);

router.patch(
  '/admin/:id',
  [isValidId, checkUserExistsFromId, validateUserUpdateData],
  editProfile
);
router.delete('/:id', [isValidId, checkUserExistsFromId], deleteUser);

export default router;
