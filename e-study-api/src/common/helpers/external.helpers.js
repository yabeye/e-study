import nodemailer from 'nodemailer';

const sendMail = async (mailOptions) => {
  const { SMTP_USER, SMTP_PASSWORD } = process.env;
  let transporter = nodemailer.createTransport({
    host: 'smtp.gmail.com',
    port: 587,
    secure: true,
    auth: {
      user: SMTP_USER,
      pass: SMTP_PASSWORD,
    },
  });

  let info = await transporter.sendMail(mailOptions);
  console.log(`Message send: ${info.messageId}`);
};

export default sendMail;
