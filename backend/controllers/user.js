const User = require("../models/user");
const jwt = require("jsonwebtoken");
const bcrypt = require("bcrypt");

exports.user_admin_get = (req, res, next) => {
  User.find()
    .select("email firstname lastname role")
    .exec()
    .then((docs) => {
      res.status(200).json({
        message: "All Users",
        users: docs,
      });
    })
    .catch((err) => {
      res.status(500).json({
        error: err,
      });
    });
};

exports.user_signup = (req, res, next) => {
  User.find({ email: req.body.email })
    .exec()
    .then((doc) => {
      if (doc.length >= 1) {
        res.status(409).json({
          error: "Email-ID already exists!",
        });
      } else {
        bcrypt
          .hash(req.body.password, 10, (err, hash) => {
            if (err)
              return res.status(500).json({ error: err });
            const user = new User({
              email: req.body.email,
              password: hash,
              firstname: req.body.firstname,
              lastname: req.body.lastname,
              role: req.body.role,
            });
            user
              .save()
              .then((result) => {
                const token = jwt.sign(
                  {
                    email: result.email,
                    userId: result._id,
                    role: res.role,
                  },
                  "this_is_a_secret_key_by_@man_Sr1vastava",
                  {
                    expiresIn: "1h",
                  }
                );
                res.status(201).json({
                  message: "Account successfully created!",
                  token: token,
                  expiresIn: 1,
                  userId: result._id,
                  role: result.role,
                });
              })
              .catch((err) => {
                res.status(500).json({
                  error: err,
                });
              });
          })
          .catch((err) => {
            res.status(500).json({
              error: err,
            });
          });
      }
    });
};

exports.user_login = (req, res, next) => {
  let userSave;
  User.findOne({ email: req.body.email }).populate('favorite')
    .then((user) => {
      if (!user) {
        return res.status(404).json({
          error: "Invalid email-id or password",
        });
      }
      userSave = user;
      return bcrypt
        .compare(req.body.password, user.password)
        .then((result) => {
          if (!result) {
            return res.status(404).json({
              error: "Invalid email-id or password",
            });
          }
          const token = jwt.sign(
            {
              email: userSave.email,
              userId: userSave._id,
              role: userSave.role,
            },
            "this_is_a_secret_key_by_@man_Sr1vastava",
            {
              expiresIn: "1h",
            }
          );
          res.status(200).json({
            token: token,
            expiresIn: 1,
            userId: userSave._id,
            role: userSave.role,
          });
        })
        .catch((err) => {
          res.status(500).json({ error: err });
        });
    })
    .catch((err) => {
      res.status(500).json({ error: err });
    });
};

exports.user_delete = (req, res, next) => {
  User.deleteOne({ _id: req.params.id })
    .then((result) => {
      if (result.deletedCount == 0) {
        return res.status(404).json({
          error: "User not found!",
        });
      }
      return res.status(200).json({
        message: "User deleted successfully!",
      });
    })
    .catch((err) => {
      res.status(500).json({
        error: err,
      });
    });
};


exports.user_detail = (req,res,next)=>{
  User.findOne({_id: req.params.id}).populate('favorite').select('-password').then((result)=>{
    if(!result){
      return res.status(404).json({
        error: "Not Found!"
      });
    }
    if(result.id != req.userData.userId){
      return res.status(403).json({
        error: "You're not authorized"
      })
    }
    console.log(result);
    res.status(200).json({
      user: result
    });
  }).catch();
};

exports.user_add_fav = (req,res,next)=>{
  User.updateOne({_id: req.userData.userId},{$push: {"favorite": req.params.pid}}).then((val)=>{
    res.status(200).json(val);
  }).catch((err)=>{
    res.status(500).json({
      error: err,
    });
  })
};

exports.user_rem_fav = (req,res,next)=>{
  User.updateOne({_id: req.userData.userId},{$pull: {"favorite":  req.params.pid}}).then((val)=>{
    res.status(200).json(val);
  }).catch((err)=>{
    res.status(500).json({
      error: err,
    });
  })
};

exports.user_update_detail = (req,res,next)=>{
  User.updateOne({_id:req.userData.userId},{$set: req.body}) .exec()
      .then((result) => {
        if(result.nModified==0){
          res.status(404).json({
            error: 'User not found'
          })
        }
        res.status(200).json({
          message: "User data updated successfully",
        });
      })
      .catch((err) => {
        res.status(500).json({
          error: err,
        });
      });
};

