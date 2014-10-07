package Log;
# Package that parses structured data from text based on templates

use v5.10.0;
use strict;

#-------------------------------------------------------------------------------
# Function: Debug
#  Print debug message
#
# Parameters:
#  text
#
# Returns:
#
#-------------------------------------------------------------------------------
sub Debug {
	my ($text, $type) = @_;
	if ($type eq 'heading') {
		print "\n# ---------- $text ----------\n"
	} else {
		print "# $text\n";
	}
}

sub Info {
	my ($text, $type) = @_;
	if ($type eq 'heading') {
		print "\n# ---------- $text ----------\n"
	} else {
		print "# $text\n";
	}
}

sub Error {
	my ($text, $type) = @_;
	if ($type eq 'heading') {
		print "\n# ---------- $text ----------\n"
	} else {
		print "# ERROR : $text\n";
	}
}

1;
