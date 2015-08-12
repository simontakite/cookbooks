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

  // Show the user the login screen for the application, or
  // try and log the user in.
  //
  // Three optional parameters:
  // (1) $login name that has been entered into the <form>
  // (2) $password that has been entered into the <form>
  // (3) $message to display

  // Include database parameters
  include "db.inc";

  // Pre-process the user data for security
  $user = clean($user, 30);
  $passwd = clean($passwd, 30);

  // Start a session
  session_start();

  // Has the user entered a username and password?
  if (isset($message) || empty($login) || empty($passwd)) 
  {
    // No, they haven't, so show them a <form>
?>
<!DOCTYPE HTML PUBLIC 
   "-//W3C//DTD HTML 4.0 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <title>Sam and Rowe's Wedding Gift Registry</title>
</head>
<body bgcolor=#ffffff>
<h2>Sam and Rowe's Wedding Gift Registry</h2>
<?php
  // If an error message is stored, show it...
  if (isset($message))
    echo "<h3><font color=\"red\">{$message}</font></h3>";
?>
(if you've not logged in before, make up a username and password)
<form action="index.php" method="POST">
<br>Please enter a username: <input type="text" name="login">
<br>Please enter a password: <input type="password" name="passwd">
<br><input type="submit" value="Log in"> 
</form><br>
<?php require "disclaimer"; ?>
</body>
</html>
<?php
  } else 
  {
    // Connect to the MySQL DBMS - credentials are in the file db.inc
    if (!($connection = @ mysql_pconnect($hostName, $username, $password)))
       showerror();

    // Use the wedding database
    if (!mysql_select_db($databaseName, $connection))
       showerror();

    // Create a query to find any rows that match the username the user entered
    $query = "SELECT people_id, passwd 
              FROM people 
              WHERE people_id = \"{$login}\"";
  
    // Run the query through the connection
    if (!($result = @ mysql_query($query, $connection)))
       showerror();

    // Were there any matching rows?
    if (mysql_num_rows($result) == 0)
    {
       // No. So insert the new username and password into the table
       $query = "INSERT INTO people 
                 SET people_id = \"{$login}\", 
                     passwd    = \"" . crypt($passwd, substr($user, 0, 2)) .  "\"";

       // Run the query
       if (!($result = @ mysql_query($query, $connection)))
          showerror();
    }
    else
    {
       // Yes. So fetch the matching row
       $row = @ mysql_fetch_array($result);

       // Does the user-supplied password match the password in the table?
       if (crypt($passwd, substr($login, 0, 2)) != $row["passwd"])
       {
          // No, so create an error message
          $message = "This user exists, but the password is incorrect. Choose another username, or fix the password.";

          // Now, redirect the browser to the current page
          header("Location: index.php?message=" . urlencode($message));
          exit;          
       }
    }

    // Save the user's login name in the session
    if (!session_is_registered("user"))
       session_register("user");
    $user = $login;

    $message = "Welcome! Please select gift suggestions from the list to add" .
               " to your shopping list!";

    // Everything went ok. Redirect to the presents.php page.
    header("Location: presents.php?message=" . urlencode($message));
  } 
?>
