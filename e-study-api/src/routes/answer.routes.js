import express from 'express';

import {
  addNewAnswerToQuestion,
  updateAnswer,
} from '../controllers/answer.controller.js';
import { checkAccessToRoute } from '../middlewares/auth.middleware.js';
import {
  checkAnswerExist,
  checkQuestionExist,
} from '../common/helpers/questions.helper.js';
import { isValidId } from '../middlewares/validation.middleware.js';
const router = express.Router({ mergeParams: true });

// PROTECTED ROUTES
router.use(checkAccessToRoute);

//TODO: File upload using multer for pdf, docs, ppts,  images etc ...
router.post('/:id', [isValidId, checkQuestionExist], addNewAnswerToQuestion);
router.patch('/:id', [isValidId, checkAnswerExist], updateAnswer);

export default router;
