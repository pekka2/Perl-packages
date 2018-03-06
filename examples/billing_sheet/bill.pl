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
$file = 'invoice.xlsx';
$language = 'en';
$font = 'Arial Bold';
$heading_font_size = 18;
$content_font_size = 11;
$small_font_size = 8;
$totals_font_size = 13;
$image = '';
my $workbook  = new Excel::Writer::XLSX::Bill($file,
	                                          $language,
	                                          $font,
	                                          $heading_font_size,
	                                          $content_font_size,
	                                          $small_font_size,
	                                          $totals_font_size,
	                                          $image
	                                          );
