<?
/*

Unless  otherwise stated, the  source code distributed  with this book
can   be  redistributed in source    or  binary form   so  long  as an
acknowledgment  appears in derived source   files. The citation should
list  that the  code comes from  "Managing and Using MySQL"  published 
by O'Reilly & Associates.  This    code is under
copyright and  cannot be  included in any other book, publication,  or
educational product without permission from O'Reilly &  Associates. No
warranty  is  attached; we  cannot take responsibility   for errors or
fitness for use.

*/
?>
<?php
  // Show the user the available presents and the presents in their shopping
  // list

  // Include the DBMS credentials
  include 'db.inc';

  // Check if the user is logged in
  // (this also starts the session)
  logincheck();

  // Show the user the gifts
  //
  // Parameters:
  // (1) An open $connection to the DBMS 
  // (2) Whether to show the available gifts with the option to add
  //     them to the shopping list ($delete = false) or to show the current
  //     user's shopping list with the option to remove the gifts ($delete = true)
  // (3) The $user name
  function showgifts($connection, $delete, $user) 
  {

    // If we're showing the available gifts, then set up
    // a query to show all unreserved gifts (where people IS NULL)
    if ($delete == false)
       $query = "SELECT * 
                 FROM presents
                 WHERE people_id IS NULL
                 ORDER BY present";
    else
    // Otherwise, set up a query to show all gifts reserved by 
    // this user
       $query = "SELECT * 
                 FROM presents
                 WHERE people_id = \"{$user}\"
                 ORDER BY present";
  
    // Run the query
    if (!($result = @ mysql_query ($query, $connection))) 
       showerror();
  
    // Did we get back any rows?
    if (@ mysql_num_rows($result) != 0) 
    {
       // Yes, so show the gifts as a table
       echo "\n<table border=1 width=100%>";
  
       // Create some headings for the table
       echo "\n<tr>" .
            "\n\t<th>Quantity</th>" .
            "\n\t<th>Gift</th>" .
            "\n\t<th>Colour</th>" .
            "\n\t<th>Available From</th>" .
            "\n\t<th>Price</th>" .
            "\n\t<th>Action</th>" .
            "\n</tr>";
  
       // Fetch each database table row of the results
       while($row = @ mysql_fetch_array($result))
       {
          // Display the gift data as a table row
          echo "\n<tr>" .
               "\n\t<td>{$row["quantity"]}</td>" .
               "\n\t<td>{$row["present"]}</td>" .
               "\n\t<td>{$row["colour"]}</td>" .
               "\n\t<td>{$row["shop"]}</td>" .
               "\n\t<td>{$row["price"]}</td>";
  
          // Should we offer the chance to remove the gift?
          if ($delete == true)
             // Yes. So set up an embedded link that the user can click
             // to remove the gift to their shopping list by running 
             // action.php with action=delete
             echo "\n\t<td><a href=\"action.php?action=delete&amp;" . 
                  "present_id={$row["present_id"]}\">Delete from Shopping list</a>";
          else 
             // No. So set up an embedded link that the user can click
             // to add the gift to their shopping list by running 
             // action.php with action=insert
             echo "\n\t<td><a href=\"action.php?action=insert&amp;" .
                  "present_id={$row["present_id"]}\">Add to Shopping List</a>";
       }
       echo "\n</table>";
    }
    else
    {
       // No data was returned from the query.
       // Show an appropriate message
       if ($delete == false)
          echo "\n<h3><font color=\"red\">No gifts left!</font></h3>";
       else 
          echo "\n<h3><font color=\"red\">Your Basket is Empty!</font></h3>";
    }
  }      
?>
<!DOCTYPE HTML PUBLIC 
   "-//W3C//DTD HTML 4.0 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <title>Sam and Rowe's Wedding Gift Registry</title>
</head>
<body bgcolor=#ffffff>
<?php

  // Secure the user data
  $message = clean($message, 128);

  // If there's a message to show, output it
  if (!empty($message))
     echo "\n<h3><font color=\"red\"><em>{$message}</em></font></h3>";

  // Connect to the MySQL DBMS
  if (!($connection = @ mysql_pconnect($hostName, $username, $password))) 
     showerror();

  // Use the wedding database
  if (!mysql_select_db($databaseName, $connection))
     showerror();

  echo "\n<h3>Here are some gift suggestions</h3>";

  // Show the gifts that are still unreserved
  showgifts($connection, false, $user);

  echo "\n<h3>Your Shopping List</h3>";

  // Show the gifts that have been reserved by this user
  showgifts($connection, true, $user);

  // Show a logout link
  echo "<a href=\"logout.php\">Logout</a>";
?>
</body>
</html>
