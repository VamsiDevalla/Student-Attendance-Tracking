<!Doctype html>
<html>
<head>

<title>
Student Attendance Tracking
</title>

<meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
  <link rel="stylesheet" type="text/css" href="css/xiaa.css">
  <style>
  .well {
      margin-bottom: 0;
    }
  </style>
</head>
<body>
<div class = "well">
	<div class = "container text-center">
		<h1>Student Attendance Tracking</h1>
	</div>	
</div>
<div class = "navbar navbar-default">
	<div class ="container-fluid">
		<ul class = "nav navbar-nav">
			<li><a href="#">Home</a></li>
		</ul>
		<ul class = "nav navbar-nav navbar-right">
			<li><a href="login_page_admin.jsp"><span class="glyphicon glyphicon-log-in"></span> Login</a></li>
			<li><a href="signup_page_admin.jsp"><span class="glyphicon glyphicon-user"></span> Sign up</a></li>
		</ul>
	</div>
</div>
<div class = "container-fluid">
	<div class = "page-header">
		<h2 style = "text-align: center;">Admin Login</h2>
	</div>
<div class = "row">
	<div class = "col-sm-4">
	</div>
		
	<div class = "col-sm-4">
	<h4>sign in to continue</h4>
		<form action = "instructor_view_page.jsp" method = "post">
    		<div class = "jumbotron">
    			<div class="form-group">
      				<label for="email1">Email:</label>
      				<input type="email" class="form-control" id="email" placeholder="Enter email" name = "email">
    			</div><br>
    			
    			<div class="form-group">
    				<label for="pwd1">Password:</label>
      				<input type="password" class="form-control" id="pwd" placeholder="Enter password" name = "pwd">
    			</div><br>
    			<div class = "row">
    			<div class = "col-sm-4"></div>
    			<div class = "col-sm-4"><input type="submit" class="btn btn-primary" value = "Login" name = "submit"></div>
    			</div>
  				<p style="font-size:100%;">don't have an account? <a href = "signup_page_admin.jsp">click here</a> to register</p>
  			</div>
  		</form>
 	 </div>
  		
  	<div class = "col-sm-4">
  	</div>

</div>
  
</div>