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

const checkAccessToRoute = (req, res, next) => {
  const unAuthorizedError = new CustomError(NO_TOKEN_PROVIDED, 401);
  const { JWT_SECRET_KEY } = process.env;
  if (!isTokenIncluded(req)) {
    return next(unAuthorizedError);
  }
  const token = getAccessTokenFromHeader(req);

  jwt.verify(token, JWT_SECRET_KEY, (err, decoded) => {
    if (err) {
      return next(unAuthorizedError);
    }
    req.user = {
      id: decoded.id,
      name: decoded.name,
      role: decoded.role,
    };
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

export { checkAccessToRoute, getAdminAccess };
