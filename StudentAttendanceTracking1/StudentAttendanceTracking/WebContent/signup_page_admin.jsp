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
		<h1 style = "text-align: center;">Register Here</h1>
	</div>
		<h4>Fill the details below in order to register</h4>
	<div class = "jumbotron">
		<form action = "login_page_admin.jsp">
			<div class = "rows">
				<div class = "col-sm-6">
					
					<div class = "form-group">
    					<label for="firstName">First Name:</label>
    					<input type="firstName" class="form-control" id="firstName" placeholder="first name" name = "firstName">
    				</div>
    	
    				<div class="form-group">
    					<label for="pwd">Password:</label>
      					<input type="password" class="form-control" id="pwd" placeholder="Enter password" name = "pwd">
    				</div>
    	
    	    		<div class = "form-group">
    					<label for="phoneNumber">Phone: </label>
    					<input type="phoneNumber" class="form-control" id="phoneNumber" placeholder="xxx-xxx-xxxx" name = "phoneNumber">
    				</div>
				</div>
    	
    			<div class = "col-sm-6">
    				
    				<div class = "form-group">
    					<label for="lastName">Last Name:</label>
    					<input type="lastName" class="form-control" id="lastName" placeholder="last name" name = "lastName">
    				</div>
    	
    				<div class="form-group">
      					<label for="email">Email:</label>
      					<input type="email" class="form-control" id="email" placeholder="Enter email" name = "email">
    				</div>
    	
    				<div class="form-group">
    					<label for="dob">Date Of Birth:</label>
      					<input type="dob" class="form-control" id="dob" placeholder="mm-dd-yyyy" name = "dob">
    				</div><br>
    		
  	 			</div>
  	 				<div class = "row">
  	 					<div class = "col-sm-4"></div>
  	 					<div class = "col-sm-4"><input type="submit" class="btn btn-primary" value = "Register" name = "submit"></div>
  	 				</div>
    		</div>    		
  		</form>
  	</div>
</div>