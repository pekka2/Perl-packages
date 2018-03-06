#!C:\Perl64\bin\perl.exe
use GD;
use GD::Frame;
use CGI::Carp qw(fatalsToBrowser);

print "Content-type:image/png\n\n";

my $frame = newFromPng GD::Image("images/frame.png");
my ($width2,$height2) = $frame->getBounds();
my $src = newFromPng GD::Image("images/photo.png");
my ($width,$height) = $src->getBounds();
my $frame_width = 100;
my $image = GD::Frame->clamp($frame,$src,$frame_width,$width,$height,$width2,$height2);

binmode STDOUT;

print $image->png;
