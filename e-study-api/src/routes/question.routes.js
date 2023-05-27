import express from 'express';
import {
  checkAccessToRoute,
  getQuestionOwnerAccess,
} from '../middlewares/auth.middleware.js';
import { checkQuestionExist } from '../common/helpers/questions.helper.js';
import {
  getAllQuestions,
  getQuestion,
  addQuestion,
  updateQuestion,
  deleteQuestion,
  bookmarkToggle,
} from '../controllers/question.controller.js';
import {
  checkQuestionData,
  isValidId,
  validateNewQuestionBody,
} from '../middlewares/validation.middleware.js';

const router = express.Router();

// OPEN ROUTES
router.get('/all/:id', [isValidId, checkQuestionExist], getQuestion);
router.get('/all', getAllQuestions);

// PROTECTED ROUTES
router.use(checkAccessToRoute);
router.post('/ask', [validateNewQuestionBody], addQuestion);
//TODO: File upload using multer for pdf, docs, ppts,  images etc ...
router.patch(
  '/:id',
  [getQuestionOwnerAccess, checkQuestionExist, checkQuestionData],
  updateQuestion
);

router.patch('/bookmark/:id', [checkQuestionExist], bookmarkToggle);
router.delete(
  '/:id',
  [checkQuestionExist, getQuestionOwnerAccess],
  deleteQuestion
);

export default router;
