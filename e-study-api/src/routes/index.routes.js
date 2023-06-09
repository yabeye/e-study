import express from 'express';
import auth from './auth.routes.js';
import user from './user.routes.js';
import question from './question.routes.js';
import answers from './answer.routes.js';
import files from './file.routes.js';

const router = express.Router();

router.use('/auth', auth);
router.use('/users', user);
router.use('/questions', question);
router.use('/answers', answers);
router.use('/files', files);

export default router;
