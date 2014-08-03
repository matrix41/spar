#!/usr/bin/perl -w
use strict;
use warnings;
use feature qw(switch say); # need this for GIVEN-WHEN block to work
use Tie::IxHash;

# Define 
my $objectid;
my $inputkey;
my $key;
my $inputvalue;
my $value;
my $hash_ref;
my $inputset;
my $temp;
my $temp1;
my $temp2;
my $temp3;
my $temp4;
my $spectypeA;
my $spectypeB;


# Step 1a of 4: Tie the hashes (ie to preserve insertion order)
# note to self: awk '{printf "$parallax{%s} = \x27null\x27;\n", $1}' star01.input
# note to self: awk '{printf "$spectral{%s} = \x27null\x27;\n", $1}' star02.input
# note to self: awk '{printf "$vsini{%s} = \x27null\x27;\n", $1}' star03.input
# note to self: awk '{printf "$rv{%s} = \x27null\x27;\n", $1}' star04.input
# note to self: awk '{printf "$spar{%s} = \x27null\x27;\n", $1}' star05.input
# note to self: awk '{printf "$photometry{%s} = \x27null\x27;\n", $1}' star06.input
tie my %parallax, "Tie::IxHash" or die "could not tie %hash";
tie my %spectral, "Tie::IxHash" or die "could not tie %hash";
tie my %vsini, "Tie::IxHash" or die "could not tie %hash";
tie my %rv, "Tie::IxHash" or die "could not tie %hash";
tie my %spar, "Tie::IxHash" or die "could not tie %hash";
tie my %photometry, "Tie::IxHash" or die "could not tie %photometry";


# Step 1b of 4: Initialize the hashes
$parallax{plx} = 'null';
$parallax{plxerr1} = 'null';
$parallax{plxerr2} = 'null';
$parallax{plxlim} = 'null';
$parallax{dist} = 'null';
$parallax{disterr1} = 'null';
$parallax{disterr2} = 'null';
$parallax{distlim} = 'null';
$parallax{plxblend} = 'null';
$parallax{plxrefid} = 'null';

$spectral{sptstr} = 'null';
$spectral{sptsys} = 'null';
$spectral{sptlim} = 'null';
$spectral{sptblend} = 'null';
$spectral{sptrefid} = 'null';

$vsini{vsin} = 'null';
$vsini{vsinerr1} = 'null';
$vsini{vsinerr2} = 'null';
$vsini{vsinlim} = 'null';
$vsini{vsinblend} = 'null';
$vsini{vsinrefid} = 'null';

$rv{radv} = 'null';
$rv{radverr1} = 'null';
$rv{radverr2} = 'null';
$rv{radvlim} = 'null';
$rv{radvblend} = 'null';
$rv{radvsys} = 'null';
$rv{radvrefid} = 'null';

$spar{teff} = 'null';
$spar{tefferr1} = 'null';
$spar{tefferr2} = 'null';
$spar{tefflim} = 'null';
$spar{logg} = 'null';
$spar{loggerr1} = 'null';
$spar{loggerr2} = 'null';
$spar{logglim} = 'null';
$spar{met} = 'null';
$spar{meterr1} = 'null';
$spar{meterr2} = 'null';
$spar{metlim} = 'null';
$spar{metratio} = 'null';
$spar{lum} = 'null';
$spar{lumerr1} = 'null';
$spar{lumerr2} = 'null';
$spar{lums} = 'null';
$spar{lumserr1} = 'null';
$spar{lumserr2} = 'null';
$spar{lumlim} = 'null';
$spar{rad} = 'null';
$spar{raderr1} = 'null';
$spar{raderr2} = 'null';
$spar{radlim} = 'null';
$spar{mass} = 'null';
$spar{masserr1} = 'null';
$spar{masserr2} = 'null';
$spar{masslim} = 'null';
$spar{density} = 'null';
$spar{densityerr1} = 'null';
$spar{densityerr2} = 'null';
$spar{densitylim} = 'null';
$spar{age} = 'null';
$spar{ageerr1} = 'null';
$spar{ageerr2} = 'null';
$spar{agelim} = 'null';
$spar{sparrefid} = 'null';
$spar{sparblend} = 'null';
$spar{plxrefid} = 'null';

$photometry{photmag} = 'null';
$photometry{photmagerr} = 'null';
$photometry{photmaglim} = 'null';
$photometry{photblend} = 'null';
$photometry{photband} = 'null';
$photometry{photrefid} = 'null';


# Step 2a of 4: Prompt the user to enter Object ID
do {
    print 'Enter Object ID: ';
    $objectid = <STDIN>;
    chomp $objectid;
} while ( $objectid !~ /\d\d\d\d\d\d\d\d/ );


# Step 2b of 4: Prompt the user to pick a filename
print 'Create name of output file: ';
my $filename = <STDIN>;
chomp $filename;


# # Step 2c of 4: Prompt the user to enter short description 
# # of updated stellar parameters
# print 'Enter stellar parameter description: ';
# my $description = <STDIN>;
# chomp $description;


# Step 3 of 4: Print the hash function out to a file in the correct format 

# Step 3a of 4: Parse time and date 
# sec,     # seconds of minutes from 0 to 61
# min,     # minutes of hour from 0 to 59
# hour,    # hours of day from 0 to 24
# mday,    # day of month from 1 to 31
# mon,     # month of year from 0 to 11
# year,    # year since 1900
# wday,    # days since sunday
# yday,    # days since January 1st
# isdst    # hours of daylight savings time
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();

# Step 3b of 4: Create output filename from time and date elements 
# note to self: use sprintf, not printf. otherwise using printf will 
# return 1 because the 1 is the true return value from printf which 
# gets assigned to $filename after printf has printed the string. 
# my $filename  = sprintf ("spar_%04d-%02d-%02d-%02d-%02d-%02d.edm", $year+1900,$mon+1,$mday,$hour,$min,$sec);

# Step 3c of 4: Create file handle for the output file 
open (my $fh, '>', $filename) or die "Could not open file '$filename' $!\n";

# Step 3d of 4: Print header information to screen 
print   "USER:            raymond\n";
print   "BUILD:           6.1\n";
print   "DESCRIPTION:     Stellar/Planetary Parameters Additions and Updates\n";
print   "FILETYPE:        edm\n";
printf ("FILENAME:        %s\n", $filename);
printf ("DATE:            %04d-%02d-%02d %02d:%02d:%02d\n", $year+1900,$mon+1,$mday,$hour,$min,$sec);

# Step 3e of 4: Print header information to file 
print  $fh  "USER:            raymond\n";
print  $fh  "BUILD:           6.1\n";
print  $fh  "DESCRIPTION:     Stellar/Planetary Parameters Additions and Updates\n";
print  $fh  "FILETYPE:        edm\n";
printf $fh ("FILENAME:        %s\n", $filename);
printf $fh ("DATE:            %04d-%02d-%02d %02d:%02d:%02d\n", $year+1900,$mon+1,$mday,$hour,$min,$sec);


START:
# Step 4a of 4: Prompt the user to select the stellar parameter set
print "Select the stellar parameter set (a-f): \n";
print "a) parallax   \n";
print "b) spectral   \n";
print "c) vsini      \n";
print "d) rv         \n";
print "e) spar       \n";
print "f) photometry \n";
$inputset = <STDIN>;
chomp $inputset;
given ($inputset) {
   when ('a') { $hash_ref = \%parallax  }
   when ('b') { $hash_ref = \%spectral  }
   when ('c') { $hash_ref = \%vsini     }
   when ('d') { $hash_ref = \%rv        }
   when ('e') { $hash_ref = \%spar      }
   when ('f') { $hash_ref = \%photometry}
   default    { die "\n\nNo matching case\n" }
}

# Step 4b of 4: Prompt the user to enter a stellar parameter 
# and corresponding value (do this in an infinite WHILE-loop; 
# type 'quit' to get out of loop)
while (1) {
    print 'Enter stellar parameter and value pair (separated by a space); enter \'quit\' to exit) => ';
    my $str = <STDIN>;
    chomp $str;
    ( $inputkey, $inputvalue ) = split / /, $str;
# This IF-block will handle the case when a spectral type is entered by the user. 
# (A spectral type consists of two parts, thus the need for special handling here.)
# ( 8/2/2014: The code was modified to also handle photband )
    if ( ( $inputkey =~ /^sptstr$/ ) || ( $inputkey =~ /^photband$/ ) )
    {
      ( $inputkey, $spectypeA, $spectypeB ) = split / /, $str;
      $inputvalue = $spectypeA . " " . $spectypeB;
    }
    if ($inputkey eq 'quit') {
        last;
    }

# Step 4c of 4: Error checking.  Make sure the user-input key (inputkey) 
# matches parameter keys in the hash function.  Use WHILE-loop 
# to iterate through the entire hash function. 
    my $match = 0; # this variable flag tracks the matching status
                   # 0 == no match ; 1 == match 
    while ( ($key, $value) = each(%$hash_ref) ) {
#       if ( $inputkey =~ $key  ) { # NO!! This does not do an exact match.
        if ( $inputkey =~ /^$key$/ ) { # YES. This will do an exact match.
            $hash_ref->{ $inputkey } = $inputvalue;
            $match = 1; 
        }
    } # end of inner WHILE-loop 
    if ( $match == 0 ) {
        print "\n";
        print "No match found for input key: $inputkey\n";
        print "\n";
    }
} # end of infinite outer WHILE-loop

# Step 4d of 4: Special algorithm check.  If certain specific parameters 
# are initialized (ie not null), then calculate corresponding 
# values for other related parameters. 

# Algorithm check 1: If lums parameter has a value, then calculate lum parameter.
if ( defined $hash_ref->{ lums } && $hash_ref->{ lums } !~ /^null$/ ) 
{
    my $howmanyA = length( $hash_ref->{ lums } );
    my $howmanyB = length( int( $hash_ref->{ lums } ) );
    my $sigdig = $howmanyA - $howmanyB - 1;
    $temp = log( $hash_ref->{ lums } ) / log(10);
    $hash_ref->{ lum } = sprintf("%.${sigdig}f", $temp);
#    print "lums = ", $hash_ref->{ lums }, " and lum = ", $hash_ref->{ lum };
#    print "\n";
}

# Algorithm check 2: If lumserr1 parameter has a value, then calculate lumerr1 parameter. 
if ( defined $hash_ref->{ lumserr1 } && $hash_ref->{ lumserr1 } !~ /^null$/ ) 
{
#    if ( defined $hash_ref->{ lums } && $hash_ref->{ lums } ne '' ) 
    if ( defined $hash_ref->{ lums } && $hash_ref->{ lums } !~ /^null$/ ) 
    {
        my $howmanyA = length( $hash_ref->{ lumserr1 } );
        my $howmanyB = length( int( $hash_ref->{ lumserr1 } ) );
        my $sigdig = $howmanyA - $howmanyB - 1;
        $temp1 = ( log( $hash_ref->{ lums } + abs( $hash_ref->{ lumserr1 } ) ) - log( $hash_ref->{ lums } ) ) / log(10);
        $hash_ref->{ lumerr1 } = sprintf("%.${sigdig}f", $temp1);
#        print "lumserr1 = ", $hash_ref->{ lumserr1 }, " and lumerr1 = ", $hash_ref->{ lumerr1 };
#        print "\n";
    }
}

# Algorithm check 3: If lumserr2 parameter has a value, then calculate lumerr2 parameter. 
if ( defined $hash_ref->{ lumserr2 } && $hash_ref->{ lumserr2 } !~ /^null$/ ) 
{
#     if ( defined $hash_ref->{ lums } && $hash_ref->{ lums } ne '' ) 
    if ( defined $hash_ref->{ lums } && $hash_ref->{ lums } !~ /^null$/ ) 
    {
        my $howmanyA = length( $hash_ref->{ lumserr2 } );
        my $howmanyB = length( int( abs( $hash_ref->{ lumserr2 } ) ) );
        my $sigdig = $howmanyA - $howmanyB - 2;
        $temp2 = ( log( $hash_ref->{ lums } - abs( $hash_ref->{ lumserr2 } ) ) - log( $hash_ref->{ lums } ) ) / log(10);
        $hash_ref->{ lumerr2 } = sprintf("%.${sigdig}f", $temp2);
#        print "lumserr2 = ", $hash_ref->{ lumserr2 }, " and lumerr2 = ", $hash_ref->{ lumerr2 };
#        print "\n";
    }
}

# Algorithm check 4: If lum parameter has a value, then calculate lums parameter.
if ( defined $hash_ref->{ lum } && $hash_ref->{ lum } !~ /^null$/ && $hash_ref->{ lums } =~ /^null$/ )
{
    my $howmanyA = length( $hash_ref->{ lum } );
    my $howmanyB = length( int( $hash_ref->{ lum } ) );
    my $sigdig = $howmanyA - $howmanyB - 1;
    $temp = 10**( $hash_ref->{ lum } );
    if ( $hash_ref->{ lum } > 4 )
    {
        $hash_ref->{ lums } = sprintf("%.${sigdig}e", $temp);
    }
    else
    {
        $hash_ref->{ lums } = sprintf("%.${sigdig}f", $temp);
    }
    print "Algo check 4: lums = ", $hash_ref->{ lums };
    print " and lum = ",           $hash_ref->{ lum };
    print "\n";
}

# Algorithm check 5: If lumerr1 parameter has a value, then calculate lumserr1 parameter.
if ( defined $hash_ref->{ lumerr1 } && 
 $hash_ref->{ lumerr1 } !~ /^null$/ && 
 $hash_ref->{ lumserr1 } =~ /^null$/ )
{
    if ( defined $hash_ref->{ lum } && $hash_ref->{ lum } !~ /^null$/ )
    {
        my $howmanyA = length( $hash_ref->{ lumerr1 } );
        my $howmanyB = length( int( $hash_ref->{ lumerr1 } ) );
        my $sigdig = $howmanyA - $howmanyB - 1;
        $temp1 = $hash_ref->{ lum } + $hash_ref->{ lumerr1 };
        $temp2 = 10**$temp1;
        $temp3 = 10**( $hash_ref->{ lum } );
        $temp4 = $temp2 - $temp3;

        # if ( $hash_ref->{ lum } > 4 )
        # {
        #     $hash_ref->{ lumserr1 } = sprintf("%.1e", $temp4);
        # }
        # else 
        # {
            $hash_ref->{ lumserr1 } = sprintf("%.${sigdig}f", $temp4);
        # }

        print "\nlumserr1 = ",   $hash_ref->{ lumserr1 };
        print " and lumerr1 = ", $hash_ref->{ lumerr1 };
        print "\n";
    }
}

# Algorithm check 6: If lumerr2 parameter has a value, then calculate lumserr2 parameter.
if ( defined $hash_ref->{ lumerr2 }  && 
 $hash_ref->{ lumerr2 }  !~ /^null$/ && 
 $hash_ref->{ lumserr2 } =~ /^null$/ )
{
    if ( defined $hash_ref->{ lum } && $hash_ref->{ lum } !~ /^null$/ )
    {
        my $howmanyA = length( $hash_ref->{ lumerr2 } );
        my $howmanyB = length( int( abs( $hash_ref->{ lumerr2 } ) ) );
        my $sigdig = $howmanyA - $howmanyB - 2;
        $temp1 = $hash_ref->{ lum } - abs( $hash_ref->{ lumerr2 } );
        $temp2 = 10**$temp1;
        $temp3 = 10**( $hash_ref->{ lum } );
        $temp4 = $temp2 - $temp3;

        # if ( $hash_ref->{ lum } > 4 )
        # {
        #     $hash_ref->{ lumserr1 } = sprintf("%.1e", $temp4);
        # }
        # else
        # {
            $hash_ref->{ lumserr2 } = sprintf("%.${sigdig}f", $temp4);
        # }

        print "\nlumserr2 = ",   $hash_ref->{ lumserr2 };
        print " and lumerr2 = ", $hash_ref->{ lumerr2 };
        print "\n";
    }
}

# Step 3e of 4: Apply the correct stellar parameter set header. 
if ( $hash_ref == \%parallax ) 
{
    print     "#\n";
    print     "# Addition of Parallax/Distance information\n";
    print     "#\n";
    print $fh "#\n";
    print $fh "# Addition of Parallax/Distance information\n";
    print $fh "#\n";
}

if ( $hash_ref == \%spectral ) 
{
    print     "#\n";
    print     "# Addition of Spectral Type information\n";
    print     "#\n";
    print $fh "#\n";
    print $fh "# Addition of Spectral Type information\n";
    print $fh "#\n";
}

if ( $hash_ref == \%vsini ) 
{
    print     "#\n";
    print     "# Addition of V sin (i) information\n";
    print     "#\n";
    print $fh "#\n";
    print $fh "# Addition of V sin (i) information\n";
    print $fh "#\n";
}

if ( $hash_ref == \%rv ) 
{
    print     "#\n";
    print     "# Addition of Radial Velocity information\n";
    print     "#\n";
    print $fh "#\n";
    print $fh "# Addition of Radial Velocity information\n";
    print $fh "#\n";
}

if ( $hash_ref == \%spar ) 
{
    print     "#\n";
    print     "# Addition of Basic Stellar Parameters information\n";
    print     "#\n";
    print $fh "#\n";
    print $fh "# Addition of Basic Stellar Parameters information\n";
    print $fh "#\n";
}

if ( $hash_ref == \%photometry ) 
{
    print     "#\n";
    print     "# Addition of default photometry values\n";
    print     "#\n";
    print $fh "#\n";
    print $fh "# Addition of default photometry values\n";
    print $fh "#\n";
}


# Step 3f of 4: Print the contents of the current selected 
# hash to file and to screen. 
print     "EDMT|star|$objectid|add|";
print $fh "EDMT|star|$objectid|add|";
while ( my ($key, $value) = each(%$hash_ref) ) {
    print     "$key $value|";
    print $fh "$key $value|";
}
print "\n"; # need to use this so the command prompt displays correctly 
print $fh "\n";


# Step 3g of 4: Prompt the user if they wish to enter additional 
# parameter values for a different parameter set. 
print "\nEnter parameter values for a different parameter set (y/n)?\n";
my $choice = <STDIN>;
chomp $choice;
if ( $choice =~ /^y$/ ) 
{
    goto START;
}
exit 0

