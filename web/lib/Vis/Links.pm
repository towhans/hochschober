package Vis::Links;

use warnings;
use strict;

use Data::Uniqid qw(suniqid uniqid luniqid);

sub css {[]}
sub js  {[]}

sub do {
	my ($data) = @_;

	my $html = '';
	foreach my $link (sort {$a->{href} cmp $b->{href}} @$data) {
		$html .= sprintf('<a href="%s">%s</a><br/>', $link->{href}, $link->{title} || $link->{id});
	}
	$html .= '';

	return $html;
}

1;

