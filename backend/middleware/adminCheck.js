module.exports = (req, res, next) => {
  if (
    req.userData.role == process.env.ADMIN_ROLE &&
    req.userData.userId == process.env.ADMIN_ID
  ) {
    next();
  } else {
    res.status(401).json({
      message: "You are not authenticated",
    });
  }
};
