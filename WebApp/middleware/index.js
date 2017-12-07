var Parse      = require('parse/node'),
    middleware = {};
middleware.signupValidation =  function(req,res,next){
  if(req.body.user_name != null && req.body.user_password != null && req.body.user_password != null && req.body.confirm_password != null && req.body.email != null && req.body.college_id != null 
    && req.body.first_name != null && req.body.last_name != null && req.body.contact_no != null){
    if(req.body.user_name.length<5 || req.body.user_name.length >20){
      req.flash("error","username should contain 5 to 10 letters");
      return res.redirect("back");
    }else if(req.body.user_password.length<5 || req.body.user_password.length>20){
      req.flash("error","password should contain 5 to 20 charectors");
      return res.redirect("back");
    }else if(req.body.college_id.length != 7){
      req.flash("error","ID should contain exactly 7 charecters");
      return res.redirect("back");
    }else if(req.body.contact_no.length != 10){
      req.flash("error","phone number should contain 10 letters");
      return res.redirect("back");
    }else{
      next();
    }
  }else if(req.body.user_password != req.body.confirm_password){
    req.flash("error","passwords did not matched");
    return res.redirect("back");
  }else{
    req.flash("error","All fields are manditory");
    return res.redirect("back");
  }
}

middleware.addCourseValidation = function(req,res,next){
  if(req.body.crn.length != 5){
    req.flash("error","CRN should be 5 digit number");
    return res.redirect("back");  
  }else if(req.body.des == null || req.body.des.length < 30){
    req.flash("error","Description should have a of length 100 charecters");
    return res.redirect("back");  
  }
  else{
    next();
  }
}

middleware.uniqueCrnValidation = function(req,res,next){
  var query = new Parse.Query("Courses");
  var flag=0;
    query.find({
      success: function(results) {
        results.forEach(function(result){
          if(result.get("CRN")=== req.body.crn){
            req.flash("error","This CRN alrdy exits. Give some other crn");
            flag =1;
            return res.redirect("back");  
          }
        });
        if(flag==0){
          next();
        }
      }
    }); 
}

middleware.qrValidation = function(req,res,next){
  var ramdom = req.body.ramdom;
  var uri = req.body.uri;
  if(uri == null){
    req.falsh("error","sorry try again");
    res.redirect("back");
  }else if(ramdom == null){
    req.falsh("error","Don't forget to generate rando code");
    res.redirect("back");
  }else if(ramdom.length >3){
    req.falsh("error","ramdom number can not be grater than 999");
    res.redirect("back");
  }else{
    next();
  }
}

module.exports = middleware;