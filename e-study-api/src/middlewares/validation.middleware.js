import mongoose from 'mongoose';
import asyncErrorHandler from 'express-async-handler';

import User from '../models/user.model.js';
import CustomError from '../common/CustomError.js';
import Question from '../models/question.model.js';
import Answer from '../models/answer.model.js';

const validateRegisterBody = async (req, res, next) => {
  const { error } = User.validateRegistrationBody(req.body);
  if (error) return next(new CustomError(error.details[0].message, 400));
  const user = await User.findOne({ email: req.body.email });
  if (user)
    return next(new CustomError('user with this email already exist', 400));
  next();
};

const validateLoginBody = async (req, res, next) => {
  let { email, username, password } = req.body;

  if (!email) {
    if (!username) {
      return next(new CustomError('email or username required', 400));
    }
    const userByUsername = await User.findOne({ username });
    if (!userByUsername) {
      return next(new CustomError('User not found', 400));
    }
    email = userByUsername.email;
  }

  if (!password) {
    return next(new CustomError('password is required', 400));
  }

  req.body = { email: email, password: password };
  next();
};

const checkUserExists = async (req, res, next) => {
  const user = req.body.email
    ? await User.findOne({ email: req.body.email })
    : await User.findById(req.user.id);

  if (!user) return next(new CustomError('User not found', 400));
  req.user = user;
  next();
};

const validateUserUpdateData = async (req, res, next) => {
  const prevUser = await User.findById(req.user.id);

  const { firstName, lastName, phone, username, email } = req.body;

  const body = {
    firstName: firstName ?? prevUser.firstName,
    lastName: lastName ?? prevUser.lastName,
    phone: phone ?? prevUser.phone,
    username: username ?? prevUser.username,
    email: email ?? prevUser.email,
  };

  const { error } = User.validatePatchBody(body);
  if (error) return next(new CustomError(error.details[0].message, 400));

  req.body = body;

  next();
};

const isValidId = (req, res, next) => {
  if (!mongoose.Types.ObjectId.isValid(req.params.id)) {
    return next(new CustomError('Invalid id', 400));
  }

  next();
};

// Questions Validations
const validateNewQuestionBody = async (req, res, next) => {
  const { error } = Question.validateNewQuestionBody(req.body);
  if (error) return next(new CustomError(error.details[0].message, 400));

  next();
};

const checkQuestionData = async (req, res, next) => {
  const { title, description, category } = req.body;
  let question = {
    title: title ?? req.question.title,
    description: description ?? req.question.description,
    category: category ?? req.question.category,
  };

  const { error } = Question.validateNewQuestionBody(question);
  if (error) return next(new CustomError(error.details[0].message, 400));

  next();
};

// Answer Validation
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
        path: 'askedBy',
        model: 'User',
        select: '-password -__v',
      })
      .populate({
        path: 'question',
        model: 'Question',
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

export {
  validateRegisterBody,
  validateLoginBody,
  checkUserExists,
  validateUserUpdateData,
  isValidId,
  validateNewQuestionBody,
  checkQuestionData,
};
