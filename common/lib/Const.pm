package Const;

use warnings;
use strict;
use YAML::AppConfig;
use FindBin qw($Bin);

our $conf;

sub Init {
	my $file = shift;
	$conf = YAML::AppConfig->new(file => $file);
	print "Configuration loaded from $file\n";
	foreach (@_) {
		$conf->merge(file=>$_);
		print " additional configuration merged from: $file\n";
	}
}

sub Get {
	$conf->get(shift);
}

1;
