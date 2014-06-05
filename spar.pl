#!/usr/bin/perl -w
use strict;
use warnings;
use feature qw(switch say); # need this for GIVEN-WHEN block to work

use Tie::IxHash;

# Define 
my $inputkey;
my $key;
my $inputvalue;
my $value;
my $hash_ref;
my $inputset;
my $temp;
my $temp1;
my $temp2;


# Step 1a of 3: Tie the hashes (ie to preserve insertion order)
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


# Step 1b of 3: Initialize the hashes
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


# Step 2a of 3: Prompt the user to select the stellar parameter set
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


# Step 2b of 3: Prompt the user to enter Object ID
print 'Enter Object ID: ';
my $objectid = <STDIN>;
chomp $objectid;


# Step 2c of 3: Prompt the user to enter short description 
# of updated stellar parameters
print 'Enter stellar parameter description: ';
my $description = <STDIN>;
chomp $description;


# Step 2d of 3: Prompt the user to enter a stellar parameter 
# and corresponding value (do this in an infinite WHILE-loop; 
# type 'quit' to get out of loop)
while (1) {
    print 'Enter stellar parameter and value pair (separated by a space); enter \'quit\' to exit) =>';
    print "\n";
    my $str = <STDIN>;
    chomp $str;
    ( $inputkey, $inputvalue ) = split / /, $str;
    if ($inputkey eq 'quit') {
        last;
    }

# Error checking.  Make sure the user-input key (inputkey) 
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


# Step 3 of 3: Print the hash function out to a file in the correct format 

# Step 3a of 3: Parse time and date 
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

# Step 3b of 3: Create output filename from time and date elements 
# note to self: use sprintf, not printf. otherwise using printf will 
# return 1 because the 1 is the true return value from printf which 
# gets assigned to $filename after printf has printed the string. 
my $filename  = sprintf ("spar_%04d-%02d-%02d-%02d-%02d-%02d.edm", $year+1900,$mon+1,$mday,$hour,$min,$sec);

# Step 3c of 3: Create file handle for the output file 
open (my $fh, '>', $filename) or die "Could not open file '$filename' $!\n";

# Step 3d of 3: Print header information to screen 
print   "USER:            raymond\n";
print   "BUILD:           6.1\n";
printf ("DESCRIPTION:     %s\n", $description);
print   "FILETYPE:        edm\n";
printf ("FILENAME:        %s\n", $filename);
printf ("DATE:            %04d-%02d-%02d %02d:%02d:%02d\n", $year+1900,$mon+1,$mday,$hour,$min,$sec);

# Step 3e of 3: Print header information to file 
print  $fh  "USER:            raymond\n";
print  $fh  "BUILD:           6.1\n";
printf $fh ("DESCRIPTION:     %s\n", $description);
print  $fh  "FILETYPE:        edm\n";
printf $fh ("FILENAME:        %s\n", $filename);
printf $fh ("DATE:            %04d-%02d-%02d %02d:%02d:%02d\n", $year+1900,$mon+1,$mday,$hour,$min,$sec);

# Special algorithm check.  If certain specific parameters 
# are initialized (ie not null), then calculate additional 
# values for other related parameters. 
if ( $hash_ref->{ lums } !~ /null/ ) 
{
    $temp = log( $hash_ref->{ lums } ) / log(10);
    $hash_ref->{ lum } = sprintf("%.3f", $temp);
    print "lums = ", $hash_ref->{ lums }, " and lum = ", $hash_ref->{ lum };
    print "\n";
}
if ( ($hash_ref->{ lumserr1 } !~ /null/) && ($hash_ref->{ lums } !~ /null/) ) 
{
    $temp1 = ( log( $hash_ref->{ lums } + $hash_ref->{ lumserr1 } ) - log( $hash_ref->{ lums } ) ) / log(10);
    $hash_ref->{ lumerr1 } = sprintf("%.3f", $temp1);
    print "lumserr1 = ", $hash_ref->{ lumserr1 }, " and lumerr1 = ", $hash_ref->{ lumerr1 };
    print "\n";
}
if ( ($hash_ref->{ lumserr2 } !~ /null/) && ($hash_ref->{ lums } !~ /null/) ) 
{
    $temp2 = ( log( $hash_ref->{ lums } - $hash_ref->{ lumserr2 } ) / log(10) ) - ( log( $hash_ref->{ lums } ) / log(10) );
    $hash_ref->{ lumerr2 } = sprintf("%.3f", $temp2);
    print "lumserr2 = ", $hash_ref->{ lumserr2 }, " and lumerr2 = ", $hash_ref->{ lumerr2 };
    print "\n";
}


# Step 3f of 3: Now output all the planet parameters 
print     "EDMT|star|$objectid|add|";
print $fh "EDMT|star|$objectid|add|";
while ( my ($key, $value) = each(%$hash_ref) ) {
    print     "$key $value|";
    print $fh "$key $value|";
}
print "\n"; # need to use this so the command prompt displays correctly 

exit 0

