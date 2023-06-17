import asyncErrorHandler from 'express-async-handler';

import User from '../models/user.model.js';
import CustomError from '../common/CustomError.js';
import { comparePassword } from '../common/helpers/auth.helper.js';
import sendMail from '../common/helpers/external.helpers.js';

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

    if (!user.isActive) {
      return res.status(404).send({
        success: true,
        message: 'You have been blocked!',
        data: {},
      });
    }

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

const resetPassword = asyncErrorHandler(async (req, res, next) => {
  //TODO: Send welcome email here !
  const { email, password = '' } = req.body;

  if (password.length < 6) {
    return res.status(404).send({
      success: true,
      message: 'Password too short to reset!',
      data: {},
    });
  }

  const user = await User.findOne({ email: email });

  if (!user) {
    return res.status(404).send({
      success: true,
      message: 'User not found!',
      data: {},
    });
  }

  if (!user.isActive) {
    return res.status(404).send({
      success: true,
      message: 'You have been blocked!',
      data: {},
    });
  }

  let resetToken =
    process.env.DEPLOYED_URL +
    '/api/auth/confirm?uid=' +
    user.id +
    '&password=' +
    password +
    '&resetToken=' +
    user.generateJwtFromUser();

  // Call sendEmail function to send an email
  const mailOptions = {
    from: process.env.SMTP_USER,
    to: email,
    subject: 'E-Study Reset Password',
    html:
      '<p>To reset your password <a href="' +
      resetToken +
      '">click here </a></p>',
  };
  try {
    await sendMail(mailOptions);
    console.log('Email has sent successfully!');
  } catch (error) {
    console.log('Unable to send email: ' + error);
  }

  console.log('########## RESET TOKEN ##############');
  console.log(resetToken);
  console.log('########## RESET TOKEN ##############');

  return res.status(201).json({
    success: true,
    message: 'Check your email!',
    data: {},
  });
});

const confirmResetPassword = asyncErrorHandler(async (req, res, next) => {
  const { uid, resetToken, password } = req.query;

  let user = await User.findById(uid);
  user.password = password;
  await user.save();
  delete user.password;

  res.send(`
  <html>
    <head>
      <title>Password Reset</title>
    </head>
    <body>
      <h1>Password Reset</h1>
      <h3>Password has been rested</h3>
      <b>Now your password is: ${password}</b>
    </body>
  </html>
`);
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

export {
  register,
  login,
  tokenControl,
  uploadProfile,
  resetPassword,
  confirmResetPassword,
};
