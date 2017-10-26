
var Parse = require('parse/node');
var path = require("path");
var express = require("express");
var app = express(); 
var logger = require("morgan");
var bodyParser = require("body-parser");
var http = require('http').Server(app);
var appId = "4N5weJdvcHqi3tc1o0ciQjs7s0O2ezOkFmXwQi4h";
var javakey = "PBJqn5rA4MbrYR7cFZXeQjqUbFBX7ZYu9zRmgAeW";
Parse.initialize(appId, javakey);
Parse.serverURL = 'https://parseapi.back4app.com';

var sess;
var menuItems = [];
var session = require('express-session');
app.use(session({secret: 'ssshhhhh'}));
app.use(logger("dev"));

app.set("views", path.resolve(__dirname, "views"));
app.set("view engine", "ejs");
app.use( express.static( "public" ) );
app.use(bodyParser.urlencoded({ extended: true }));


app.get("/", function(req, res) {
  sess = req.session;
  menuItems = [];
  res.render("index",{entries : menuItems});
});

app.get("/welcome", function(req, res) {
  sess = req.session;
  menuItems = [];
  if(!sess.user){
    res.render("logout");
   
  }
  else{
    res.render("welcome",{entries : menuItems});
  }
});

app.get("/courses", function(req, res) {
  sess = req.session;
 menuItems = [{name:"Add Course",route:"addCourse"},{name:"Remove Course",route:"removeCourse"}];
 var cours = [];
  if(!sess.user){
    res.render("logout");
   
  }
  else{
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
    res.render("courses",{entries : menuItems,courses: cours});
  }

});
}
});


app.get("/courses/:num", function(req, res) {
  sess = req.session;
  menuItems = [{name:"Mark Attendance",route:"markAttendance"},{name:"View Attendance",route:"viewAttendance"}];
  var cours = {};
  if(!sess.user){

   res.render("logout");
  }
  else{
     var query = new Parse.Query("Courses");
  query.find({
    success: function(results) {
      results.forEach(function(result){
        if(result.get("CRN") === req.params.num){
          var courseName = result.get("CourseName");
          cours.CRN=result.get("CRN");
          cours.title= courseName;
          cours.id=sess.user;
          cours.name=sess.name;
          
        }

      });
    res.render("courseView",{entries : menuItems,courses: cours});
     
  }

  });
    
  }
});


app.get("/addCourse", function(req, res) {  
  sess = req.session;
  menuItems = [];
  if(!sess.user){

   res.render("logout");
  }
  else{
    res.render("addCourse",{entries : menuItems});    
}
});

app.post("/addCourse", function(req, res) {
  sess = req.session;
 menuItems = [];
  if(!sess.user){

   res.render("logout");
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

   res.render("logout");
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

   res.render("logout");
  }
  else{
 var subject = req.body.subject.split("-");
 var crn = subject[1];
 var title = subject[0];
 var courses = new Parse.Query("Courses");
 courses.equalTo('professorId', sess.user);
 courses.equalTo('CRN', crn);
 console.log(courses);
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


app.get("/students", function(req, res) {
  sess = req.session;
 menuItems = [];
 var cours = [];
  if(!sess.user){
    res.render("logout");
   
  }
  else{
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
    res.render("students",{entries : menuItems,courses: cours});
  }

});
}
});

app.get("/students/:crn", function(req, res) {
  sess = req.session;
 menuItems = [];
 
  if(!sess.user){
    res.render("logout");   
  }
  else{
    var students = [];
    var sid = [];
    var query = new Parse.Query("regestries");
    var student = new Parse.Query(Parse.User);
    query.find({
      success: function(results) {
        results.forEach(function(result){
          if(result.get("CRN") === req.params.crn){
            var s = result.get("studentId");
            sid.push(s);
          }
        });
        student.find({
          success: function(results) {
            if(sid.length){
              sid.forEach(function(s){
                results.forEach(function(result){
                  if(result.get("ID") === s){
                    var username = result.get("username");
                    students.push({name:username,id:s});
                  }
                });
              });
            } 
            res.render("courseStudent",{entries : menuItems,stud: students}); 
          }
        });
      }
    });
  }
});




app.get("/qr", function(req, res) {
  sess = req.session;
  if(!sess.user){

   res.render("logout");
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
	var myname=req.body.userId;
    var mypass= req.body.pwd;
	if (!myname || !mypass) {
    res.status(400).send("Entries must have a userId and a password.");
    return;
    }
  
    else{
    	 Parse.User.logIn(myname, mypass, {
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