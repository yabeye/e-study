import express from 'express';

import {
  addNewAnswerToQuestion,
  updateAnswer,
} from '../controllers/answer.controller.js';
import {
  checkAccessToRoute,
  checkBlock,
} from '../middlewares/auth.middleware.js';
import {
  checkAnswerExist,
  checkQuestionExist,
} from '../common/helpers/questions.helper.js';
import { isValidId } from '../middlewares/validation.middleware.js';
import Answer from '../models/answer.model.js';
const router = express.Router({ mergeParams: true });

// PROTECTED ROUTES

router.get('/', async (req, res) => {
  const answers = await Answer.find();
  return res.status(200).json({
    success: true,
    message: 'All Answers',
    data: {
      answers,
    },
  });
});

router.use(checkAccessToRoute);
router.use(checkBlock);

//TODO: File upload using multer for pdf, docs, ppts,  images etc ...
router.post('/:id', [isValidId, checkQuestionExist], addNewAnswerToQuestion);
router.patch('/:id', [isValidId, checkAnswerExist], updateAnswer);

export default router;
