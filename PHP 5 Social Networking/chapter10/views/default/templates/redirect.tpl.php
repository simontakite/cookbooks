<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en"> 
<head> 
	<base href="{siteurl}" />
	<meta http-equiv="refresh" content="2;url={url}">
	<title>DINO SPACE! The Social Network for Dinosaur keepers</title> 
	<meta http-equiv="content-type" content="text/html; charset=iso-8859-1" /> 
	<meta name="description" content="The Social Network for Dinosaur keepers" /> 
	<meta name="keywords" content="dinosaur, social, network, dino, space" /> 
	<link type="text/css" href="external/ui-lightness/jquery-ui-1.7.1.custom.css" rel="stylesheet" />	
	<script type="text/javascript" src="external/jquery-1.3.2.min.js"></script> 
	<script type="text/javascript" src="external/jquery-ui-1.7.2.custom.min.js"></script> 
	<script type="text/javascript"> 
		$(function() {
			$('.selectdate').datepicker({
				numberOfMonths: 1,
				showButtonPanel: false
			});
			$('.selectdate').datepicker('option', 'dateFormat', 'dd/mm/yy');
			
		});
		</script> 
	<link rel="stylesheet" type="text/css" href="views/default/style.css" /> 	
	<style type="text/css"> 
	/*.menu{menuselected} a{ background: #FFF !important; color: #3D70A3 !important;}*/
	</style> 
</head> 
<body> 
	<div id="wrapper">
		<div id="sidepane">
			<img src="views/default/images/logo.jpg" />
			<ul>
				<li><a href="home">Home</a></li>
				<li><a href="members">Members</a></li>
				<li class="active"><a href="friends">Friends</a></li>
				<li><a href="profile">Profile</a></li>
				<li><a href="messages">Messages</a></li>
			</ul>
		</div>
		<div id="contentwrapper">
			
			<div id="headerbar">
			{userbar}
			<!-- <p>Hi {username}! Why not <a href="profile">view your profile</a>, or <a href="account">edit your account</a> | <a href="authenticate/logout">logout</a></p> -->
			</div>
			
			<div id="main">
			
				<div id="rightside">
				</div>
				
				<div id="content">
					<h1>{heading}</h1>
					
					<p>{message}</p>
					<p>If you are not redirected, please <a href="{url}">click here</a>.</p>
				</div>
			
			</div>
			
			
			
			
		
		</div>
		
	
	</div>
</body> 
</html>