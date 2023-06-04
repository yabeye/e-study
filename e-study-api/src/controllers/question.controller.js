import asyncErrorHandler from 'express-async-handler';

import Question from '../models/question.model.js';
import Answer from '../models/answer.model.js';
import User from '../models/user.model.js';
import CustomError from '../common/CustomError.js';
import { request } from 'express';

const getAllQuestions = asyncErrorHandler(async (req, res, next) => {
  let query = Question.find({
    // isActive: true
  })
    .populate({
      path: 'askedBy',
      model: 'User',
      select: '-password -__v -createdAt -updatedAt',
    })
    .populate({
      path: 'answers',
      model: 'Answer',
      match: { isActive: true },
    });

  const questions = await query;
  questions.sort((a, b) => b.createdAt - a.createdAt);

  return res.status(200).json({
    success: true,
    message: 'Fetched all questions',
    data: {
      questions,
    },
  });
});

const getQuestion = asyncErrorHandler(async (req, res, next) => {
  let question = await Question.findOne({
    _id: req.question.id,
    // isActive: true,
  })
    .populate({
      path: 'askedBy',
      model: 'User',
      select: '-password -__v -createdAt -updatedAt',
    })
    .populate({
      path: 'voteCount',
      model: 'User',
      select: '-password -__v -createdAt -updatedAt',
    })
    .populate({
      path: 'answers',
      model: 'Answer',
      match: { isActive: true },
    });

  const answers = await Answer.find({ question: req.question.id }).populate({
    path: 'answeredBy',
    model: 'User',
    select: '-password -__v',
  });

  if (question) {
    return res.status(200).json({
      success: true,
      message: 'Question found',
      data: {
        question,
        answers,
      },
    });
  } else {
    return next(new CustomError('This question was deleted.', 404));
  }
});

const addQuestion = asyncErrorHandler(async (req, res, next) => {
  const { title, description, category, subject } = req.body;

  const question = await Question({
    title,
    description,
    category,
    subject,
    askedBy: req.user.id,
  });
  await question.save();
  const user = await User.findById({ _id: req.user.id });
  user.question.push(question);
  await user.save();
  res.status(200).json({
    success: true,
    message: 'Asked successfully',
    data: {
      question: question,
    },
  });
});

const updateQuestion = asyncErrorHandler(async (req, res, next) => {
  const {
    title,
    description,
    category,
    subject,
    isOpen,
    reportedBy,
    isActive,
  } = req.body;

  console.log('req.question', req.question);

  let question = {
    title: title ?? req.question.title,
    description: description ?? req.question.description,
    category: category ?? req.question.category,
    isOpen: isOpen ?? req.question.isOpen,
    subject: subject ?? req.question.subject,
    voteCount: [],
    voteCountDown: [],
    reportedBy: req.question.reportedBy ?? [],
    isActive: isActive ?? req.question.isActive,
  };

  if (reportedBy) {
    console.log('Reporeted by value: ', reportedBy);
    question.reportedBy.push(reportedBy);
  }
  console.log('1', question.reportedBy);
  if (isActive === true) {
    question.reportedBy = [...[]];
  }
  console.log('2', question.reportedBy);

  if (req.body.voting == true) {
    let index = req.question.voteCount.indexOf(req.user.id);
    index === -1
      ? question.voteCount.push(req.user.id)
      : question.voteCount.splice(index, 1);

    index = req.question.voteCountDown.indexOf(req.user.id);
    index !== -1 ? console.log() : question.voteCountDown.splice(index, 1);
  } else if (req.body.voting == false) {
    let index = req.question.voteCountDown.indexOf(req.user.id);
    index === -1
      ? question.voteCountDown.push(req.user.id)
      : question.voteCountDown.splice(index, 1);

    index = req.question.voteCount.indexOf(req.user.id);
    index !== -1 ? console.log() : question.voteCount.splice(index, 1);
  }

  question = await Question.findByIdAndUpdate(
    req.question.id,
    {
      ...question,
    },
    { new: true, runValidators: true }
  )
    .populate({
      path: 'askedBy',
      model: 'User',
      select: '-password -__v',
    })
    .populate({
      path: 'answers',
      model: 'Answer',
    });

  return res.status(201).json({
    success: true,
    message: 'Updated Question successfully',
    data: {
      question: question,
    },
  });
});

const deleteQuestion = asyncErrorHandler(async (req, res, next) => {
  const question = req.question;
  await Question.deleteOne({ id: question.id });
  return res.status(200).json({
    success: true,
    message: 'Question suspended successfully',
    data: {
      question: question,
    },
  });
});
// const deleteQuestion = asyncErrorHandler(async (req, res, next) => {
//   const question = req.question;
//   question.isActive = false;
//   question.answer.forEach(async (e) => {
//     await Answer.findByIdAndUpdate(e, { isActive: false });
//   });

//   await question.save();
//   return res.status(200).json({
//     success: true,
//     message: 'Question deleted successfully',
//     data: {
//       question: question,
//     },
//   });
// });

const bookmarkToggle = asyncErrorHandler(async (req, res, next) => {
  // This is how it works, if a question with a given id is not exist in users bookmark
  // array , we will add the question id, if not we will remove from it.
  const user = req.user;
  const questionId = req.question.id;
  const index = user.bookmarks.indexOf(questionId);

  index === -1
    ? user.bookmarks.push(questionId)
    : user.bookmarks.splice(index, 1);

  await user.save();
  return res.status(201).json({
    success: true,
    message: `${index === -1 ? 'Added to' : 'Removed from'} bookmarks`,
    data: {
      user: user,
    },
  });
});

export {
  getAllQuestions,
  getQuestion,
  addQuestion,
  updateQuestion,
  bookmarkToggle,
  deleteQuestion,
};
