import mongoose from 'mongoose';
import * as dotenv from 'dotenv';
dotenv.config();

import Grid from 'gridfs-stream';
const connection = mongoose.createConnection(process.env.MONGO_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
  serverSelectionTimeoutMS: 30000,
});
let gfs;

// connection.once('open', () => {
//   // Create a GridFS stream
//   gfs = Grid(connection.db, mongoose.mongo);
//   gfs.collection('uploads');
//   console.log('Database is connected successfully!');
// });

const connectMongoDB = async () => {
  try {
    console.log('MongoURL: TRying to connect to', process.env.MONGO_URI);
    await mongoose.connect(process.env.MONGO_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
      serverSelectionTimeoutMS: 30000,
    });
    gfs = Grid(connection.db, mongoose.mongo);
    gfs.collection('uploads');
    console.log('MongoDB connected successfully!');
  } catch (err) {
    console.error(err);
    return;
  }
};

connectMongoDB();

export default gfs;
