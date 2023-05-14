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
  const { id } = req.params;

  const answer = await Answer.findOne({
    _id: id,
  });
  // .populate({
  //   path: 'answeredBy',
  //   model: 'User',
  //   select: '-password -__v',
  // });
  // .populate({
  //   path: 'question',
  //   model: 'Question',
  //   // select: 'id title subtitle',
  // });
  if (!answer) {
    return next(new CustomError('Answer not found!'), 404);
  }

  const question = await Question.findById({ _id: answer.question });

  if (!question) {
    return next(new CustomError('Question is not found', 404));
  }
  req.answer = answer;
  req.question = question;

  next();
});

export { checkQuestionExist, checkAnswerExist };
