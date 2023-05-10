import bcrypt from 'bcryptjs';

const isTokenIncluded = (req) => {
  return (req.headers['authorization'] ?? '').startsWith('Bearer ');
};

const getAccessTokenFromHeader = (req) => {
  const authorization = req.headers['authorization'];
  const token = authorization.split(' ')[1];
  return token;
};

const comparePassword = async (pass, hashPass) => {
  return await bcrypt.compare(pass, hashPass);
};

export { isTokenIncluded, getAccessTokenFromHeader, comparePassword };
