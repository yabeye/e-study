import mongoose from 'mongoose';

import Question from '../models/question.model.js';
import { ALL_REPORTS } from '../common/constants.js';

const AnswerSchema = new mongoose.Schema({
  question: {
    type: mongoose.Schema.ObjectId,
    ref: 'question',
    required: true,
  },
  answeredBy: {
    type: mongoose.Schema.ObjectId,
    ref: 'user',
    required: true,
  },
  content: {
    type: String,
    required: [true, 'Please provide a content'],
    minlength: [10, 'Please provide a title at least 10 characters'],
    maxLength: 1024,
  },
  createdAt: {
    type: Date,
    default: Date.now(),
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
  voteCount: [
    {
      type: mongoose.Schema.ObjectId,
      required: true,
      ref: 'user',
    },
  ],
  isActive: {
    type: Boolean,
    default: true,
  },
});

AnswerSchema.pre('save', async function (next) {
  if (!this.isModified('answeredBy')) return next();

  try {
    const question = await Question.findById({ _id: this.question });
    await question.save();
    question.answers.push(this._id);
    next();
  } catch (err) {
    return next(err);
  }
});

const Answer = mongoose.model('Answer', AnswerSchema);

export default Answer;
