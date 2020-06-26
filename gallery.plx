#!/usr/bin/perl


use strict;
use warnings;
use CGI qw(:standard);	
use DBI;
use feature 'say';

my $input = param ("sltPicasso");
my $username = param("txtUserName");
my $buyCust = param("loggedUsr");
if($buyCust)
{
	$username = $buyCust;
}
#parameter passed from index.html, signalling database STATUS column reset
my $rstStatus = param("acessgly3");		

my $html_head = <<"EHTML";

<!DOCTYPE html>
<head>
	<meta charset='UTF-8'/>
	<title>Assignment 3</title>
	<script type='text/javascript' ></script>
	<link rel="stylesheet" href="../../css/gallery.css" />
</head>

<body>
	<header>
		<h1>Pablo Picasso's Galleria</h1>
	</header>
	<form id='galleryForm' method="post" action="gallery.plx">
EHTML

#my $html_form = <<"EFORM";

my $serverDb = "**MASKED**";
my $serverName = "*MASKED**";
my $serverPort = "*MASKED**";

my $serverUser = "*MASKED**";
my $serverPass = "**Masked**";
my $dbh = DBI->connect("DBI:mysql:database=$serverDb;host=$serverName;port=$serverPort", $serverUser, $serverPass);

my $i=0;
my @filename = (" ");
my @descriptions = (" ");

if($rstStatus)
{	
	my $sql = "UPDATE GALLERY SET STATUS = 'A' WHERE STATUS = 'S'";
	my $sth = $dbh->prepare($sql);
    $sth -> execute() or die $DBI::errstr;
    $sth->finish();
}

# user response parameters from purchase.plx page
my $offerinput = param ("txtPicasso");
my $usrInput = param("choice"); 

if($usrInput eq "Buy")
{	
	my $statusChgStmt = "UPDATE GALLERY SET STATUS = 'S' WHERE FILENAME = ? ";
	my $cth = $dbh->prepare($statusChgStmt);
	$cth->bind_param(1, $offerinput);
	$cth -> execute() or die $DBI::errstr;
	
	$cth->finish();
}

#update database and push arrays again.
my $sth = $dbh->prepare( "SELECT FILENAME, DESCRIPTION FROM GALLERY WHERE STATUS = 'A'" );
$sth -> execute();

while ( my @row = $sth->fetchrow_array())
{
    push @filename, $row[0];
    push @descriptions, $row[1];
}

print "Content-type: text/html\n\n";
say $html_head;

if(!$username)
{
	say "<a href='http://zenit.senecac.on.ca/~int322_173sa04/cgi-bin/assn3/gallery%20login.plx'; style='float:right;width:150px;'>Login</a>\n";
}
else
{
	say "<input name='txtUserName' readonly value=".$username." style='float:right;border-width:0px'/>";
	say "<script>document.getElementById('imgPicasso').ondblclick = doubleClick;</script>";
}

say "<select name='sltPicasso' style='height: auto; width:300px; color=blue;'>";

foreach (@filename)
{
	say "<option value='".$i."'>".$_."</option>";
	$i++;
}

say "</select><button class='Submitbtn' type='submit' value='Submit'>Submit</button>";
say "<div class='imgFrame' style='float: right;'>";

if ($input)	
{
	say "<img id='imgPicasso' src='../../images/".$filename[$input]."' alt='Image Not Found' />";
	say "<br /><br /><p>Description: ".$descriptions[$input]."</p></div>";
}
else
{
	say "<img id='imgPicasso' src='../../images/PabloPicasso.jpg' alt='Image Not Found' />\n";
	say "<br /><br /><p>Pablo Picasso</p></div>";
}	

if($username)
{
	say"	<script>";
	say " function doubleClick() 	{";
	say " window.location.replace('purchase.plx?selection=$filename[$input]&user=$username');";
	say"	}	";
	say"</script>";
	say "<script>document.getElementById('imgPicasso').ondblclick = doubleClick;</script>";
}

say "</form></body>";
$dbh->disconnect();
