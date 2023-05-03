import express from 'express';
import dotenv from 'dotenv';
import cors from 'cors';

import { errorHandler } from './src/middlewares/error.handler.js';
import { INVALID_ROUTE } from './src/helpers/constants.js';

const app = express();
const PORT = process.env.PORT || 5100;

app.use(express.json());
app.use(cors());

// TODO: Other routes goes here !
app.use('/api/hi', (_, res) => {
  res.json({
    message: '✅ bye',
  });
});

app.use(errorHandler);
app.get('*', (_, res) => {
  res.status(404).json({
    error: { message: INVALID_ROUTE, details: '' },
  });
});

app.listen(PORT, () => {
  console.log(`The server was started on ${PORT} port.`);
});
