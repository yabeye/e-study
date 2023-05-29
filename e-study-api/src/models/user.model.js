import mongoose from 'mongoose';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import crypto from 'crypto';
import Joi from 'joi';

import { ALL_ROLES, DEFAULT_ROLE } from '../common/constants.js';

const UserSchema = new mongoose.Schema(
  {
    firstName: {
      type: String,
      required: true,
      trim: true,
      maxLength: 64,
    },
    lastName: {
      type: String,
      required: true,
      trim: true,
      maxLength: 64,
    },
    email: {
      type: String,
      required: true,
      trim: true,
      // unique: true,
      maxLength: 64,
    },
    phone: {
      type: String,
      minLength: 9,
      maxLength: 13,
      trim: true,
      // unique: true,
    },
    username: {
      type: String,
      required: true,
      trim: true,
      // unique: true,
      maxLength: 64,
    },
    password: {
      type: String,
      required: true,
      maxLength: 255,
    },
    roles: {
      type: String,
      enum: ALL_ROLES,
      default: DEFAULT_ROLE,
    },
    profileImage: {
      type: String,
    },
    question: [
      {
        type: mongoose.Schema.ObjectId,
        ref: 'question',
      },
    ],
    answer: [
      {
        type: mongoose.Schema.ObjectId,
        ref: 'answer',
      },
    ],
    bookmarks: [
      {
        type: mongoose.Schema.ObjectId,
        ref: 'question',
      },
    ],
  },
  { collection: 'users', timestamps: true }
);

UserSchema.methods.generateJwtFromUser = function () {
  const { JWT_SECRET_KEY, JWT_EXPIRE } = process.env;
  const payload = {
    id: this._id,
    name: this.name,
  };
  const token = jwt.sign(payload, JWT_SECRET_KEY, { expiresIn: JWT_EXPIRE });
  return token;
};

UserSchema.methods.getResetPasswordTokenFromUser = function () {
  const randomHexString = crypto.randomBytes(16).toString('hex');
  const resetPasswordToken = crypto
    .createHash('SHA256')
    .update(randomHexString)
    .digest('hex');
  const { RESET_PASSWORD_EXPIRE } = process.env;
  this.resetPasswordToken = resetPasswordToken;
  this.resetPasswordExpire = Date.now() + parseInt(RESET_PASSWORD_EXPIRE);
  return resetPasswordToken;
};

UserSchema.pre('save', function (next) {
  // password is change?
  if (!this.isModified('password')) {
    next();
  }

  // if password is not change, password is hashed
  bcrypt.genSalt(10, (err, salt) => {
    if (err) next(err);
    bcrypt.hash(this.password, salt, (err, hash) => {
      if (err) next(err);
      this.password = hash;
      next();
    });
  });
});

const User = mongoose.model('User', UserSchema);

User.validateRegistrationBody = (body) => {
  const schema = Joi.object({
    firstName: Joi.string().max(64).required(),
    lastName: Joi.string().max(64).required(),
    email: Joi.string().email().max(64).required(),
    phone: Joi.string().min(9).max(14).required(),
    username: Joi.string().max(64).required(),
    password: Joi.string().min(6).max(64).required(),
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

User.validatePatchBody = (body) => {
  const schema = Joi.object({
    firstName: Joi.string().max(64),
    lastName: Joi.string().max(64),
    email: Joi.string().email().max(64),
    phone: Joi.string().min(9).max(14).optional(),
    username: Joi.string().max(64),
    password: Joi.string().min(6).max(64),
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

export default User;
