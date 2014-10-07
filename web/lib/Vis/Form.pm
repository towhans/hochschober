package Vis::Form;

use warnings;
use strict;

use Data::Uniqid qw(suniqid uniqid luniqid);
use Encode;

sub css {[]}
sub js  {[]}

sub do {
	my ($data) = @_;

	my $html = '';
	foreach my $name (keys %$data) {
		$html .= "<form action='$data->{$name}{action}' method='$data->{$name}{method}'>";
		if ($data->{$name}{method} eq 'POST') {
			$html .= '<textarea name="DATA" class="form-control" rows="40">';
			$html .=  encode_utf8($data->{$name}{data} || '');
        	$html .= '</textarea>';
		}
		$html .= "<button type='submit' class='btn btn-default'>$name</button>";
		$html .= '</form>';
	}

	return $html;
}

1;

