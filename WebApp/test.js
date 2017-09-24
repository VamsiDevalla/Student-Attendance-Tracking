var Parse = require('parse/node');
var express = require("express");
var app = express(); 
var http = require('http').Server(app);
var appId = "HxaUEjDqH5kQDlygLZfTP1meqZ9d9T89kiF9C1wB";
var javakey = "apfmv9o37gTwYMbYXI5xQMrZGIQjuqagOLsdSzEy";
Parse.initialize(appId, javakey);
Parse.serverURL = 'https://parseapi.back4app.com';
app.get("/",function(req,res){
    var myname="devalla";
    var mypass= "devalla";
    Parse.User.logIn(myname, mypass, {
      success: function(user) {
       console.log("success");
       res.send("Connected to back4app");
      },
      error: function(user, error) {
        console.log("fail");
         res.send("Failed to connect with back4app");
      }
    });
  
});

http.listen(8081, function () {
  console.log('App listening on http://127.0.0.1:8081/');
});




