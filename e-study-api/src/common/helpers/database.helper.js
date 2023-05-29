import mongoose from 'mongoose';

const connectMongoDB = async () => {
  try {
    console.log('MongoURL: ', process.env.MONGO_URI);
    await mongoose.connect(process.env.MONGO_URI);
    console.log('MongoDB connected successfully!');
  } catch (err) {
    console.error(err);
    return;
  }
};

export default connectMongoDB;
