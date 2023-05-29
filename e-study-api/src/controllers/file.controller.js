const uploadFile = asyncErrorHandler(async (req, res, next) => {
  const prefix = `${process.env.ASSET_URL_BASE}/images`;

  return res.status(201).json({
    success: true,
    message: 'File Uploaded Successfully',
    data: {
      user,
      file: 'file path',
    },
  });
});

export { uploadFile };
