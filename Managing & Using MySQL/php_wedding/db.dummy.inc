<?php


/* Unless  otherwise stated, the  source code distributed  with this book
can   be  redistributed in source    or  binary form   so  long  as an
acknowledgment  appears in derived source   files. The citation should
list  that the  code comes from  "Managing and Using MySQL"  published 
by O'Reilly & Associates.  This    code is under
copyright and  cannot be  included in any other book, publication,  or
educational product without permission from O'Reilly &  Associates. No
warranty  is  attached; we  cannot take responsibility   for errors or
fitness for use. */


// These are the DBMS credentials and the database name
$hostName = "localhost";
$databaseName = "wedding";
$username = "fred";
$password = "shhh";

// Show an error and stop the script
function showerror()
{
   if (mysql_error())
      die("Error " . mysql_errno() . " : " . mysql_error());
   else
      die("Could not connect to the DBMS");
}

// Secure the user data by escaping characters and shortening the input
// string
function clean($input, $maxlength)
{
  $input = substr($input, 0, $maxlength);
  $input = EscapeShellCmd($input);
  return ($input);
}

// Check if the user is logged in. If not, send them to the login
// page
function logincheck()
{
   session_start();

   if (!session_is_registered("user"))
      // redirect to the login page
      header("Location: index.php");
}  
?>
