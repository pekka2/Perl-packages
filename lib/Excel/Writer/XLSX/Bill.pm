package Excel::Writer::XLSX::Bill;

use strict;
use warnings;
use Excel::Writer::XLSX;
use vars '$VERSION';
$VERSION = '1.0';
use utf8;
use CGI;
use CGI::Carp qw(fatalsToBrowser);

sub new {
my ($self,$xlsx,$language,$font,$hsize,$csize,$ssize,$tsize,$image) = @_;
my ($wb,$ws,$left,$right,$left_bold,$left_top,$center);
my ($client,$head,$totals,$content_rows,$shape_2,$shape_3,$shape_short_3,$shape_wide);
$wb  = Excel::Writer::XLSX->new( $xlsx );
$self = $wb->add_worksheet();
# Add Page Styles of Invoice
# Normal text size to left or center
$left = $wb->add_format( 'align' => 'left','font' => $font,'size' => $csize);
$center = $wb->add_format( 'align' => 'center','font' => $font,'size' => $csize);
$right = $wb->add_format( 'align' => 'right','font' => $font,'size' => $csize);
# Small texr to row top
$left_top = $wb->add_format( 'align' => 'left','valign' => 'top','font' => $font,'size' => $ssize );
# Big header text
$head = $wb->add_format( 'align' => 'left','bold' => 1,'font' => $font,'size' => $hsize);
# Normal text to row top
$client = $wb->add_format( 'align' => 'left','valign' => 'top', 'bold' => 1,'font' => $font,'size' => $csize );
# Total text style to right
$totals = $wb->add_format('bold' => 1,'font' => $font, 'size' => $tsize,'align' => 'right');
# Bill content rows
$content_rows = $wb->add_format( 'align' => 'left', 'font' => $font, 'align' => 'right', 'size' => $csize);

$self->merge_range( 'A1:E3', '', $left );
if($image){
  $self->insert_image( 0,0,$image,2,8 );
} else {	
   if($language eq 'en'){
      $self->write( 0, 0, "Company Ltd", $head );
   }
   if($language eq 'fi'){
      $self->write( 0, 0, "Yritys Oy", $head );
   }
}

$self->merge_range( 'A4:E5', '', $left );
if($language eq 'en'){
  $self->write( 3, 0, " Street 15\n 99100 City", $left );
  $self->merge_range( 'F1:K2', '', $left );
  $self->write( 0, 5, "Invoice", $head );
}
if($language eq 'fi'){
  $self->write( 3, 0, " Ollilanojantie 15\n 99100 Kittilä", $left );
  $self->merge_range( 'F1:K2', '', $left );
  $self->write( 0, 5, "LASKU", $head );
}

# Oikea ylärivi

$shape_2 = $wb->add_shape(
    type   => 'rect',
    width  => 128,
    height => 40, 
);
$shape_3 = $wb->add_shape(
    type   => 'rect',
    width  => 192,
    height => 40, 
);

$self->merge_range( "F5:H5", '', $left );
$self->insert_shape( 'F4', $shape_2,0,0 );

# Texts to top-right
if($language eq 'fi'){
   $self->write( 'F4', " Laskun päiväys", $left_top );
}
if($language eq 'en'){
   $self->write( 'F4', " Invoice date:", $left_top );
}

$shape_short_3 = $wb->add_shape(
    type   => 'rect',
    width  => 190,
    height => 40,
);

$self->merge_range( "H5:J5", '', $left );
$self->insert_shape( 'H4', $shape_short_3,0,0 );
if($language eq 'fi'){
    $self->write( 'H4', " Viivästyskorko", $left_top );
}
if($language eq 'en'){
    $self->write( 'H4', " Late payment interest:", $left_top );
}
#  Oikea toinen rivi
$self->merge_range( "F7:G7", '', $left );
$self->insert_shape( 'F6', $shape_2,0,0 );
if($language eq 'fi'){
    $self->write( 'F6', " Laskun numero", $left_top );
}
if($language eq 'en'){
    $self->write( 'F6', " Invoice no:", $left_top );
}

$self->merge_range( "H7:J7", '', $left );
 $self->insert_shape( 'H6', $shape_short_3,0,0 );
if($language eq 'fi'){
    $self->write( 'H6', " Asiakkaan Y-tunnus", $left_top );
}
if($language eq 'en'){
    $self->write( 'H6', " Business ID:", $left_top );
}

# Oikea kolmas rivi
$self->merge_range( "F9:G9", '', $left );
$self->insert_shape( 'F8', $shape_2,0,0 );
if($language eq 'fi'){
    $self->write( 'F8', " Maksuehto", $left_top );
}
if($language eq 'en'){
    $self->write( 'F8', " Payment terms:", $left_top );
}

$self->merge_range( "H9:J9", '', $left );
$self->insert_shape( 'H8', $shape_short_3,0,0 );
if($language eq 'fi'){
    $self->write( 'H8', " Viitteemme", $left_top );
}
if($language eq 'en'){
    $self->write( 'H8', " Our reference:", $left_top );
}

# Oikea neljäs rivi
$self->merge_range( "F11:G11", '', $left );
$self->insert_shape( 'F10', $shape_2,0,0 );
if($language eq 'fi'){
    $self->write( 'F10', " Eräpäivä", $left_top );
}
if($language eq 'en'){
    $self->write( 'F10', " Due Date:", $left_top );
}

$self->merge_range( "H11:J11", '', $left );
$self->insert_shape( 'H10', $shape_short_3,0,0 );
if($language eq 'fi'){
    $self->write( 'H10', " Viitteenne", $left_top );
}
if($language eq 'en'){
    $self->write( 'H10', " Your reference:", $left_top );
}

# Oikea alin rivi
my $shape = $wb->add_shape(
    type   => 'rect',
    width  => 318,
    height => 40,
);
$self->merge_range( "F13:J13", '', $left );

$self->insert_shape( 'F12', $shape,0,0 );
if($language eq 'fi'){
    $self->write( 'F12', " Toimitusehto", $left_top );
    $self->write( 'F13', " Vapaasti varastosta", $csize );
}
if($language eq 'en'){
    $self->write( 'F12', " Delivery terms:", $left_top );
    $self->write( 'F13', " Free from stock", $csize );
}

# Lisätietoja
$shape_wide = $wb->add_shape(
    type   => 'rect',
    width  => 638,
    height => 41,
);

$self->insert_shape( 'A15', $shape_wide,0,0 );
if($language eq 'fi'){
    $self->write( 'A15', " Lisätietoja", $left_top );
}
if($language eq 'en'){
    $self->write( 'A15', " More information:", $left_top );
}


$self->merge_range( "A7:E7", '', $client );

# Asikastiedot
if($language eq 'fi'){
    $self->write( 'A7', " Asiakkaan Yritys Oy", $client );
}
if($language eq 'en'){
    $self->write( 'A7', " Customer Company Ltd", $client );
}

$self->merge_range( "A8:E8", '', $left_top );
if($language eq 'fi'){
    $self->write( 'A8', " Asiakkaantie 10", $left );
}
if($language eq 'en'){
    $self->write( 'A8', " Street 10", $left );
}
$self->merge_range( "A10:E10", '', $left );
$self->merge_range( "A9:E9", ' ', $left );
$self->write( 'A10', " 123456 City", $left );
$self->merge_range( "A11:E11", '', $left );
$self->merge_range( "A12:E12", '', $left );


$self->merge_range( "A16:K16", '', $left );

my $shape_five = $wb->add_shape(
    type   => 'rect',
    width  => 192,
    height => 20,
);

$self->insert_shape( 'A18', $shape_five,0,0 );
if($language eq 'fi'){
    $self->write( 'A18', " Nimike", $left );
}
if($language eq 'en'){
    $self->write( 'A18', " Title", $left );
}


my $shape0 = $wb->add_shape(
    type   => 'rect',
    width  => 64,
    height => 20,
);

my $shape0b = $wb->add_shape(
    type   => 'rect',
    width  => 128,
    height => 20,
);

$self->insert_shape( 'D18', $shape0,0,0 );
if($language eq 'fi'){
    $self->write( 'D18', " Määrä", $center );
}
if($language eq 'en'){
    $self->write( 'D18', " Qty", $center );
}


$self->insert_shape( 'E18', $shape0,0,0 );
if($language eq 'fi'){
    $self->write( 'E18', " Yks", $center );
}
if($language eq 'en'){
    $self->write( 'E18', " Sing.", $center );
}


$self->insert_shape( 'F18', $shape0,0,0 );
if($language eq 'fi'){
    $self->write( 'F18', " A-hinta", $center );
}
if($language eq 'en'){
    $self->write( 'F18', " A-price", $center );
}

$self->insert_shape( 'G18', $shape0b,0,0 );

$self->merge_range( 'G18:H18', '',$totals );
if($language eq 'fi'){
    $self->write( 'G18', " Alv 24%", $center );
}
if($language eq 'en'){
    $self->write( 'G18', " VAT 20%", $center );
}

my $shape9 = $wb->add_shape(
    type   => 'rect',
    width  => 128,
    height => 20,
);

$self->insert_shape( 'I18', $shape9,0,0 );
$self->merge_range( 'I18:J18', '',$center );
if($language eq 'fi'){
    $self->write( 'I18', "Verollinen hinta ", $center );
}
if($language eq 'en'){
    $self->write( 'I18', "Price with tax ", $center );
}


my $shape_left = $wb->add_shape(
    type   => 'rect',
    width  => 192,
    height => 300,
);

my $start = 19;
my $i = 18;
my $end = 33;
for ( $i .. $end ){
   $self->merge_range( "A$start:C$start", '', $left );
   $self->write( 9, $i, " ", $left );
   $start++;
   $i++;
}

$self->insert_shape( 'A19', $shape_left,0,0 );

my $shape_narrow = $wb->add_shape(
    type   => 'rect',
    width  => 64,
    height => 300,
    
);
my $shape_narrow_128 = $wb->add_shape(
    type   => 'rect',
    width  => 128,
    height => 300,
);

$self->insert_shape( 'D19', $shape_narrow,0,0 );
$self->insert_shape( 'E19', $shape_narrow,0,0 );
$self->insert_shape( 'F19', $shape_narrow,0,0 );
$self->insert_shape( 'G19', $shape_narrow_128,0,0 );

my $start2 = 19;
my $i = 18;
my $end2 = 33;
for ( $i .. $end2 ){
   $self->merge_range( "H$start2:I$start2", '', $content_rows );
   $self->write( 7, $i, " ", $content_rows);
   $start2++;
   $i++;
}

# Laskun oikea sarake
my $shape12 = $wb->add_shape(
    type   => 'rect',
    width  => 128,
    height => 300,
);

$self->insert_shape( 'I19', $shape12,0,0 );

my $start2 = 19;
my $i = 18;
my $end2 = 33;
for ( $i .. $end2 ){
   $self->merge_range( "I$start2:J$start2", '', $content_rows );
   $self->write( 9, $i, " ", $content_rows);
   $start2++;
   $i++;
}

$self->merge_range( 'A35:H37', '', $totals );
if($language eq 'fi'){
    $self->write( 'A35', "Veroton yhteensä EUR:\n ALV 24 % yhteensä EUR:\nMaksettava yhteensä EUR:", $totals );
}
if($language eq 'en'){
    $self->write( 'A35', "Sub total €:\n VAT 24 % €:\nTotal €:", $totals );
}

$self->merge_range( 'I35:J35', '',$totals );
$self->write( 'J35', " ",$totals );
$self->merge_range( 'I36:J36', '',$totals );
$self->write( 'J36', " ",$totals );
$self->merge_range( 'I37:J37', '',$totals );
$self->write( 'I37', " ",$totals );

my $shape13 = $wb->add_shape(
    type   => 'rect',
    width  => 256,
    height => 40,
);
my $shape14 = $wb->add_shape(
    type   => 'rect',
    width  => 256,
    height => 60,
);

$self->insert_shape( 'A39', $shape13,0,0 );

$self->merge_range( 'A39:D39', ' IBAN',$left_top );
$self->merge_range( 'A40:D40', '',$left );
$self->write( 'A40', " FI23 12345678", $left );

$self->insert_shape( 'A41', $shape13,0,0 );

$self->merge_range( 'A41:D41', '',$left_top );
$self->merge_range( 'A42:D42', '',$left );
if($language eq 'fi'){
    $self->write( 'A41', " Viitenumero", $left_top );
}
if($language eq 'en'){
    $self->write( 'A41', " Reference no:", $left_top );
}
$self->write( 'A42', " 12345678", $left );


$self->merge_range( 'A43:D43', '',$left_top );
$self->merge_range( 'A44:D44', '',$left_top );
$self->merge_range( 'A45:D45', '',$left_top );
$self->insert_shape( 'A43', $shape14,0,0 );
if($language eq 'fi'){
    $self->write( 'A43', " Yritys Oy", $left_top );
    $self->write( 'A44', " Osoite", $left_top );
    $self->write( 'A45', " 123456 Paikkakunta", $left_top );
}
if($language eq 'en'){
    $self->write( 'A43', " Company Ltd", $left_top );
    $self->write( 'A44', " Street 10", $left_top );
    $self->write( 'A45', " 123456 City", $left_top );
}

$self->insert_shape( 'E39', $shape_3,0,0 );

$self->merge_range( 'E39:G39', '',$left_top );
$self->merge_range( 'E40:G40', '',$left_top );
$self->write( 'E39', " BIC/Swift", $left_top );
$self->write( 'E40', " OKOYFIHH", $left_top );

$self->insert_shape( 'H39', $shape_3,0,0 );

$self->merge_range( 'H39:J39', '',$left_top );
$self->merge_range( 'H40:J40', '',$left );
if($language eq 'fi'){
    $self->write( 'H39', " Eräpäivä", $left_top );
}
if($language eq 'en'){
    $self->write( 'H39', " Eräpäivä", $left_top );
}
$self->write( 'H40', " 01.04.2019", $left_top );


my $shape16 = $wb->add_shape(
    type   => 'rect',
    width  => 384,
    height => 40,
);

$self->insert_shape( 'E41', $shape16,0,0 );

$self->merge_range( 'E41:J41', '',$left_top );
$self->merge_range( 'E42:J42', '',$left );
if($language eq 'fi'){
    $self->write( 'E41', " Yhteensä EUR", $left_top );
}
if($language eq 'en'){
    $self->write( 'E41', " Total €", $left_top );
}
$self->write( 'E42', " 226.00", $left_top );


my $shape16b = $wb->add_shape(
    type   => 'rect',
    width  => 384,
    height => 60,   
);

$self->insert_shape( 'E43', $shape16b,0,0 );

$self->merge_range( 'E43:J43', '',$left_top );
$self->merge_range( 'E44:J44', '',$left_top );
$self->merge_range( 'E45:J45', '',$left_top );
if($language eq 'fi'){
    $self->write( 'E43', " Y-tunnus: 12349910-2", $left_top );
    $self->write( 'E44', " Puhelin: 123-1234478", $left_top );
    $self->write( 'E45', " Sähköposti: me\@me.fi", $left_top );
}
if($language eq 'en'){
    $self->write( 'E43', " Company ID: 12349910-2", $left_top );
    $self->write( 'E44', " Telephone: 123-1234478", $left_top );
    $self->write( 'E45', " Email: me\@me.fi", $left_top );
}

  return $wb->close;
}

__END__