#!C:\Perl64\bin\perl.exe
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use Data::Dumper;
my $query = new CGI;

print "Content-type:text/html\n\n";
use strict;
use warnings;
use Excel::Writer::XLSX::Bill;

# Create a new workbook and add a worksheet
my $file = 'bill-22.xlsx';
my $language = 'fi';
my $font = 'Arial Bold';
my $heading_font_size = 18;
my $content_font_size = 11;
my $small_font_size = 8;
my $totals_font_size = 13;
my $image = 'logo2.jpg';
my $workbook  = Excel::Writer::XLSX::Bill->flat($file,
	                                          $language,
	                                          $image
	                                          );
