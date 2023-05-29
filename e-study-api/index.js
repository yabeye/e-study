import * as dotenv from 'dotenv';
dotenv.config();

import express from 'express';
import cors from 'cors';
import { fileURLToPath } from 'url';
import path, { dirname } from 'path';
import ip from 'ip';

connectMongoDB();
import './src/models/question.model.js';
import './src/models/answer.model.js';
// import './src/models/user.model.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

import router from './src/routes/index.routes.js';
import connectMongoDB from './src/common/helpers/database.helper.js';
import { errorHandler } from './src/middlewares/error.handler.js';
import { INVALID_ROUTE } from './src/common/constants.js';

const app = express();
const PORT = process.env.PORT || 5100;

app.use(express.json());
app.use(cors());
app.use('/api/hi', (_, res) => {
  res.json({
    message: '✅ bye',
  });
});

app.use(express.static(path.join(__dirname, 'public')));
app.use('/uploads', express.static(path.join(__dirname, 'public/uploads')));

app.use('/api', router);

app.use(errorHandler);
app.get('*', (_, res) => {
  res.status(404).json({
    error: {
      message: INVALID_ROUTE,
      details: 'Route not found',
    },
  });
});

app.listen(PORT, () => {
  console.log(`The server is started on ${PORT} port.`);
  console.dir(ip.address());
});
