import mongoose from 'mongoose';

const connectMongoDB = async () => {
  try {
    console.log('MongoURL: TRying to connect to', process.env.MONGO_URI);
    await mongoose.connect(process.env.MONGO_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
      serverSelectionTimeoutMS: 30000,
    });
    console.log('MongoDB connected successfully!');
  } catch (err) {
    console.error(err);
    return;
  }
};

export default connectMongoDB;
