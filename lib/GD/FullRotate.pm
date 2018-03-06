package GD::FullRotate;
use strict;
use CGI::Carp qw(fatalsToBrowser);
use GD;
use GD::Image;
use Math::Trig;
use vars '$VERSION';
$VERSION = '1.00';

sub new {
  my ($w2,$h2,$color);
  my ($self,$src,$width,$height,$angle,$transparent,@color) = @_;
  my $lim_angle = $angle <= 180 ? $angle : ($angle - 180);
  if($angle <= 90){
    $w2 = $width * cos(deg2rad($lim_angle)) + $height * sin(deg2rad($lim_angle));
    $h2 = $width * sin(deg2rad($lim_angle)) + $height * cos(deg2rad($lim_angle));
  } else {
    $w2 = $width * sin(deg2rad($lim_angle-90)) + $height * cos(deg2rad($lim_angle-90));
    $h2 = $width * cos(deg2rad($lim_angle-90)) + $height * sin(deg2rad($lim_angle-90));
  }

   $self = new GD::Image($w2,$h2);
   my $x = $w2/2;
   my $y = $h2/2;

   my $background  = $self->colorAllocate($color[0], $color[1], $color[2]);


   if($transparent > 0){
     $self->transparent($background);
   }
   $self->copyRotated($src,$x,$y,0,0,$width,$height,$angle);
  return $self;
}
__END__

=head COPYRIGHT
 Author: Pekka Mansikka, Kittilä, Finland

==head1 HELP

Tällä kirjastolla voi kääntää kuvaa vapaasti annetun asteen verran ja asettaa halutessaan kuvan taustavärin läpinäkyväksi. Läpinäkyvyyden
 käyttäminen edeyttää png-kuvan käyttöä.
Ohje
Syötettävät argumentit
src_dst, src_width, src_height, angle, transparent, @color
Käyttö
Kirjastolle syötetään kuvan koko, käännösaste, läpinäkyvyys (vaihtoehdot: 0 = Ei, 1 = Kyllä), taustaväri syötetään @-taulukossa esim. 
muodossa @color = (255,255,255)

==head2 SYNOPSIS

Example:
---------

use GD;
use CGI::Carp qw(fatalsToBrowser);
use GD::FullRotate;
print "Content-type:text/html\n\n";

my $src =  newFromPng GD::Image("niitty.png");
my ($width,$height) = $src->getBounds();
my $angle = 132;
my @color = (255,255,255);
my $transparent = 1;
my $image = new GD::FullRotate($src,$width,$height,$angle,$transparent,@color);

my $file = "testit.png";
open OUT, '>:raw', $file or die $!;
print OUT $image->png;
close OUT;

system $file;

Fullrotate arguments: src_dst, src_width, src_height, angle, transpernt, @color
This angle is 1-359, transparent is 0 (false) or 1 (true), color in array @color.

==cut