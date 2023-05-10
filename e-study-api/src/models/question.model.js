// question.model.js
import mongoose from 'mongoose';

import { ALL_REPORTS } from '../helpers/constants';

const QuestionSchema = new mongoose.Schema({
  title: {
    type: String,
    required: [true, 'Please provide a title'],
    minlength: [10, 'Please provide a title at least 10 characters'],
    unique: true,
  },
  description: {
    type: String,
    required: [true, 'Please provide a description'],
    minlength: [10, 'Please provide a description at least 10 characters'],
  },
  isOpen: {
    type: Boolean,
    default: true,
  },
  report: {
    type: String,
    enum: ALL_REPORTS,
  },
  createdAt: {
    type: Date,
    default: Date.now(),
  },
  askedBy: {
    type: mongoose.Schema.ObjectId,
    required: true,
    ref: 'User',
  },
  voteCount: {
    type: Number,
    default: 0,
  },
  answers: [
    {
      type: mongoose.Schema.ObjectId,
      ref: 'Answer',
    },
  ],
});

const Question = mongoose.model('Question', QuestionSchema);
export default Question;
