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
	<h4>Student Details</h4>
		<form action = "#" method = "post">
    		<div class = "jumbotron">
    			<div class="form-group">
      				<label for="email1">Student ID:</label>
    			</div><br>
    			
    			<div class="form-group">
    				<label for="pwd1">Student Name:</label>
    			</div><br>
    			
    			<div class="form-group">
    				<label for="pwd1">Section Name:</label>
    			</div><br>
    			
    			<div class="form-group">
    				<label for="pwd1">Attendance Percentage:</label>
    			</div><br>
    			<div class = "row">
    			<div class = "col-sm-4"></div>
    			<div class = "col-sm-4"><input type="submit" class="btn btn-info" value = "Edit" name = "edit"></div>
    			</div>
  			</div>
  		</form>
 	 </div>
</div>

<table class="table table-bordered">
    <thead>
      <tr>
        <th>Date (mm/dd/yyyy)</th>
        <th>Day</th>
        <th>Attendance</th>
        <th></th>
      </tr>
    </thead>
    <tbody>
    <form action = "attendance_mark_page.jsp">
    <tr>
        <td>09/11/2017</td>
        <td>Monday</td>
        <td>present</td>
        <td><input type="submit" class="btn btn-primary" value = "Change" name = "change"></td>
    </tr>
    <tr>
        <td>09/10/2017</td>
        <td>Sunday</td>
        <td>No Class</td>
        <td><input type="submit" class="btn btn-primary" value = "Change" name = "change"></td>
    </tr>
    <tr>
        <td>09/09/2017</td>
        <td>Saturday</td>
        <td>No Class</td>
        <td><input type="submit" class="btn btn-primary" value = "Change" name = "change"></td>
    </tr>
    <tr>
        <td>09/08/2017</td>
        <td>Friday</td>
        <td>Absent</td>
        <td><input type="submit" class="btn btn-primary" value = "Change" name = "change"></td>
    </tr>
    </form>
    </tbody>
  </table>
</div>