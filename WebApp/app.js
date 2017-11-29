var Parse = require('parse/node');
var path = require("path");
var flash = require("connect-flash");
var express = require("express");
var app = express(); 
var session = require('express-session');
var logger = require("morgan");
var bodyParser = require("body-parser");
var open = require('open');
var http = require('http').Server(app);
var appId = "4N5weJdvcHqi3tc1o0ciQjs7s0O2ezOkFmXwQi4h";
var javakey = "PBJqn5rA4MbrYR7cFZXeQjqUbFBX7ZYu9zRmgAeW";
Parse.initialize(appId, javakey);
Parse.serverURL = 'https://parseapi.back4app.com';

app.use( express.static( "public" ) );
app.use(bodyParser.urlencoded({ extended: true }));
app.use(logger("dev"));
app.use(flash());
app.use(session({
  secret: 'ssshhhhh',
  resave: false,
  saveUninitialized: false
}));
app.set("views", path.resolve(__dirname, "views"));
app.set("view engine", "ejs");

var menuItems = [];
var sess;

app.use(function(req,res,next){
  res.locals.error = req.flash("error");
  res.locals.success = req.flash("success");
  next();
});

app.get("/", function(req, res) {
  sess = req.session;
  menuItems = [];
  res.render("index",{entries : menuItems});
});

app.get("/welcome", function(req, res) {
  sess = req.session;
  menuItems = [{name:"Add Course",route:"addCourse"},{name:"Remove Course",route:"removeCourse"}];
  var cours = [];
  if(!sess.user){
    req.flash("error","you are not logged in or your session expired. login to continue.");
    res.redirect("logout");
  }
  else{
    var query = new Parse.Query("Courses");
    query.find({
      success: function(results) {
        results.forEach(function(result){
          if(result.get("professorId")=== sess.user){
            var crn = result.get("CRN");
            var courseName = result.get("CourseName");
            var totalClasses = result.get("lectureCount");
            cours.push({CRN:crn,title: courseName,count: totalClasses}) ;
          }
        });
        res.render("courses",{entries : menuItems,courses: cours});
      }
    });
  }
});

app.get("/courses/:crn/:count", function(req, res) {
  sess = req.session;
  menuItems = [];
  if(!sess.user){
    req.flash("error","you are not logged in or your session expired. login to continue.");
    res.redirect("logout");
  }
  else{
    var students = [];
    var sid = [];
    var cours = {};
    var query = new Parse.Query("Courses");
    var reg = new Parse.Query("regestries");
    var student = new Parse.Query(Parse.User);
    query.find({
      success: function(results) {
        results.forEach(function(result){
          if(result.get("CRN") === req.params.crn){
            var courseName = result.get("CourseName");
            var regestrationStatus = result.get("regestrationsOpen");
            cours.CRN=result.get("CRN");
            cours.status = regestrationStatus;
            cours.title= courseName;
            cours.id=sess.user;
            cours.name=sess.name;     
          }
        });
        reg.find({
          success: function(results) {
            results.forEach(function(result){
              if(result.get("CRN") === req.params.crn){
                var s = result.get("studentId");
                var a = result.get("lacturesAttended");
                sid.push({sid: s , attendance: a});
              }
            });
            student.find({
              success: function(results) {
                if(sid.length){
                  sid.forEach(function(s){
                    results.forEach(function(result){
                      if(result.get("ID") === s.sid){
                        var username = result.get("username");
                        var att;
                        if(parseInt(req.params.count) === 0){
                          att="course yet to start";
                        }
                        else{
                          att = s.attendance*100/parseInt(req.params.count)+"%"; 
                        }
                        students.push({name:username,id:s.sid,att:att});
                      }
                    });
                  });
                } 
                res.render("courseView",{entries : menuItems,courses: cours,stud: students}); 
              }
            });
          }
        }); 
      }
    });  
  }
});

app.get("/courseView/regestrationStatus/:CRN",function(req,res){
  sess = req.session;
  if(!sess.user){
    req.flash("error","you are not logged in or your session expired. login to continue.");
    res.redirect("logout");
  }
  else{
    var courses = new Parse.Query("Courses");
   courses.find({
      success: function(results) {
        results.forEach(function(result){
          if(result.get("CRN") === req.params.CRN){
            console.log("found some results");
            var status = result.get("regestrationsOpen");
            if(status === "OPEN"){
              result.set("regestrationsOpen", "CLOSED");
              result.save();
            }
            else{
              result.set("regestrationsOpen", "OPEN");
              result.save();
            }    
          }
        });
        res.redirect("/welcome");
      }
    });
  }
});

app.get("/courseView/attEdit/:sid/:crn", function(req,res){
  sess = req.session;
  menuItems = [];
  var attendance = [];
  if(!sess.user){
    req.flash("error","you are not logged in or your session expired. login to continue.");
    res.redirect("logout");
  }
  else{
    var att = new Parse.Query("Attendance");
    att.find({
      success: function(results) {
        results.forEach(function(result){
          if(result.get("CRN") === req.params.crn && result.get("SID") === req.params.sid){
            var date = result.get("createdAt");
            var status = result.get("Status");
            var id = result.id;
            var attend;
            if(status){
              attend = "Present";
            }
            else{
              attend = "Absent";
            }
            attendance.push({date: date, status:attend, objId: id});    
          }
        });
        res.render("attendanceEdit",{entries: menuItems,att: attendance});
      }
    });
  }
});

app.get("/attendanceChange/:id", function(req,res){
  sess = req.session;
  var sid;
  var crn;
  if(!sess.user){
    req.flash("error","you are not logged in or your session expired. login to continue.");
    res.redirect("logout");
  }
  else{
    var att = new Parse.Query("Attendance");
    att.find({
      success: function(results) {
        results.forEach(function(result){
          if(result.id === req.params.id){
            var status = result.get("Status");
            sid = result.get("SID");
            crn = result.get("CRN");
            result.set("Status",!status);
            result.save();
            var reg = new Parse.Query("regestries");
            reg.find({
              success: function(results) {
                results.forEach(function(result){
                  if(result.get("CRN") === crn && result.get("studentId") === sid){
                    var count  = result.get("lacturesAttended");
                    if(!status){
                      result.set("lacturesAttended", parseInt(count)+1);
                      result.save();
                    } 
                    else{
                      result.set("lacturesAttended", parseInt(count)-1);
                      result.save();
                    } 
                  }
                });
               }   
            });
          }
        });
        res.redirect("/courseView/attEdit/"+sid+"/"+crn);
      }
    });
  }
});

app.get("/courseView/remove/:sid/:crn", function(req,res){
  sess = req.session;
  menuItems = [];
  var attendance = [];
  if(!sess.user){
    req.flash("error","you are not logged in or your session expired. login to continue.");
    res.redirect("logout");
  }
  else{
    var reg = new Parse.Query("regestries");
    reg.find({
      success: function(results) {
        results.forEach(function(result){
          if(result.get("CRN") === req.params.crn && result.get("studentId") === req.params.sid){
            result.destroy();  
          }
        });
        res.redirect("/welcome");
      }
    });
  }
});

app.get("/addCourse", function(req, res) {  
  sess = req.session;
  menuItems = [];
  if(!sess.user){
    req.flash("error","you are not logged in or your session expired. login to continue.");
    res.redirect("logout");
  }
  else{
    res.render("addCourse",{entries : menuItems});    
  }
});

app.post("/addCourse",addCourseValidation,uniqueCrnValidation, function(req, res) {
  sess = req.session;
  menuItems = [];
  if(!sess.user){
    req.flash("error","you are not logged in or your session expired. login to continue.");
    res.redirect("logout");
  }
  else{
   var courses = new Parse.Object("Courses");
   courses.set("departmentId", "fKr8WsSVpm");
   courses.set("CRN",req.body.crn );
   courses.set("CourseName", req.body.subject);
   courses.set("CourseDescription",req.body.des );
   courses.set("professorId", sess.user);
   courses.set("lectureCount", 0);
   courses.set("regestrationsOpen", "OPEN");
   courses.save();
   req.flash("success","successfully added course.If the course doesn't reflect try to reload the page");
   res.redirect("/welcome");   
  }
});

app.get("/removeCourse", function(req, res) {  
  sess = req.session;
  menuItems = [];
  if(!sess.user){
    req.flash("error","you are not logged in or your session expired. login to continue.");
    res.redirect("logout");
  }
  else{
    menuItems = [];
    var cours = [];
    var query = new Parse.Query("Courses");
    query.find({
      success: function(results) {
        results.forEach(function(result){
          if(result.get("professorId")=== sess.user){
            var crn = result.get("CRN");
            var courseName = result.get("CourseName");
            cours.push({CRN:crn,title: courseName}) ;
          }
        });
       res.render("removeCourse",{entries : menuItems,courses: cours});
      }
    });   
  }
});


app.post("/removeCourse", function(req, res) {
  sess = req.session;
  if(!sess.user){
    req.flash("error","you are not logged in or your session expired. login to continue.");
    res.redirect("logout");
  }
  else{
    var subject = req.body.subject.split("-");
    var crn = subject[1];
    var title = subject[0];
    var courses = new Parse.Query("Courses");
    courses.equalTo('professorId', sess.user);
    courses.equalTo('CRN', crn);
    courses.equalTo('CourseName', title);
    courses.find().then(function(results) {
        return Parse.Object.destroyAll(results);
    }).then(function() {
      req.flash("success","successfully removed course.");
      res.redirect("/welcome");
    }, function(error) {
      req.flash("error","something went wrong.");
      res.redirect("back");
    });     
  }
});

app.get("/qr", function(req, res) {
  sess = req.session;
  if(!sess.user){
    req.flash("error","you are not logged in or your session expired. login to continue.");
    res.redirect("logout");
  }
  else{
    menuItems = [];
    var cours = [];
    var query = new Parse.Query("Courses");
    query.find({
      success: function(results) {
        results.forEach(function(result){
          if(result.get("professorId")=== sess.user){
            var crn = result.get("CRN");
            var courseName = result.get("CourseName");
            cours.push({CRN:crn,title: courseName}) ;
          }
        });
        res.render("qr",{entries : menuItems,courses: cours});
      }
    }); 
  }
});

app.post("/qr",function(req,res){
  sess = req.session;
  if(!sess.user){
    req.flash("error","you are not logged in or your session expired. login to continue.");
    res.redirect("logout");
  }
  else{
    var course = req.body.course;
    var ramdom = req.body.ramdom;
    var uri = req.body.uri;
    var students = [];
    var courses = new Parse.Query("Courses");
    courses.find({
      success: function(results) {
        results.forEach(function(result){
          if(result.get("CRN") === course.split("-")[1]){
            var count = result.get("lectureCount");
            result.set("lectureCount",parseInt(count)+1);
            result.save(); 
          }
        }); 
        var reg = new Parse.Query("regestries");
        reg.find({
          success: function(results) {
            results.forEach(function(result){
              if(result.get("CRN") === course.split("-")[1]){
                students.push(result.get("studentId"));
              }
            });
            if(students.length){
             students.forEach(function(student){
                var attend =  new Parse.Object("Attendance");
                attend.set("SID", student);
                attend.set("CRN", course.split("-")[1]);
                attend.set("Status", false);
                attend.set("QR", ""+ramdom+course);
                attend.save();
             });
            }
          }   
        });
        var qr = new Parse.Object("QRCode");
          qr.set("QR", ""+ramdom+course);
          qr.set("uri", uri);
          qr.save();
          open(uri);
          req.flash("success","QR is generated and opened in new tab.");
          res.redirect("qr");
      }
    });
  }
});

app.get("/myAccount",function(req, res) {
   sess = req.session;
   menuItems = [];
   acc={};
  if(!sess.user){
    req.flash("error","you are not logged in or your session expired. login to continue.");
    res.redirect("logout");
  }
  else{
    var user = new Parse.Query(Parse.User);
    user.equalTo("objectId", sess.auth);
    user.find({
      success: function(results) {
        results.forEach(function(result){
          acc["fname"] = result.get("firstName");
          acc["lname"] = result.get("lastName");
          acc["ID"] = result.get("ID");
          acc["uname"] = result.get("username");
          acc["email"] = result.get("email1");
          acc["phone"] = result.get("contactNum");
        });
        res.render("myAccount",{entries : menuItems,user: acc});
      },
      error: function(error) {
        alert("Error: " + error.code + " " + error.message);
      }
    });
    
  }
});

app.get("/logout", function(req, res) {
  req.session.destroy(function(err) {
    if(err) {
      req.flash("error","something went wrong while loging out...sorry!!!");
      res.redirect("back");
    } else {
      res.render("logout",{success:"successfully logged out"});
    }
  });
});

app.post("/",function(req,res){
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
        req.flash("success","login success");
        res.redirect("/welcome");
      },
      error: function(user, error) {
        req.flash("error","username or password or both are invalid");
        res.redirect("back");
      }
    });
  } 
});

app.get("/signup",function(req,res){
  res.render("signup");
});

app.post("/signup",signupValidation,function(req,res){
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
      req.flash("success","successfully signed up...explore our application");
      res.redirect("/");   
    },
    error: function(user, error) {
      // Show the error message somewhere and let the user try again.
      req.flash("error",error.code + " : " + error.message);
      res.redirect("back");
    }
  });
});

function signupValidation(req,res,next){
  if(req.body.user_name != null && req.body.user_password != null && req.body.user_password != null && req.body.confirm_password != null && req.body.email != null && req.body.college_id != null 
    && req.body.first_name != null && req.body.last_name != null && req.body.contact_no != null){
    if(req.body.user_name.length<5 || req.body.user_name.length >10){
      req.flash("error","username should contain 5 to 10 letters");
      return res.redirect("back");
    }else if(req.body.user_password.length<5 || req.body.user_password.length>10){
      req.flash("error","password should contain 5 to 10 charectors");
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

function addCourseValidation(req,res,next){
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

function uniqueCrnValidation(req,res,next){
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

app.use(function(req, res) {
  res.status(404).render("404");
});

app.listen(process.env.PORT || 8081,process.env.IP, function(){
    console.log("Student attendance app is started");
});