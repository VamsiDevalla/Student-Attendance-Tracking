var middleware = require("../middleware"),
    Parse      = require('parse/node'),
    express    = require("express"),
    router     = express.Router();

router.get("/", function(req, res) {
  sess = req.session;
  menuItems = [];
  res.render("./index/index",{entries : menuItems});
});

router.post("/",function(req,res){
  sess = req.session;
  var username=req.body.userId;
  var password= req.body.pwd;
  if (!username || !password) {
    res.status(400).send("Entries must have a userId and a password.");
    return;
  }
  else{
    Parse.User.logIn(username, password, {
      success: function(user) {
        sess.user=user.get("ID");
        sess.name=user.get("username");
        sess.auth = user.id;
        if(user.get("emailVerified")){
          req.flash("success","login success");
        }else{
          req.flash("warning","login success,but don't forget to verify your email");
        }
        res.redirect("/courses");
      },
      error: function(user, error) {
        req.flash("error","username or password or both are invalid");
        res.redirect("back");
      }
    });
  } 
});

router.get("/signup",function(req,res){
  res.render("./index/signup");
});

router.post("/signup",middleware.signupValidation,function(req,res){
  var user = new Parse.User();
  user.set("username", req.body.user_name);
  user.set("password", req.body.user_password);
  user.set("email", req.body.email);
  user.set("ID", req.body.college_id);
  user.set("userType", "Professor");
  user.set("firstName", req.body.first_name);
  user.set("lastName", req.body.last_name);
  user.set("contactNum",parseInt(req.body.contact_no));
  user.set("email1", req.body.email);
  user.signUp(null, {
    success: function(result) {
      //Hooray! Let them use the app now.
      req.flash("success","successfully signed up...don't forget to verify the your email");
      res.redirect("/");   
    },
    error: function(user, error) {
      // Show the error message somewhere and let the user try again.
      req.flash("error",error.code + " : " + error.message);
      res.redirect("back");
    }
  });
});

router.get("/logout", function(req, res) {
  req.session.destroy(function(err) {
    if(err) {
      req.flash("error","something went wrong while loging out...sorry!!!");
      res.redirect("back");
    } else {
      res.render("./index/logout",{success:"successfully logged out"});
    }
  });
});

router.get("/forgotPassword", function(req, res){
   res.render("./index/forgotPassword");
});

router.post("/forgotPassword", function(req, res){
  Parse.User.requestPasswordReset(req.body.emailID, {
  success: function() {
  // Password reset request was sent successfully
  req.flash("success","Password reset link was emailed to your registered email");
  res.redirect("/");
  },
  error: function(error) {
    // Show the error message somewhere
    req.flash("error","email was wrong or not found in our system");
    res.redirect("back");
  }
});
});
module.exports = router;