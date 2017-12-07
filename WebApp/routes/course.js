var middleware = require("../middleware"),
	Parse      = require('parse/node'),
    express    = require("express"),
    router     = express.Router();


router.get("/courses", function(req, res) {
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
        res.render("./course/courses",{entries : menuItems,courses: cours});
      }
    });
  }
});

router.get("/courses/:crn/:count", function(req, res) {
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
                res.render("./course/courseView",{entries : menuItems,courses: cours,stud: students}); 
              }
            });
          }
        }); 
      }
    });  
  }
});

router.get("/courseView/regestrationStatus/:CRN",function(req,res){
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
        res.redirect("/courses");
      }
    });
  }
});

router.get("/courseView/remove/:sid/:crn", function(req,res){
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
        res.redirect("/courses");
      }
    });
  }
});

router.get("/addCourse", function(req, res) {  
  sess = req.session;
  menuItems = [];
  if(!sess.user){
    req.flash("error","you are not logged in or your session expired. login to continue.");
    res.redirect("logout");
  }
  else{
    res.render("./course/addCourse",{entries : menuItems});    
  }
});

router.post("/addCourse",middleware.addCourseValidation,middleware.uniqueCrnValidation, function(req, res) {
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
   res.redirect("/courses");   
  }
});

router.get("/removeCourse", function(req, res) {  
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
       res.render("./course/removeCourse",{entries : menuItems,courses: cours});
      }
    });   
  }
});


router.post("/removeCourse", function(req, res) {
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
      res.redirect("/courses");
    }, function(error) {
      req.flash("error","something went wrong.");
      res.redirect("back");
    });     
  }
});

module.exports = router;