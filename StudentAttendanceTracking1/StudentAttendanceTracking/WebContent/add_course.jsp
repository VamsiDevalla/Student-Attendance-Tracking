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
			<li><a href="instructor_view_page.jsp">Home</a></li>
		</ul>
		<ul class = "nav navbar-nav navbar-right">
			<li><a href="login_page_admin.jsp"><span class="glyphicon glyphicon-log-in"></span> Logout</a></li>
		</ul>
	</div>
</div>
<div class = "container-fluid">
<div class = "row">
	<div class = "col-sm-4">
	</div>
		
	<div class = "col-sm-4">
	<h4>Add Courses Here</h4>
		<form action = "#" method = "post">
    		<div class = "jumbotron">
    			<div class="form-group">
      				<label for="email1">Course Title:</label>
      				<input type="courseTitle" class="form-control" id="courseTitle" placeholder="Enter course title" name = "courseTitle">
    			</div><br>
    			
    			<div class="form-group">
    				<label for="pwd1">CRN:</label>
      				<input type="crn" class="form-control" id="crn" placeholder="Enter CRN" name = "crn">
    			</div><br>
    			
    			<div class="form-group">
    				<label for="pwd1">Number of Sections:</label>
      				<input type="nos" class="form-control" id="nos" placeholder="Number of Sections" name = "nos">
    			</div><br>
    			
    			<div class="form-group">
      				<button type="button" class="btn btn-default">Upload an Image</button>
    			</div><br>
    			<div class = "row">
    			<div class = "col-sm-4"><input type="submit" class="btn btn-danger" value = "Cancel" name = "cancel"></div>
    			<div class = "col-sm-4"></div>
    			<div class = "col-sm-4"><input type="submit" class="btn btn-primary" value = "Add Course" name = "addCourse"></div>
    			</div>
  			</div>
  		</form>
 	 </div>
</div>
</div>