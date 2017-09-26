// var $ = require('jQuery');
var Parse = require('parse/node');
var path = require("path");
var express = require("express");
var app = express(); 
var logger = require("morgan");
var bodyParser = require("body-parser");
var http = require('http').Server(app);
var appId = "HxaUEjDqH5kQDlygLZfTP1meqZ9d9T89kiF9C1wB";
var javakey = "apfmv9o37gTwYMbYXI5xQMrZGIQjuqagOLsdSzEy";
Parse.initialize(appId, javakey);
Parse.serverURL = 'https://parseapi.back4app.com';



// $("button").on("click",function(){
// 	var myname= $("input[type='text']").val();
// 	var mypass= $("input[type='password']").val();
// 	Parse.User.logIn("myname", "mypass", {
//   success: function(user) {
//     alert("success");
//   },
//   error: function(user, error) {
//     alert("fail");
//   }
//   });
// });
app.use(logger("dev"));

app.set("views", path.resolve(__dirname, "views"));
app.set("view engine", "ejs");

app.use(bodyParser.urlencoded({ extended: false }));

app.get("/", function(req, res) {
  res.render("index");
});

app.get("/welcome", function(req, res) {
  res.render("welcome");
});


app.post("/",function(req,res){
	var myname=req.body.userId;
    var mypass= req.body.pwd;
	if (!myname || !mypass) {
    res.status(400).send("Entries must have a userId and a password.");
    return;
    }
  
    else{
    	 Parse.User.logIn(myname, mypass, {
      success: function(user) {
      	res.redirect("/welcome");
       console.log("success");
      },
      error: function(user, error) {
        console.log("fail");
         res.send("Failed to connect with back4app");
      }
    });
    }
   
 });

// app.post("/welcome",function(req,res){
//   var query = new Parse.Query("Deals");
//   query.find({
//     success: function(results) {
//       var deals = []
//       results.forEach(function(result){
//         deals.push(result.get("gameTitle") + "-" + result.get("dealType") ) ;
//       });
//       res.send(deals)
//     },

//     error: function(error) {
//      console.log("Error :( ", error);
//     }
//   });
//   });


app.use(function(req, res) {
  res.status(404).render("404");
});



http.listen(8081, function () {
  console.log('App listening on http://127.0.0.1:8081/');
});
