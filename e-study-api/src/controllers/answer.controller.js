import asyncErrorHandler from 'express-async-handler';

import Answer from '../models/answer.model.js';
import User from '../models/user.model.js';
import CustomError from '../common/CustomError.js';

const addNewAnswerToQuestion = asyncErrorHandler(async (req, res, next) => {
  const { id } = req.params;
  const params = req.body;
  const { content } = req.body;

  if ((content ?? '').length < 10) {
    return next(new CustomError('Complete Answer is required', 400));
  }

  const answer = await Answer.create({
    ...params,
    answeredBy: req.user.id,
    question: id,
  });

  const user = await User.findById({ _id: req.user.id });
  user.answer.push(answer);
  await user.save();

  return res.status(200).json({
    success: true,
    message: 'Answered Successfully',
    data: {
      questionId: id,
      answer,
    },
  });
});

const updateAnswer = asyncErrorHandler(async (req, res, next) => {
  const id = req.params.id;
  const body = req.body;
  const { content, voting } = req.body;

  let answer = {
    content: content ?? req.answer.content,
    voteCount: [],
  };

  if (voting) {
    const index = req.question.voteCount.indexOf(req.user.id);
    index === -1
      ? answer.voteCount.push(req.user.id)
      : answer.voteCount.splice(index, 1);
  }

  answer = await Answer.findByIdAndUpdate(
    { _id: id },
    { ...answer },
    { new: true, runValidators: true }
  );

  return res.status(200).json({
    success: true,
    data: {
      answer: answer,
    },
  });
});

export { addNewAnswerToQuestion, updateAnswer };
