import User from '../models/user.model.js';
import CustomError from '../common/CustomError.js';

const validateRegisterBody = async (req, res, next) => {
  const { error } = User.validateRegistrationBody(req.body);
  if (error) return next(new CustomError(error.details[0].message, 400));
  const user = await User.findOne({ email: req.body.email });
  if (user)
    return next(new CustomError('user with this email already exist', 400));
  next();
};

const validateLoginBody = async (req, res, next) => {
  let { email, username, password } = req.body;

  if (!email) {
    if (!username) {
      return next(new CustomError('email or username required', 400));
    }
    const userByUsername = await User.findOne({ username });
    if (!userByUsername) {
      return next(new CustomError('User not found', 400));
    }
    email = userByUsername.email;
  }

  if (!password) {
    return next(new CustomError('password is required', 400));
  }

  req.body = { email: email, password: password };
  next();
};

const checkUserExists = async (req, res, next) => {
  const user = await User.findOne({ email: req.body.email });

  if (!user) return next(new CustomError('user not found', 400));
  req.user = user;
  next();
};

export { validateRegisterBody, validateLoginBody, checkUserExists };
