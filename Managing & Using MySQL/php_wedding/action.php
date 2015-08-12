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
  // Add or remove a gift from the user's shopping list
  //
  // This script expects two parameters:
  // (1) The $present_id of the present they'd like to reserve 
  //     or remove from their shopping list
  // (2) The $action to carry out: insert or delete
  // It carries out its requested action, and then redirects back
  // to presents.php. This script produces no output.

  // Include the DBMS credentials
  include "db.inc";

  // Check if the user is logged in
  // (this also starts the session)
  logincheck();

  // Secure the user data
  $present_id = clean($present_id, 5);
  $action = clean($action,6);

  // Connect to the MySQL DBMS
  if (!($connection = @ mysql_pconnect($hostName, $username, $password))) 
     showerror();

  // Use the wedding database
  if (!mysql_select_db($databaseName, $connection))
     showerror();

  // LOCK the presents table for writing
  $query = "LOCK TABLE presents WRITE";

  // Run the query
  if (!($result = @ mysql_query($query, $connection)))
     showerror();

  // Create a query to retrieve the gift.
  $query = "SELECT * 
            FROM presents WHERE
            present_id = {$present_id}";

  // Run the query
  if (!($result = @ mysql_query($query, $connection)))
     showerror();

  // Get the matching gift row (there's only one)
  $row = @ mysql_fetch_array($result);

  // Does the user want to add a new item to their shopping list?
  if ($action == "insert")
  {
     // Yes, an insert.

     // Has someone already reserved this? (a race condition)
     if (!empty($row["people_id"]) && $row["people_id"] != $user)
        // Yes. So, record a message to show the user
        $message = "Oh dear... Someone just beat you to that present!";
     else
     {
        // No. So, create a query that reserves the gift for this user
        $query = "UPDATE presents
                  SET people_id = \"{$user}\"
                  WHERE present_id = {$present_id}";

        // Run the query
        if (!($result = @ mysql_query($query, $connection)))
           showerror();

        // Create a message to show the user
        if (mysql_affected_rows() == 1)
           $message = "Reserved the present for you, {$user}";
        else
           $message = "There was a problem updating. Please contact the administrator.";
     }
  }
  else
  {
     // No, it's a delete action.

     // Double-check they actually have this gift reserved
     if (!empty($row["people_id"]) && $row["people_id"] != $user)
        // They don't, so record a message to show the user
        $message = "That's not your present, {$user}!";
     else
     {
        // They do have it reserved. Create a query to unreserve it.
        $query = "UPDATE presents
                  SET people_id = NULL
                  WHERE present_id = {$present_id}";

        // Run the query.
        if (!($result = @ mysql_query($query, $connection)))
           showerror();

        // Create a message to show the user
        if (mysql_affected_rows() == 1)
           $message = "Removed the present from your shopping list, {$user}";
        else
           $message = "There was a problem updating. Please contact the administrator.";
     }
  }

  // UNLOCK the presents table
  $query = "UNLOCK TABLES";

  // Run the query
  if (!($result = @ mysql_query($query, $connection)))
     showerror();

  // Redirect the browser back to presents.php
  header("Location: presents.php?message=" . urlencode($message));
?>
