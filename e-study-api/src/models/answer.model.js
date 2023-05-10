import mongoose from 'mongoose';

import Question from '../models/question.model.js';
import { ALL_REPORTS } from '../helpers/constants.js';

const AnswerSchema = new mongoose.Schema({
  question: {
    type: mongoose.Schema.ObjectId,
    ref: 'Question',
    required: true,
  },
  answeredBy: {
    type: mongoose.Schema.ObjectId,
    ref: 'User',
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
  report: {
    type: String,
    enum: ALL_REPORTS,
  },
  voteCount: {
    type: Number,
    default: 0,
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
