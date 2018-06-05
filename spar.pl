#!/usr/bin/perl -w
use strict;
use warnings;
use feature qw(switch say); # need this for GIVEN-WHEN block to work
use Tie::IxHash;

# Define 
my $objectid;
my $filename; 
my $addupdate; 
my $inputkey;
my $key;
my $inputvalue;
my $value;
my $hash_ref;
my $inputset;
my $spectypeA;
my $spectypeB;
my $colname1;
my $colname2;
my $colname3;
my @base_stem; 
my @tertiary; 
my $space;

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
tie my %b_v, "Tie::IxHash" or die "could not tie %b_v";
tie my %rotation, "Tie::IxHash" or die "could not tie %rotation";

# Step 1b of 4: Initialize the hashes
# $parallax{plx} = 'null';
# $parallax{plxerr1} = 'null';
# $parallax{plxerr2} = 'null';
# $parallax{plxlim} = 'null';
# $parallax{dist} = 'null';
# $parallax{disterr1} = 'null';
# $parallax{disterr2} = 'null';
# $parallax{distlim} = 'null';
# $parallax{plxblend} = 'null';
# $parallax{plxrefid} = 'null';

# $spectral{sptstr} = 'null';
# $spectral{sptsys} = 'null';
# $spectral{sptlim} = 'null';
# $spectral{sptblend} = 'null';
# $spectral{sptrefid} = 'null';

# $vsini{vsin} = 'null';
# $vsini{vsinerr1} = 'null';
# $vsini{vsinerr2} = 'null';
# $vsini{vsinlim} = 'null';
# $vsini{vsinblend} = 'null';
# $vsini{vsinrefid} = 'null';

# $rv{radv} = 'null';
# $rv{radverr1} = 'null';
# $rv{radverr2} = 'null';
# $rv{radvlim} = 'null';
# $rv{radvblend} = 'null';
# $rv{radvsys} = 'null';
# $rv{radvrefid} = 'null';

# $spar{teff} = 'null';
# $spar{tefferr1} = 'null';
# $spar{tefferr2} = 'null';
# $spar{tefflim} = 'null';
# $spar{logg} = 'null';
# $spar{loggerr1} = 'null';
# $spar{loggerr2} = 'null';
# $spar{logglim} = 'null';
# $spar{met} = 'null';
# $spar{meterr1} = 'null';
# $spar{meterr2} = 'null';
# $spar{metlim} = 'null';
# $spar{metratio} = 'null';
# $spar{lum} = 'null';
# $spar{lumerr1} = 'null';
# $spar{lumerr2} = 'null';
# $spar{lumlim} = 'null';
# $spar{lums} = 'null';
# $spar{lumserr1} = 'null';
# $spar{lumserr2} = 'null';
# $spar{lumslim} = 'null';
# $spar{rad} = 'null';
# $spar{raderr1} = 'null';
# $spar{raderr2} = 'null';
# $spar{radlim} = 'null';
# $spar{mass} = 'null';
# $spar{masserr1} = 'null';
# $spar{masserr2} = 'null';
# $spar{masslim} = 'null';
# $spar{density} = 'null';
# $spar{densityerr1} = 'null';
# $spar{densityerr2} = 'null';
# $spar{densitylim} = 'null';
# $spar{age} = 'null';
# $spar{ageerr1} = 'null';
# $spar{ageerr2} = 'null';
# $spar{agelim} = 'null';
# $spar{sparrefid} = 'null';
# $spar{sparblend} = 'null';
# $spar{plxrefid} = 'null';

# $photometry{photmag} = 'null';
# $photometry{photmagerr} = 'null';
# $photometry{photmaglim} = 'null';
# $photometry{photblend} = 'null';
# $photometry{photband} = 'null';
# $photometry{photrefid} = 'null';


# Step 2a of 4: Prompt the user to enter Object ID
print 'Enter Object ID: ';
$objectid = <STDIN>;
chomp $objectid;


# Step 2b of 4: Prompt the user to pick a filename
print 'Create name of output file: ';
$filename = <STDIN>;
chomp $filename;


# # Step 2c of 4: Prompt the user to enter short description 
# # of updated stellar parameters
# print 'Enter stellar parameter description: ';
# my $description = <STDIN>;
# chomp $description;


# Step 2d of 4: Prompt the user to enter an entry method 
print 'Enter entry method ( add / update / add_def / update_def ): ';
$addupdate = <STDIN>;
chomp $addupdate;


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
print   "BUILD:           6.3\n";
print   "DESCRIPTION:     Stellar/Planetary Parameters Additions and Updates\n";
print   "FILETYPE:        edm\n";
printf ("FILENAME:        %s\n", $filename);
printf ("DATE:            %04d-%02d-%02d %02d:%02d:%02d\n", $year+1900,$mon+1,$mday,$hour,$min,$sec);

# Step 3e of 4: Print header information to file 
print  $fh  "USER:            raymond\n";
print  $fh  "BUILD:           6.3\n";
print  $fh  "DESCRIPTION:     Stellar/Planetary Parameters Additions and Updates\n";
print  $fh  "FILETYPE:        edm\n";
printf $fh ("FILENAME:        %s\n", $filename);
printf $fh ("DATE:            %04d-%02d-%02d %02d:%02d:%02d\n", $year+1900,$mon+1,$mday,$hour,$min,$sec);


# START:
$parallax{plx} = 'null';
$parallax{plxerr1} = 'null';
$parallax{plxerr2} = 'null';
$parallax{plxlim} = 'null';
$parallax{dist} = 'null';
$parallax{disterr1} = 'null';
$parallax{disterr2} = 'null';
$parallax{distlim} = 'null';
$parallax{plxdistblend} = 'null';
$parallax{plxdistrefid} = 'null';

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
$spar{lumlim} = 'null';
$spar{lums} = 'null';
$spar{lumserr1} = 'null';
$spar{lumserr2} = 'null';
$spar{lumslim} = 'null';
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
$photometry{photband} = 'null';
$photometry{photblend} = 'null';
$photometry{photrefid} = 'null';

$b_v{col} = 'null';
$b_v{colerr} = 'null';
$b_v{collim} = 'null';
$b_v{colname} = 'null';
$b_v{colblend} = 'null';
$b_v{colrefid} = 'null';

$rotation{rotp} = 'null';
$rotation{rotperr1} = 'null';
$rotation{rotperr2} = 'null';
$rotation{rotplim} = 'null';
$rotation{rotpblend} = 'null';
$rotation{rotprefid} = 'null';


START:
# Step 4a of 4: Prompt the user to select the stellar parameter set
print "Select the stellar parameter set (a-f): \n";
print "a) parallax         \n";
print "b) spectral         \n";
print "c) vsini            \n";
print "d) radv             \n";
print "e) spar             \n";
print "f) photometry       \n";
print "g) B - V            \n";
print "h) stellar rotation \n";
$inputset = <STDIN>;
chomp $inputset;
given ($inputset) {
   when ('a') { $hash_ref = \%parallax  }
   when ('b') { $hash_ref = \%spectral  }
   when ('c') { $hash_ref = \%vsini     }
   when ('d') { $hash_ref = \%rv        }
   when ('e') { $hash_ref = \%spar      }
   when ('f') { $hash_ref = \%photometry}
   when ('g') { $hash_ref = \%b_v       }
   when ('h') { $hash_ref = \%rotation  }
   default    { die "\n\nNo matching case\n" }
}

# This @base_stem array keeps track of all the base parameter names 
@base_stem = (); # gotta flush the array; otherwise duplicate parameters will be printed 
given ($inputset)
{
    when ('a')
    { 
        push(@base_stem, "plx");
        push(@base_stem, "dist");
    }
    when ('b')
    { 
        # spectral type goes here; but none of the spectral type params were suitable for @base_stem 
    }
    when ('c')
    { 
        push(@base_stem, "vsin");
    }
    when ('d')
    { 
        push(@base_stem, "radv");
    }
    when ('e')
    { 
        push(@base_stem, "mass");
        push(@base_stem, "rad");
        push(@base_stem, "met");
        push(@base_stem, "lum");
        push(@base_stem, "lums");
        push(@base_stem, "teff");
        push(@base_stem, "logg");
        push(@base_stem, "density");
        push(@base_stem, "age");
    }
    when ('f')
    { 
        # photometry goes here; but none of the photometry params were suitable for @base_stem 
    }
    when ('g') 
    {
        # B-V color goes here; but none of the color params were suitable for @base_stem 
    }
    when ('h') 
    {
        # stellar rotation goes here; but none of the stellar rotation parameters were suitable for @base_stem 
        # UPDATE(2018-Jan-08): Solange changed the ingest tool for rotation period and it now accepts asymmetric uncertainties
        push(@base_stem, "rotp");
    }
    default    { die "\n\nNo matching case\n" }
}

@tertiary = (); # gotta flush the array; otherwise duplicate parameters will be printed 
push(@tertiary, "err1");
push(@tertiary, "err2");
push(@tertiary, "lim");

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
    if ( ( $inputkey =~ /^colname$/ ) )
    {
      ( $inputkey, $colname1, $colname2, $colname3 ) = split /\s+/, $str;
      $inputvalue = $colname1." ".$colname2." ".$colname3;
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
# (5/6/2015) UPDATE : All the algorithms for auto-calculating lum or lums 
# were deleted because Solange's new Build 6.2 will now do the auto-calc.  


my @messageArray; # this array will hold all the messages indicating which 
                  # parameter fields were auto-filled. 

# Special autofill algorithm.  The limit flag for the corresponding parameter 
# field in array @myNames will be auto-filled with "0" if that parameter field 
# is not null. 
my @myNames = ('mass', 'age', 'rad', 'met', 'teff', 'logg', 'density');
foreach (@myNames) 
{
# This IF-block will check 1.) that the parameter field has been filled by a real 
# number (e.g. no longer null), and 2.) whether or not the corresponding limit flag 
# is still null.  If the limit flag is still null, then that means I forgot to set 
# it and the algorithm will automatically set it for me.  
  if  ( defined( $hash_ref->{ $_ } ) &&     # this is to account for 'Use of uninitialized value in pattern match' warning 
       $hash_ref->{ $_ } !~ /^null$/ &&     # this checks if the parameter was assigned a value 
       $hash_ref->{ $_.'lim' } =~ /^null$/  # this checks if the limit flag was set (or not set) by me 
      )
  {
    $hash_ref->{ $_.'lim' } = 0; # sets the limit flag to 0 
    my $tempname = "$_".'lim';
#    print "\n$tempname was autofilled with 0\n";
    push( @messageArray, "$tempname was autofilled with 0" );
  }  # end of IF block 
} # end of FOREACH loop 


# Special autofill algorithm 1: Autofill sparblend
if ( defined( $hash_ref->{ sparblend } ) && $hash_ref->{ sparblend } =~ /^null$/ )
{
  $hash_ref->{ sparblend } = 0;
#  print "\nsparblend was autofilled with 0\n";
  push( @messageArray, "sparblend was autofilled with 0" );
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

if ( $hash_ref == \%b_v ) 
{
    print     "#\n";
    print     "# Addition of ( B-V ) stellar colors\n";
    print     "#\n";
    print $fh "#\n";
    print $fh "# Addition of ( B-V ) stellar colors\n";
    print $fh "#\n";
}

if ( $hash_ref == \%rotation ) 
{
    print     "#\n";
    print     "# Addition of stellar rotation period\n";
    print     "#\n";
    print $fh "#\n";
    print $fh "# Addition of stellar rotation period\n";
    print $fh "#\n";
}

# Step 3f of 4: Print the contents of the current selected 
# hash to file and to screen. 
# print     "EDMT | star | $hash_ref->{ objectid } | add |";
# print $fh "EDMT | star | $hash_ref->{ objectid } | add |";
print     "EDMT | star | $objectid | $addupdate |";
print $fh "EDMT | star | $objectid | $addupdate |";
print     "\\\n";
print $fh "\\\n";

foreach my $base ( @base_stem ) 
{
  if ( $hash_ref->{$base} !~ /null/ )
  {
    $space .= (" " x ( 20 - length("$base") - length($hash_ref->{$base}) ) ); 
    print     "$base $space $hash_ref->{$base} |";
    print $fh "$base $space $hash_ref->{$base} |";
    $space = "";
    foreach my $append (@tertiary)
    {
        my $fullname = "$base"."$append";
        $space .= (" " x ( 20 - length("$fullname") - length($hash_ref->{$fullname}) ) ); 
        print     " $fullname $space $hash_ref->{$fullname} |";
        print $fh " $fullname $space $hash_ref->{$fullname} |";
        $space = "";
    }
    print     "\\\n";
    print $fh "\\\n";
  }
}

# while ( my ($key, $value) = each(%$hash_ref) ) {
#     print     "$key $value|";
#     print $fh "$key $value|";
# }

given ($inputset)
{
    when ('a')
    { 
        print     "plxdistblend $hash_ref->{ plxdistblend } | plxdistrefid $hash_ref->{ plxdistrefid } ";
        print $fh "plxdistblend $hash_ref->{ plxdistblend } | plxdistrefid $hash_ref->{ plxdistrefid } ";
    }
    when ('b')
    { 
        print     "sptstr $hash_ref->{ sptstr } | sptlim $hash_ref->{ sptlim } | sptsys $hash_ref->{ sptsys } |\\ \n";
        print $fh "sptstr $hash_ref->{ sptstr } | sptlim $hash_ref->{ sptlim } | sptsys $hash_ref->{ sptsys } |\\ \n";
        print     "sptblend $hash_ref->{ sptblend } | sptrefid $hash_ref->{ sptrefid } ";
        print $fh "sptblend $hash_ref->{ sptblend } | sptrefid $hash_ref->{ sptrefid } ";
    }
    when ('c')
    { 
        print     "vsinblend $hash_ref->{ vsinblend } | vsinrefid $hash_ref->{ vsinrefid } ";
        print $fh "vsinblend $hash_ref->{ vsinblend } | vsinrefid $hash_ref->{ vsinrefid } ";
    }
    when ('d')
    { 
        print     "radvsys $hash_ref->{ radvsys } | radvblend $hash_ref->{ radvblend } | radvrefid $hash_ref->{ radvrefid } ";
        print $fh "radvsys $hash_ref->{ radvsys } | radvblend $hash_ref->{ radvblend } | radvrefid $hash_ref->{ radvrefid } ";
    }
    when ('e')
    { 
        print     "metratio $hash_ref->{ metratio } |\\\n" if ( $hash_ref->{ met } !~ /null/ ); 
        print $fh "metratio $hash_ref->{ metratio } |\\\n" if ( $hash_ref->{ met } !~ /null/ ); 

#        print     "plxrefid $hash_ref->{ plxdistrefid } |\\\n" if ( defined( $hash_ref->{ plxdistrefid } ) && ( $hash_ref->{ plxdistrefid } !~ /null/ ) ); 
#        print $fh "plxrefid $hash_ref->{ plxdistrefid } |\\\n" if ( defined( $hash_ref->{ plxdistrefid } ) && ( $hash_ref->{ plxdistrefid } !~ /null/ ) ); 

        print     "plxrefid $parallax{plxdistrefid} |\\\n" if ( $parallax{plxdistrefid} !~ /null/ ); 
        print $fh "plxrefid $parallax{plxdistrefid} |\\\n" if ( $parallax{plxdistrefid} !~ /null/ ); 

        print     "sparblend $hash_ref->{ sparblend } | sparrefid $hash_ref->{ sparrefid } ";
        print $fh "sparblend $hash_ref->{ sparblend } | sparrefid $hash_ref->{ sparrefid } ";
    }
    when ('f')
    { 
        print     "photmag $hash_ref->{ photmag } | photmagerr $hash_ref->{ photmagerr } | photmaglim $hash_ref->{ photmaglim } | photband $hash_ref->{ photband } |\\ \n";
        print $fh "photmag $hash_ref->{ photmag } | photmagerr $hash_ref->{ photmagerr } | photmaglim $hash_ref->{ photmaglim } | photband $hash_ref->{ photband } |\\ \n";
        print     "photblend $hash_ref->{ photblend } | photrefid $hash_ref->{ photrefid } ";
        print $fh "photblend $hash_ref->{ photblend } | photrefid $hash_ref->{ photrefid } ";

        $hash_ref->{ photmagerr } = 'null'; # There is a bug in my script.  I need to flush the photmagerr parameter so that 
                                            # the value is not carried over into the next iteration when I enter a different 
                                            # value for photmag/photmagerr.  This is particularly a problem if photmagerr is 
                                            # null in the next iteration.  In the new iteration, if photmagerr is null, then 
                                            # the new photmag will be combined with the old photmagerr carried over from the 
                                            # previous iteration.
    }
    when ('g') 
    {
        print     "col $hash_ref->{ col } | colerr $hash_ref->{ colerr } | collim $hash_ref->{ collim } | colname $hash_ref->{ colname } |\\ \n";
        print $fh "col $hash_ref->{ col } | colerr $hash_ref->{ colerr } | collim $hash_ref->{ collim } | colname $hash_ref->{ colname } |\\ \n";
        print     "colblend $hash_ref->{ colblend } | colrefid $hash_ref->{ colrefid } ";
        print $fh "colblend $hash_ref->{ colblend } | colrefid $hash_ref->{ colrefid } ";
    }
    when ('h') 
    {
        print     "rotpblend $hash_ref->{ rotpblend } | rotprefid $hash_ref->{ rotprefid } ";
        print $fh "rotpblend $hash_ref->{ rotpblend } | rotprefid $hash_ref->{ rotprefid } ";
    }
    default
    { die "\n\nNo matching case\n" }
}
print     "\n"; # need to use this so the command prompt displays correctly 
print $fh "\n";


# Step 3g of 3: Print all the messages for the fields that were autofilled. 
print "\n\n";
for ( my $i = 0 ; $i <= $#messageArray ; $i++ )
{
  print "$messageArray[$i]\n";
}
print "\n\n";


# Step 3h of 4: Prompt the user if they wish to enter additional 
# parameter values for a different parameter set. 
print "\nEnter parameter values for a different parameter set (y/n)?\n";
my $choice = <STDIN>;
chomp $choice;
if ( $choice =~ /^y$/ ) 
{
    goto START;
}
exit 0

