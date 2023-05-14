import jwt from 'jsonwebtoken';
import asyncErrorHandler from 'express-async-handler';

import CustomError from '../common/CustomError.js';
import User from '../models/user.model.js';
import {
  isTokenIncluded,
  getAccessTokenFromHeader,
} from '../common/helpers/auth.helper.js';
import {
  NO_TOKEN_PROVIDED,
  ONLY_ADMINS_CAN_ACCESS_THIS_ROUTE,
} from '../common/constants.js';
import { Roles } from '../common/enums.js';
import Question from '../models/question.model.js';

const checkAccessToRoute = async (req, res, next) => {
  const unAuthorizedError = new CustomError(NO_TOKEN_PROVIDED, 401);
  const { JWT_SECRET_KEY } = process.env;
  if (!isTokenIncluded(req)) {
    return next(unAuthorizedError);
  }
  const token = getAccessTokenFromHeader(req);

  jwt.verify(token, JWT_SECRET_KEY, async (err, decoded) => {
    if (err) {
      return next(unAuthorizedError);
    }

    req.user = await User.findById(decoded.id);
    if (!req.user) {
      return next(new CustomError('User not found', 400));
    }

    next();
  });
};

const getAdminAccess = asyncErrorHandler(async (req, res, next) => {
  const { id } = req.user;
  const user = await User.findById({ _id: id });

  if (user.role != Roles.Admin) {
    return next(new CustomError(ONLY_ADMINS_CAN_ACCESS_THIS_ROUTE, 403));
  }
  next();
});

const getQuestionOwnerAccess = asyncErrorHandler(async (req, res, next) => {
  const userId = req.user.id;
  const { id } = req.params;
  const question = await Question.findById({ _id: id });

  if (question.askedBy != userId) {
    return next(
      new CustomError('Only owner of a question can access this question', 403)
    );
  }
  req.question = question;
  next();
});

export { checkAccessToRoute, getAdminAccess, getQuestionOwnerAccess };
