import mongoose from 'mongoose';

import { ALL_REPORTS } from '../common/constants.js';

const FileSchema = new mongoose.Schema({
  name: {
    type: String,
    required: [true, 'Please provide a name'],
    maxLength: 64,
  },
  category: {
    type: String,
    required: [true, 'Please provide a category'],
    maxLength: 64,
  },
  uploadedBy: {
    type: mongoose.Schema.ObjectId,
    ref: 'user',
    required: true,
  },
  path: {
    type: String,
    required: [true, 'Please provide a path'],
    maxLength: 64,
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

// FileSchema.pre('save', async function (next) {
//   if (!this.isModified('answeredBy')) return next();

//   try {
//     const question = await Question.findById({ _id: this.question });
//     await question.save();
//     question.answers.push(this._id);
//     next();
//   } catch (err) {
//     return next(err);
//   }
// });

const FileModel = mongoose.model('File', FileSchema);

export default FileModel;
