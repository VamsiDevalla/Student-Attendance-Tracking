//importing required packeges:
var bodyParser = require("body-parser"),
    appId      = "4N5weJdvcHqi3tc1o0ciQjs7s0O2ezOkFmXwQi4h", //app id of the parse app.
    javakey    = "PBJqn5rA4MbrYR7cFZXeQjqUbFBX7ZYu9zRmgAeW", //java script key of the parse app.
    Parse      = require('parse/node'), //importing parse npm pacage
    path       = require("path"),//importing path npm package to define path for different directories. 
    flash      = require("connect-flash"),//importing connect-fash npm package for displaying flash messages.
    express    = require("express"),//importing express framework.
    app        = express(),//initializing express framework
    session    = require('express-session'),//importing express-session npm pacage to maintain sessions for the user.
    logger     = require("morgan"),//importing morgan npm package to log the on going precess in the developer console.
    http       = require('http').Server(app);//to run app on http server.
//importing routes:
var courseRoutes = require("./routes/course"),
    indexRoutes  = require("./routes/index");
//configuring parse server:    
Parse.initialize(appId, javakey);  //initializing parse server with defined appid and javascript key.
Parse.serverURL = 'https://parseapi.back4app.com';// defining url for the parse server.
//configuring application:
app.use( express.static( "public" ) );//configuring app to use folder named public for all static files.
app.use(bodyParser.urlencoded({ extended: true }));//configuring app use body-parse to parse the request body.
app.use(logger("dev"));//initializing logger and configuring app to use it.
app.use(flash());//intializing flash and configuring app to use it.
//configuring session for the application:
app.use(session({
  secret: 'This is the secret code to encrypt the session', //secret message for the encryption and decryption.
  resave: false,
  saveUninitialized: false
}));
app.set("views", path.resolve(__dirname, "views")); //setting up default directory for the app to load views.
app.set("view engine", "ejs");// seeting ejs as default view engine.

var menuItems = [],
    sess;
//setting up local variables for the application.
app.use(function(req,res,next){
  res.locals.error = req.flash("error");
  res.locals.success = req.flash("success");
  next();
});
//configuring routes to the app
app.use(courseRoutes);
app.use(indexRoutes);
//route to display attendance of a student
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
//route to edit attendance of a student
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
//route open qr geration page
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
//route to generate qr
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
          req.flash("success","QR is generated and opened in new tab.");
          res.redirect("qr");
      }
    });
  }
});
//route to display user account page
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
//configuring app to use 404 error page.
app.use(function(req, res) {
  res.status(404).render("404");
});
//configuring port numbers for the app.
app.listen(process.env.PORT || 8081,process.env.IP, function(){
  console.log("Student attendance app is started");
});