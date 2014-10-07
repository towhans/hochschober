package Resource::Root;

use warnings;
use strict;
use Const;

###############################################################################
#  Group: REST methods
###############################################################################

sub GET {
	my ($env, $data) = @_;
	my $links = [];
	map {push(@$links, {id=>$_, href=>"$_", rel=>'resource' })} (keys %{Const::Get('Resources')});
	return { link => $links };
}


1;
