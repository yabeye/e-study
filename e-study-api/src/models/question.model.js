// question.model.js
import mongoose from 'mongoose';
import Joi from 'joi';

import { ALL_REPORTS } from '../common/constants.js';

const QuestionSchema = new mongoose.Schema({
  title: {
    type: String,
    required: [true, 'Please provide a title'],
    minlength: [5, 'Please provide a title at least 5 characters'],
    maxLength: 1024,
  },
  description: {
    type: String,
    required: [true, 'Please provide a description'],
    minlength: [10, 'Please provide a description at least 10 characters'],
    maxLength: 1024,
  },
  category: {
    type: String,
    required: [true, 'Please provide a category'],
    maxLength: 64,
  },
  subject: {
    type: String,
    required: [true, 'Please provide a subject'],
    maxLength: 64,
  },
  isOpen: {
    type: Boolean,
    default: true,
  },
  reportedBy: [
    {
      type: {
        by: {
          type: mongoose.Schema.ObjectId,
          ref: 'user',
        },
        report: {
          type: String,
          enum: ALL_REPORTS,
        },
      },
    },
  ],
  createdAt: {
    type: Date,
    default: Date.now(),
  },
  askedBy: {
    type: mongoose.Schema.ObjectId,
    required: true,
    ref: 'user',
  },
  voteCount: [
    {
      type: mongoose.Schema.ObjectId,
      required: true,
      ref: 'user',
    },
  ],
  voteCountDown: [
    {
      type: mongoose.Schema.ObjectId,
      required: true,
      ref: 'user',
    },
  ],
  answers: [
    {
      type: mongoose.Schema.ObjectId,
      ref: 'answer',
    },
  ],
  isActive: {
    type: Boolean,
    default: true,
  },
});

const Question = mongoose.model('Question', QuestionSchema);

Question.validateNewQuestionBody = (body) => {
  const schema = Joi.object({
    title: Joi.string().min(5).max(64).required(),
    description: Joi.string().min(10).max(255).required(),
    category: Joi.string().max(64).required(),
    subject: Joi.string().max(64).required(),
  });
  return schema.validate(body, {
    abortEarly: true,
    errors: {
      wrap: {
        label: false,
      },
    },
  });
};

export default Question;
