package Vis::Log;

use warnings;
use strict;

use Data::Uniqid qw(suniqid uniqid luniqid);
use Encode;

sub css {[]}
sub js  {[]}

sub do {
	my ($data) = @_;

	return '' unless $data;
	return '<pre>'.encode_utf8($data).'</pre>';
}

1;

