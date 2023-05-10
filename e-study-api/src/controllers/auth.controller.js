import asyncErrorHandler from 'express-async-handler';

import User from '../models/user.model.js';
import CustomError from '../common/CustomError.js';
import { comparePassword } from '../common/helpers/auth.helper.js';

const register = asyncErrorHandler(async (req, res, next) => {
  const { firstName, lastName, email, phone, username, password } = req.body;

  try {
    let user = await User({
      firstName,
      lastName,
      email,
      phone,
      username,
      password,
    });
    await user.save();
    delete user.password;

    //TODO: Send welcome email here !

    return res.status(201).json({
      success: true,
      message: 'Registered successfully',
      data: {
        accessToken: user.generateJwtFromUser(),
        user,
      },
    });
  } catch (error) {
    next(error);
  }
});

const login = asyncErrorHandler(async (req, res, next) => {
  try {
    const user = req.user;
    if (!(await comparePassword(req.body.password, user.password))) {
      throw new CustomError('Wrong password', 400);
    }

    delete user.password;

    return res.json({
      success: true,
      message: 'Authenticated successfully',
      data: { accessToken: user.generateJwtFromUser(), user },
    });
  } catch (err) {
    next(err);
  }
});

const tokenControl = (req, res, next) => {
  res.json({
    success: true,
  });
};

const uploadProfile = asyncErrorHandler(async (req, res, next) => {
  const prefix = `${process.env.ASSET_URL_BASE}/images`;

  const user = await User.findByIdAndUpdate(
    req.user.id,
    {
      profileImage: `${prefix}/${req.savedProfileImage}`,
    },
    { new: true, runValidators: true }
  );
  return res.status(201).json({
    success: true,
    message: 'Image uploaded successfully',
    data: {
      user,
    },
  });
});

export { register, login, tokenControl, uploadProfile };
