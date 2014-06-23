<html>
<head>
<title><?php echo gethostname(); ?></title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="Oops">
<style>
*{box-sizing: border-box;}
body {
	background: #000;
	font-family: "Helvetica Neue", Helmet, Freesans, sans-serif;
}
.parent {
	position:relative;
}
.sibling{
  display:block;
  padding:1%;
  text-align:center;
  position:absolute;
  width:80%;
  top:5em;
  left:10%;
  right:10%;
  color: #fff;
}
@media screen and (max-width:480px) {
	h1 {
		font-size: 1.3em;
	}
}
a, a:visited {
	color: #fff;
	text-decoration: none;
	border-bottom: 1px dotted #000;
}
a:hover, a:focus {
	color: #fff;
	border-bottom: 1px dotted #fff;
}
</style>
</head>
<body>
<div class="parent">
  <div class="sibling">
  	<h1><?php echo gethostname(); ?></h1>
  </div>
</div>
</body>
</html>