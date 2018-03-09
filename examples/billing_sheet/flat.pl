#!C:\Perl64\bin\perl.exe
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use Data::Dumper;
my $query = new CGI;

print "Content-type:text/html\n\n";
use strict;
use warnings;
use Excel::Writer::XLSX::Bill;

my $file = 'bill-22.xlsx';
my $language = 'fi';
# maxim image size about 235x70 pixels
my $image = 'invoice-logo.jpg';
my $workbook  = Excel::Writer::XLSX::Bill->flat($file,
	                                          $language,
	                                          $image
	                                          );
