import asyncErrorHandler from 'express-async-handler';

import Question from '../../models/question.model.js';
import Answer from '../../models/answer.model.js';
import CustomError from '../../common/CustomError.js';

const checkQuestionExist = asyncErrorHandler(async (req, res, next) => {
  const { id } = req.params;
  const question = await Question.findById({ _id: id });
  if (!question) {
    return next(new CustomError('Question not found'), 404);
  }
  req.question = question;
  next();
});

const checkAnswerExist = asyncErrorHandler(async (req, res, next) => {
  const { answerId } = req.params;
  const questionId = req.question._id;
  const question = await Question.findOne({ _id: questionId, isActive: true });
  if (question) {
    const answer = await Answer.findOne({
      _id: answerId,
      question: questionId,
    })
      .populate({
        path: 'user',
        // select: 'id name lastname ',
      })
      .populate({
        path: 'question',
        // select: 'id title subtitle',
      });
    if (!answer) {
      return next(new CustomError('There is no such answer with that id'), 400);
    }
    req.answer = answer;
    next();
  } else {
    return next(new CustomError('This question was deleted.'));
  }
});

export { checkQuestionExist, checkAnswerExist };
