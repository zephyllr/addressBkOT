#!/usr/bin/perl

package ContactOT;
use strict;
use warnings;

#===========================================
#DEFINED VARIABLES


my @elements = qw( Name Phone Email Birthday Address Relation);
my $element;

my @infoEles = ( "Name (First Last)", "Phone (123-456-7890)", "Email (you\@server.com)", "Birthday (MM/DD/YY)", "Address (HouseNum Street, City, State ZIP)", "Relation(eg. Friend)");
my $infoEle;

#===========================================
#BLESSING
sub new{

    my $class = shift;
    my $person = {
        Name => shift,
        Phone => shift,
        Email => shift,
        Birthday => shift,
        Address => shift,
        Relation => shift,
    };
    bless $person, $class;
    return $person;
}

#===========================================
#INTRO - GREETINGS
sub intro{

    print "\n";
    print "Welcome to your personal address book!\n
    What would you like to do today?\n
    1. Enter new contact
    2. Display contact
    3. Update existing contact
    4. Delete contact
    5. Exit\n";

    print "\nEnter command number: ";
    chomp(my $action = <STDIN>);
    print "\n";
    return $action;
}

#===========================================
#ENTER NEW CONTACT
sub enter{

    my ( $person ) = @_;
    my $i = 0;    
    my $success = 0;

    open TEXT, ">>listOT.txt" or die "Can't open file!";

    foreach $infoEle(@infoEles) {
        print("Enter $infoEle: ");
        my $entered;
        chomp($entered = <STDIN>);
        $person->{$elements[$i]} = $entered if defined($entered);
        print TEXT "$elements[$i]: " . 
	    $person->{$elements[$i]} . "\% ";
        $i++;
    }

    print TEXT "\n";
    $success = "**Contact Successfully Registered**\n";
    close TEXT;
    return $success;
}

#===========================================
#VERIFY EXISTING CONTACT
sub verify{

    my ( $person, $name) = @_;
    my $matches = 0;
    my $matched;

    open TEXT, "<listOT.txt" or die "Can't open file!";

    while(<TEXT>){
        if($_ =~ /^Name: $name\b/i){
            $matched = $&;
            $matches ++;
        }
    }
    if($matches == 0){
        die("**Contact name does not exist**");
    }
  
    close TEXT;
    return $matches;
}
#=========================================== 
#REVERIFY EXISTING CONTACT
sub reverify{

    my ( $person, $name, $phone) = @_;
    my ($matched, $matched2);
    open TEXT, "<listOT.txt" or die "Can't open file!";

    while(<TEXT>){
        if($_ =~ /^Name: $name.*$phone\b/i){
            $matched = $&;
            $matched2 = 1;
            close TEXT;
            return $matched;
        }
    }
    unless($matched2){
        die("**Contact phone number does not exist**");
    }
    close TEXT;
}

#===========================================
#SEARCH EXISTING CONTACT
sub display{

    my ( $person, $matched) = @_;
    my $newField = "";

    open TEXT, "<listOT.txt" or die "Can't open file!";

    while(<TEXT>){
        if($_ =~ /^$matched\b/i){
            my @field = split /% /, $_;
            my $newField = join "\n", @field;

            return $newField;
            last;
        }
    }
    close TEXT;
}

#===========================================
#UPDATE - OPTIONS
sub updateOptions{

    my ( $person, $matched ) = @_;
    my $num = 1;

    print("Which element do you want to update:\n\n");
    foreach $element( @elements ){
        print("\t", "$num. $element\n");
        $num += 1;
    }
}
#===========================================
#UPDATE - GET ELEMENT
sub getElement{
    
    my( $person, $index ) = @_;
    $element = $elements[$index - 1];
    return $element;
}

#===========================================
#UPDATE EXISTING CONTACT
sub updateElement{

    my ( $person, $matched, $element, $newInfo) = @_;                          
    my @newLines;
    my $success = 0;
    open IN, "<listOT.txt" or die "Can't open file!";
    my @oldLines = <IN>;
    close IN;

    foreach(@oldLines){
        if(/^$matched/i){
            $_ =~ s/$element: .*?\%/$element: $newInfo\%/;
	    $success = "**Contact successfully updated**\n";
        }
        push(@newLines, $_);
    }

    open IN, ">listOT.txt" or die "Can't open file!";
    print IN @newLines;
    close IN;
    return $success;
}

#===========================================
#DELETING EXISTING CONTACT

sub delete{

    my ($person, $matched, $sure) = @_;
    my $element = $_[1];
    my @newLines;
    my $success = 0;

    open IN, "<listOT.txt" or die "Can't open file!";
    my @oldLines = <IN>;
    close IN;

    if($sure eq "Y" || $sure eq "y"){
        foreach(@oldLines){
            if(/^$matched\b/i){
                $_ = '';
                $success = "**Contact successfully deleted**\n";
            }
            push(@newLines, $_);
        }
    }
    else{
        die "**Delete cancelled**";
    }

    open IN, ">listOT.txt" or die "Can't open file!";
    print IN @newLines;
    close IN;

    return $success;
}
#===========================================
1;
