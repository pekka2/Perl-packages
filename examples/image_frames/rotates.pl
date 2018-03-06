#!C:\Perl64\bin\perl.exe
use GD;
use CGI::Carp qw(fatalsToBrowser);
use GD::FullRotate;
print "Content-type:text/html\n\n";

my $src =  newFromPng GD::Image("images/photo.png");
my ($width,$height) = $src->getBounds();

my $angle = 132;
my @color = (255,255,255);
my $transparent = 1;
my $image = new GD::FullRotate($src,$width,$height,$angle,$transparent,@color);

my $file = "test.png";
open OUT, '>:raw', $file or die $!;
print OUT $image->png;
close OUT;

system $file;
