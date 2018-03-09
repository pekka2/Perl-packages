#!C:\Perl64\bin\perl.exe
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use Data::Dumper;

print "Content-type:text/html\n\n";
use strict;
use warnings;
use Excel::Writer::XLSX::Bill;

my $file = 'invoice.xlsx';
# This can use english, 'en' and finnish, 'fi', languages.
my $language = 'en';
my $font = 'Arial Bold';
my $heading_font_size = 18;
my $content_font_size = 11;
my $small_font_size = 8;
my $totals_font_size = 13;
# image max size can be about 235x65 pixels
my $image = '';
my $workbook  = Excel::Writer::XLSX::Bill->simple($file,
	                                          $language,
	                                          $font,
	                                          $heading_font_size,
	                                          $content_font_size,
	                                          $small_font_size,
	                                          $totals_font_size,
	                                          $image
	                                          );
