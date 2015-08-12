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
// Filename: source.php

print("<HTML>");
print("<HEAD>");
print("<TITLE>Source Code Viewer</TITLE>");
include("style_sheet.php");
print("</HEAD>");
error_reporting(7);

print("<BODY>");
if ($page_url == "") 
{
    print("<H2>PHP Source Code Viewer</H2>");
    print("Type in the File Name to be viewed:<P>"); 
    print("<form method=post action=source.php>");
    print("<input type=text name=page_url><p>");
    print("<TABLE>");
    print("<TR>");
    print("<TD><input name=submit value=Submit type=SUBMIT></TD>");
    print("<TD><input name=reset value=Reset type=RESET></TD>");
    print("</TR>");
    print("</TABLE>");
    print("</form>");

}
else
{
    $page_url = EscapeShellCmd($page_url);
    print("<B>Source of: $page_url</B><BR>");
    print("<HR NOSHADE><FONT SIZE=3>");

    if ($page_url == "action.php" || $page_url == "index.php" || $page_url == "presents.php")
    {
      $page_name = $page_url;
      if (file_exists($page_name)) 
        show_source($page_name);
    }
    else 
        if (is_dir($page_name)) 
           print("<P>Can't show source for a directory.</P>");
        else
             print("Filename Not Found or Not Permitted. Try Again.<P>");

    print("<CENTER><FORM METHOD=\"GET\" ACTION=\"index.html\">");
    print("<INPUT TYPE=\"Submit\" VALUE=\"Back to Index Page\">");
    print("</FORM></CENTER><BR> <P>");
}

print("<HR NOSHADE>");
print("&#169 2002 Hugh E. Williams.<BR>");
print("</BODY>");
print("</HTML>");

?>

