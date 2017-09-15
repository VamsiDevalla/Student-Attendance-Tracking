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
		<div class = "col-sm-6"></div>
		<div class = "col-sm-6">
			<div class = "page-header">
				<h2 style = "text-align: center;">QR Code Generator</h2>
			</div>
			<div class = "jumbotron">
				<div class = "form-group">
  					<label class="col-sm-4" for="inputName">Number of QR's:</label>
     					<div class="col-sm-4">
     						<select name=qrs class="form-control">
    							<option value="1">1</option>
   	 							<option value="2">2</option>
    							<option value="3">3</option>
    							<option value="4">4</option>
    							<option value="5">5</option>
							</select>
     					</div><br>
      			</div><br>
      			<div class = "form-group">
  					<label class="col-sm-4" for="inputName">Time Lapse:</label>
     					<div class="col-sm-4">
     						<select name=timeLapse class="form-control">
    							<option value="5">5 min</option>
   	 							<option value="10">10 min</option>
    							<option value="15">15 min</option>
    							<option value="20">20 min</option>
    							<option value="25">25 min</option>
    							<option value="30">30 min</option>
    							<option value="35">35 min</option>
    							<option value="40">40 min</option>
    							<option value="45">45 min</option>
    							<option value="50">50 min</option>
    							<option value="55">55 min</option>
    							<option value="60">60 min</option>
    							<option value="65">65 min</option>
    							<option value="70">70 min</option>
    							<option value="75">75 min</option>
    							<option value="80">80 min</option>
    							<option value="85">85 min</option>
    							<option value="90">90 min</option>
							</select>
     					</div><br><br>
      			</div>
      			<div class = "row">
      				<div class = "col-sm-4"></div>
      				<div class = "col-sm-4"><input type="submit" class="btn btn-primary" value = "GENERATE" name = "generate"></div>
      			</div>
			</div>
		</div>
	</div>
</div>