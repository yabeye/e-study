import express from 'express';
const Grid = require('gridfs-stream');

import FileModel from '../models/file.model.js';

import path from 'path';
import fs from 'fs';

// import { checkQuestionExist } from '../common/helpers/questions.helper';
// import { isValidId } from '../middlewares/validation.middleware';

import multer from 'multer';
import {
  checkAccessToRoute,
  checkBlock,
} from '../middlewares/auth.middleware.js';
import { isValidId } from '../middlewares/validation.middleware.js';
import { fileURLToPath } from 'url';

const router = express.Router();
const __filename = fileURLToPath(import.meta.url);

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'public/uploads/');
  },
  filename: function (req, file, cb) {
    cb(null, file.originalname);
  },
});

const upload = multer({ storage: storage });

// OPEN ROUTES
router.get('/all/:id', [isValidId], async (req, res) => {
  const file = await FileModel.findById(req.params.id).populate({
    path: 'uploadedBy',
    model: 'User',
    select: '-password -__v -createdAt -updatedAt',
  });
  if (!file) {
    return res.send({
      message: 'File not found!',
      data: {
        file: null,
      },
    });
  }
  return res.send({
    message: 'File not found!',
    data: {
      file,
    },
  });
});
router.get('/all', async (req, res) => {
  //   const directoryPath = path.join(__dirname, 'public/uploads/images');
  //   fs.readdir(directoryPath, function (err, files) {
  //     if (err) {
  //       return res.status(500).send({ message: 'Error getting files!' });
  //     }
  //     res.send(files);
  //   });
  //   return;
  const files = await FileModel.find().populate({
    path: 'uploadedBy',
    model: 'User',
    select: '-password -__v -createdAt -updatedAt',
  });
  return res.send({
    message: 'All files!',
    data: {
      files,
      count: files.length,
    },
  });
});

router.get('/download', (req, res) => {
  const filePath = path.join('public/uploads/sample.csv'); // Replace with your file path
  const stat = fs.statSync(filePath);
  const fileSize = stat.size;
  const range = req.headers.range;

  if (range) {
    const parts = range.replace(/bytes=/, '').split('-');
    const start = parseInt(parts[0], 10);
    const end = parts[1] ? parseInt(parts[1], 10) : fileSize - 1;
    const chunksize = end - start + 1;
    const file = fs.createReadStream(filePath, { start, end });
    const head = {
      'Content-Range': `bytes ${start}-${end}/${fileSize}`,
      'Accept-Ranges': 'bytes',
      'Content-Length': chunksize,
      'Content-Type': 'application/pdf',
    };
    res.writeHead(206, head);
    file.pipe(res);
  } else {
    const head = {
      'Content-Length': fileSize,
      'Content-Type': 'application/pdf',
    };
    res.writeHead(200, head);
    fs.createReadStream(filePath).pipe(res);
  }
});

// PROTECTED ROUTES
router.use(checkAccessToRoute);
router.use(checkBlock);

router.post('/upload', [upload.single('file')], async (req, res) => {
  const filePath = req.file.path;
  const { category, name } = req.body;

  const newFile = new FileModel({
    category: category,
    name: name,
    path: filePath,
    uploadedBy: req.user.id,
  });

  await newFile.save();

  return res.send({
    message: 'File uploaded successfully!',
    data: {
      file: newFile,
    },
  });
});

export default router;
