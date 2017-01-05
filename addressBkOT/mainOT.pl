#!/usr/bin/perl
use strict;
use warnings;
use lib"/Users/alicelu/Documents/AddressBkOT";
use ContactOT;

my $person = ContactOT->new();
my $continue = 1;
my ($action, $matched, $matches, $name, $phone, 
    $index, $element, $newInfo, $sure);

while($continue){

#INTRO - GREETINGS
    $action = ContactOT->intro;

#REDIRECT

#---ENTER
    if ( $action == 1){
        print($person->enter);
    }

#---VERIFICATION
    elsif ( $action > 1 and $action < 5){
	print ("Enter contact name: ");
	chomp( $name = <STDIN> );
	$matches = $person->verify( $name );
    
#-------VERIFIED
	if( $matches == 1 ){
	    $matched = "Name: $name";
	}
#-------REVERIFY
	elsif( $matches > 1 ){
	    print("**Multiple matches detected**\n");
	    print("Enter Phone: ");
	    chomp( $phone = <STDIN> );
	    $matched = $person->reverify( $name, $phone );
	}
    }
#---DISPLAY
    if( $action == 2){
	print("\n", $person->display( $matched ));
    }
#---UPDATE
    elsif ( $action == 3){
        $person->updateOptions;
	print("\nEnter element number: ");
        chomp( $index = <STDIN> );
	$element = $person->getElement($index);
	print("Enter new $element: ");
	chomp( $newInfo = <STDIN> );
	print($person->updateElement( $matched, $element, $newInfo ));
    }
#---DELETE
    elsif ( $action == 4){
	print("OK, are you sure? (y|n): ");
	chomp( $sure = <STDIN> );
        print($person->delete( $matched, $sure ));
    }
#---EXIT
    elsif ($action == 5){
        print("Goodbye\n");
        $continue = 0;
        last;
    }
#---CONTINUE
    print("Continue? (y|n): ");
    chomp(my $answer = <STDIN>);
    unless($answer eq "Y" || $answer eq "y"){
        print("Goodbye\n");
        $continue = 0;
    }
}
