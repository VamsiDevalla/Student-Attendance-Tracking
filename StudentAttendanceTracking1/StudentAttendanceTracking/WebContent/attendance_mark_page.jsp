<!Doctype html>
<html>
<head>

<title>
Student Attendance Tracking
</title>


//bootstrap code

<meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
  <link rel="stylesheet" type="text/css" href="css/xiaa.css">

  //bootstrap code ends



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
			<li><a href="login_page_admin.jsp"><span class="glyphicon glyphicon-log-in"></span> Logout</a></li>
		</ul>
	</div>
</div>

<div class = "container">
	<div class = "row">
		<div class="col-sm-4"></div>
		<div class="col-sm-4">
      		<form action = "instructor_view_page.jsp" method = "post">
    		<div class = "jumbotron">
    			
    			<div class="form-group">
      				<label class="col-sm-4" for="inputPassword1">Course: </label>
      				<div class="col-sm-8">
						<select name=courseName class="form-control">
    						<option value="c1">course-1</option>
   	 						<option value="c2">course-2</option>
    						<option value="c3">course-3</option>
						</select>
      				</div>
   			 	</div><br><br>
   			 	<div class="form-group">
      				<label class="col-sm-4" for="inputPassword1">CRN: </label>
      				<div class="col-sm-8">
						<select name=crn class="form-control">
    						<option value="crn1">CRN-1</option>
   	 						<option value="crn2">CRN-2</option>
    						<option value="crn3">CRN-3</option>
						</select>
      				</div>
   			 	</div><br><br>
   			 	<div class="form-group">
      				<label class="col-sm-4" for="inputPassword1">Student: </label>
      				<div class="col-sm-8">
						<select name=student class="form-control">
    						<option value="s1">student-1</option>
   	 						<option value="s2">student-2</option>
    						<option value="s3">student-3</option>
						</select>
      				</div>
   			 	</div><br><br>
   			 	<div class="form-group">
      				<label class="col-sm-4" for="inputPassword1">Date: </label>
      				<div class="col-sm-8">
						<select name=courseName class="form-control">
    						<option value="d1">date-1</option>
   	 						<option value="d2">date-2</option>
    						<option value="d3">date-3</option>
						</select>
      				</div>
   			 	</div><br><br>							
    			
    			<div class = "row">
    			<div class = "col-sm-4"></div>
    			<div class = "col-sm-4"><input type="submit" class="btn btn-primary" value = "submit" name = "submit"></div>
    			</div>
  			</div>
  		</form>
		</div>
	</div>
</div>

</html>
</head>
