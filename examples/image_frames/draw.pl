#!C:\Perl64\bin\perl.exe
use GD;
use GD::Frame;
use CGI::Carp qw(fatalsToBrowser);

print "Content-type:image/jpeg\n\n";

my $frame = newFromJpeg GD::Image("images/100.jpg");
my ($width2,$height2) = $src->getBounds();
my $src = newFromJpeg GD::Image("images/photo.jpg");
my ($width,$height) = $src->getBounds();
my $frame_width = 100;
my $image = GD::Frame->draw($frame,$src,$frame_width,$width,$height);

binmode STDOUT;

print $image->jpeg;