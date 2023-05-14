import User from '../models/user.model.js';
import asyncErrorHandler from 'express-async-handler';

const getAllUsers = asyncErrorHandler(async (req, res, next) => {
  const users = await User.find().select('-password -__v');
  return res.status(200).json({
    success: true,
    message: 'Fetched all users',
    data: {
      users: users,
    },
  });
});

const getUserById = asyncErrorHandler(async (req, res, next) => {
  const user = await User.findById({ _id: req.params.id })
    .populate({
      path: 'question',
      model: 'Question',
      match: { isActive: true },
      select: '-reportedBy -reportedBy -__v',
      populate: {
        path: 'answers',
        model: 'Answer',
        select: '-reportedBy -reportedBy -__v',
        match: { isActive: true },
      },
    })
    .populate({
      path: 'answer',
      model: 'Answer',
      match: { isActive: true },
    })
    .populate({
      path: 'bookmarks',
      model: 'Question',
    });
  return res.status(200).json({
    success: true,
    message: 'User found',
    data: {
      user: user,
    },
  });
});

const editProfile = asyncErrorHandler(async (req, res, next) => {
  const body = req.body;

  const user = await User.findByIdAndUpdate(
    req.user.id,
    { ...body },
    { new: true }
  ).select('-password -__v');
  return res.status(201).json({
    success: true,
    message: 'Updated Profile',
    data: {
      updatedUser: user,
    },
  });
});

export { getAllUsers, getUserById, editProfile };
