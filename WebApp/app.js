var Parse = require('parse/node');
var path = require("path");
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
app.use(session({secret: 'ssshhhhh'}));
app.set("views", path.resolve(__dirname, "views"));
app.set("view engine", "ejs");

var menuItems = [];
var sess;

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
  menuItems = [{name:"Mark Attendance",route:"markAttendance"},{name:"View Attendance",route:"viewAttendance"}];
  if(!sess.user){
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
            cours.CRN=result.get("CRN");
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

app.get("/addCourse", function(req, res) {  
  sess = req.session;
  menuItems = [];
  if(!sess.user){
    res.redirect("logout");
  }
  else{
    res.render("addCourse",{entries : menuItems});    
  }
});

app.post("/addCourse", function(req, res) {
  sess = req.session;
  menuItems = [];
  if(!sess.user){
    res.redirect("logout");
  }
  else{
   var courses = new Parse.Object("Courses");
   courses.set("departmentId", "fKr8WsSVpm");
   courses.set("CRN",req.body.crn );
   courses.set("CourseName", req.body.subject);
   courses.set("CourseDescription",req.body.des );
   courses.set("professorId", sess.user);
   courses.save();
   res.redirect("/courses");   
  }
});

app.get("/removeCourse", function(req, res) {  
  sess = req.session;
  menuItems = [];
  if(!sess.user){
    res.redirect("logout");
  }
  else{
    menuItems = [];
    var cours = [];
    var query = new Parse.Query("Courses");
    query.find({
      success: function(results) {
        results.forEach(function(result){
          if(result.get("professorId")=== userSId){
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
      res.redirect("/courses");
    }, function(error) {
      alert("something went wrong");
    });     
  }
});

app.get("/qr", function(req, res) {
  sess = req.session;
  if(!sess.user){
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
    res.redirect("logout");
  }
  else{
    var course = req.body.course;
    var ramdom = req.body.ramdom;
    var uri = req.body.uri;
    var courses = new Parse.Query("Courses");
    courses.find({
      success: function(results) {
        results.forEach(function(result){
          if(result.get("CRN") === course.split("-")[1]){
            var count = result.get("lectureCount");
            // var update = new Parse.Object("Courses");
            result.set("lectureCount",parseInt(count)+1);
            result.save(); 
          }
        }); 
        var qr = new Parse.Object("QRCode");
        qr.set("QR", ""+ramdom+course);
        qr.set("uri", uri);
        qr.save();
        open(uri);
        res.redirect("qr");
      }
    });
  }
});

app.get("/logout", function(req, res) {
  req.session.destroy(function(err) {
    if(err) {
      console.log(err);
    } else {
      res.render("logout");
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
        res.redirect("/welcome");
      },
      error: function(user, error) {
        console.log("fail");
        res.send("Failed to connect with back4app");
      }
    });
  } 
});

app.use(function(req, res) {
  res.status(404).render("404");
});

http.listen(8081, function () {
  console.log('App listening on http://127.0.0.1:8081/');
});