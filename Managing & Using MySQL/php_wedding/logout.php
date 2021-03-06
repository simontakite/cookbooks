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
  // Logout of the system

  // Include database parameters
  include "db.inc";

  session_start();
  session_destroy();

  // Redirect to the confirmation page.
  header("Location: logout.html");
?>
