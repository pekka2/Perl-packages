package GD::Frame;
use GD;
use GD::Image;
use GD::FullRotate;
use GD::Polygon;
use CGI::Carp qw(fatalsToBrowser);

use strict;
use vars '$VERSION';
$VERSION = '1.00';

sub draw{
    my ($self,$frame_part,$src,$fwidth,$width,$height) = @_;
    my $x = 0;
    my $y = 0;
    my $count = 2*$fwidth;
    my $new_width = $width + $count;
    my $new_height = $height + $count;
    my $x2 = $new_width;
    my $y2 = $new_height;
    my $self = new GD::Image($new_width, $new_height);

    my $back = $self->colorAllocate(0,0,0);
    my $i = 0;
    my $index = @_;
    my ($r,$g,$b,$col);

    while($i < $fwidth){
        $index = $frame_part->getPixel(0,$i);
        ($r,$g,$b) = $frame_part->rgb($index);
        $col = $self->colorAllocate($r,$g,$b);
        $self->rectangle($x,$y,$x2,$y2,$col);
        $x++;
        $y++;
        $x2--;
        $y2--;
        $i++;
    }

    $self->copyResized($src,$fwidth,$fwidth,0,0,$width,$height,$width,$height);

    return $self;
}
sub clamp{
    my ($self,$frame,$src,$fwidth,$width,$height,$width2,$height2) = @_;
    my $x = 0;  my $y = 0;
    my $count = 2*$fwidth;
    my $new_width = $width + $count;
    my $new_height = $height + $count;

    my ($pros,$width3,$c1,$c2,$polygon,$polygon2,$polygon3,$polygon4);
    my $self = new GD::Image($new_width, $new_height);
     my $back = $self->colorAllocate(100,100,100);
    if($height2 > $fwidth){
       $c1 = $fwidth/$height2;
       $pros = $c1*100;
       $c2 = $pros*$width2;
       $width3 = $c2/100;
    }
    if($height2 <= $fwidth){
       $width3 = $width2;
    }

    my $x2 = $new_width-$fwidth;
    my $x3 = 0;
    my $y3 = $new_height-$fwidth;
    my $cx = int $src->width / 2;
    my $cy = int $src->height /2;
    # top
       $self->copyResized($frame,$x,$y,0,0, $width3,$fwidth,$width2,$height2);
    # bottom
    my @color = (170,170,170);
    my $bottom = GD::FullRotate->new($frame,$width2,$height2,180,0,@color);
       $self->copyResized($bottom,$x3,$y3,0,0,$width3,$fwidth,$width2,$height2);
    # left
    my $left = new GD::Image($width3, $fwidth);
    my $white = $left->colorAllocate(230,230,230);
       $left->copyResized($bottom,0,0,0,0,$width3,$fwidth,$width2,$height2);
    my $vasen = GD::FullRotate->new($left,$width3,$fwidth,90,0,@color);

        $polygon = new GD::Polygon;
        $polygon->addPt(0,0);
        $polygon->addPt($fwidth,0);
        $polygon->addPt(0,$fwidth);

        $vasen->filledPolygon($polygon,$white);

        $polygon2 = new GD::Polygon;
        $polygon2->addPt(0,$y3);
        $polygon2->addPt($fwidth,$new_height);
        $polygon2->addPt(0,$new_height);

        $vasen->filledPolygon($polygon2,$white);
        $vasen->transparent($white);

        $self->copyResized($vasen,$x2,0,0,0,$fwidth,$width3,$fwidth,$width3);
    # right
    my $right = new GD::Image($width3, $fwidth);
    my $white2 = $right->colorAllocate(230,230,230);
       $right->copyResized($frame,0,0,0,0,$width3,$fwidth,$width2,$height2);
    my $oikea = GD::FullRotate->new($right,$width3,$fwidth,90,0,@color);

        $polygon3 = new GD::Polygon;
        $polygon3->addPt(0,0);
        $polygon3->addPt($fwidth,0);
        $polygon3->addPt($fwidth,$fwidth);

        $oikea->filledPolygon($polygon3,$white2);

        $polygon4 = new GD::Polygon;
        $polygon4->addPt(0,$new_height);
        $polygon4->addPt($fwidth,$y3);
        $polygon4->addPt($fwidth,$new_height);

        $oikea->filledPolygon($polygon4,$white2);
        $oikea->transparent($white2);
        $self->copyResized($oikea,0,0,0,0,$fwidth,$width3,$fwidth,$width3);

    $self->copyResized($src,$fwidth,$fwidth,0,0,$width,$height,$width,$height);

    return $self;
}
__END__


=head COPYRIGHT

 Author: Pekka Mansikka, Kittilä, Finland

==head1 HELP

Tällä kirjastolla voi tehdä kuvaan kehyksen kopioimalla kehyksen värin pikkukuvasta tai kopioimalla kehyksen kuvana.
Kirjaston käyttämät metodit draw ja clamp. Jälkimmäinen vaatii png-kuvan käyttöä. Tämä käyttää toista tekemääni kirjastoa GD::FullRotate,
joka täytyy ensin olla asennettuna.

GD::Frame->draw

Metodin draw käyttäminen:

Tämän metodin käyttöön tarvitsen pikkukuvan, joka on esim. kooltaan 1x100 pikseliä (voi olla myös leveämpi). Pikkukuvan korkeuden tulee olla
vähintään se, minkä määrität kehyksen leveydeksi.

Kirjaston toiminta (”sinun selkäsi takana tapahtuvaa”) metodissa draw

Kirjasto ottaa värin silmukassa pikkukuvan vasemmasta reunasta. Silmukoiden määrä on sama kuin asettamasi kehyksen leveys pikseleissä.
Jokaisessa silmukassa metodi piirtää neliskulmaisen kuvion sen värin mukaan, mikä kyseisen silmukan kohdalla sattuu olemaan pikkukuvassa. Kuvion
 koko pienenee tasaisesti jokaisessa silmukassa.

Argumentit metodille draw
frame_dst, src_dst, frame_width, src_width, src_height


GD::Frame->clamp

Metodin clamp käyttäminen:

Tämän käyttö on haasteellisempaa, sillä ensin täytyy luoda kuva kehyksestä, joka halutaan liittää kuvalle. Luotavan kehyksen kuvan on suotavaa 
olla vähintään esim. 200x6000 pikseliä. Mikäli käytät hyvin suuria kuvia, luotavan kehyksen kuvan tulee olla huomattavasti suurempi, sillä mitä 
suurempi kehystettävä kuva on, sitä leveämpi kehyksen tulee olla, jotta kehystyksestä tulisi hyvän näköinen. Tallenna luotava kehyksen kuva 
png-muodossa. Kehyksen kuvan tulee olla vaakaasennossa siten, että kehyksen sisäreuna on alaspäin. Luotavan kehyksen kuvaan kannattaa lisätä 
kehykselle riittävästi pituutta suhteessa sen leveyteen.
Kehyksen kuvan luomisen jälkeen tämän käyttö sinänsä on hyvin yksinkertaista. Sinun tarvitsee komennolla newFromPng poimia kehyksen kuva sekä 
kehystettävä kuva ja poimia molempien koko getBounds komennolla. Nämä tiedot sekä kehyksen leveys sinun tulee syöttää metodille clamp.

Argumentit metodille clamp
frame_dst, src_dst, frame_width, src_width, src_height, frame_src_width, frame_src_height

Kirjaston toiminta (”sinun selkäsi takana tapahtuvaa”) metodissa clamp

Ensin metodissa luodaan uusi kuva, joka on kehyksen vaativan verran alkuperäistä kuvaa suurempi. Sen jälkeen poimitaan ylös kehyksen kuvan
koko ja pienennetään sitä tarvittaessa asetettuun kehysleveyteen.
Aluksi asetetaan yläkehys, sen jälkeen alakehys kääntämällä sitä 180 astetta. Sivukehyksiä samoin ensin pinenennetään ja käännetään.
Ennen sivukehysten liittämistä pääkuvaan niiden molempiin päihin tehdään suorakulmaisen kolmion muotoinen alue (tämä alue piirretään ja 
täytetään värillä filledPolygon komennolla) ja muutetaan tämä alue läpinäkyväksi, jolla siitä tulee normaalin manuaalisen kehystetyn kuvan näköinen.

Virheet

Liian lyhyt kehyksen kuva voi aiheuttaa sen virheen, että kehyksen pituus loppuu kesken. Tämän voi korjata joko suurentamalla kehykselle 
leveyttä muttujassa $frame_width tai muokkaamalla kehyksen kuvaa.


==head2 SYNOPSIS


draw

Skript example:

use GD;
use GD::Frame;
use CGI::Carp qw(fatalsToBrowser);

print "Content-type:image/jpeg\n\n";

my $frame = newFromJpeg GD::Image("frame_image.jpg");
my ($width2,$height2) = $src->getBounds();
my $src = newFromJpeg GD::Image("niitty.jpg");
my ($width,$height) = $src->getBounds();
my $frame_width = 100;
my $image = GD::Frame->draw($frame,$src,$frame_width,$width,$height);

In variable &frame is small image "frame model", this small image size can be eg. 1x100 pixels (if you are think do frame width 100px).
Small image height must be at least same, when your frame width in variable $frame_width.


clamp


Skript example:
use GD;
use GD::Frame;
use CGI::Carp qw(fatalsToBrowser);

print "Content-type:image/png\n\n";

my $frame = newFromPng GD::Image("antik.png");
my ($width2,$height2) = $frame->getBounds();
my $src = newFromPng GD::Image("niitty.png");
my ($width,$height) = $src->getBounds();
my $frame_width = 100;

my $image = GD::Frame->clamp($frame,$src,$frame_width,$width,$height,$width2,$height2);

This image must do from png image, this need use transparent color. Fist in variable $frame start image from frame, this frame image size can be eg. 200x6000 pixels.
If your original image in variable $src is remarkably large, frame image must be yet bigger.
This to method clamp give attributes frame_dst, src_dst, frame_width,src_widh,src_height,frame_img_width,frame_img_height
This method use package GD::FullRotate, it must be install at first.

==cut
