#!perl

use strict;
use warnings;

use Test::Simple tests => 6;
use lib "/Users/alicelu/Documents/AddressBkOT";
use ContactOT;

#Test Display Function

#Test 1 - Verify
ok(ContactOT->verify("Alice") == 2);

#Test 2 - Reverify
ok(ContactOT->reverify("Alice", "123-456-7890") eq 
   "Name: Alice Lu% Phone: 123-456-7890");

#Test 3 - Display
ok(ContactOT->display("Name: Michelle Zheng") eq 
"Name: Michelle Zheng
Phone: 215-407-6266
Email: zmichelle03\@yahoo.com
Birthday: 10/01/03
Address: 945 West St., Springfield, PA 19064
Relation: Cousin

");

#Test 4 - Get Element                                              
ok(ContactOT->getElement(1) eq "Name");

#Test 5 - Update Element
ok(ContactOT->updateElement("Name: Michelle", "Relation", "Cousin") eq "**Contact successfully updated**\n");

#Test 6 - Delete
ok(ContactOT->delete("Name: Michelle","y") eq "**Contact successfully deleted**\n");
