package HTMLVis;

use warnings;
use strict;

use JSON::XS;
use Log;
use Const;

my $prepared = undef;

sub Prepare {
	foreach (values %{Const::Get('Visualization')}) {
		eval "require $_";
		die "Could not load $_: $@" if $@;
	}
	$prepared = 1;
}

#-------------------------------------------------------------------------------
# Function: GetHTML
#	Based on visualizations in $config transforms $response to $html  
#
# Parameters:
#   $response - perl object with response data (hashref)
#
# Returns:
#   $html - html code
#
#-------------------------------------------------------------------------------
sub GetHTML {
	my ($data) = @_;
	Prepare() unless $prepared;

	##########################
	# apply the visualizations
	##########################
	my $html_parts = [];
	foreach my $key (keys %$data) {
		if (exists Const::Get('Visualization')->{$key}) {
			my $class = Const::Get('Visualization')->{$key};
			{
				no strict 'refs';
				my $html_part = eval { "${class}::do"->($data->{$key}) };
				if ($@) {
					push(@$html_parts, {type=>'html_vis_errors_internal', html=> $@."\n\n"});
				} else {
					push(
					@$html_parts, {
						type  => $key,
						html  => $html_part,
						js    => "${class}::js"->(),
						css   => "${class}::css"->(),
					})
				}
			}
			delete $data->{$key};
		}
	}

	#########################
	# encode the rest of data
	#########################
	push(@$html_parts, {type=>'other', html=>'<pre>'.JSON::XS->new->utf8->pretty->encode($data).'</pre>', js=>[], css=>[]});

	############################
	# produce single html output
	############################
	_HTML($html_parts);
}

# compose more HTML parts into a single HTML document
sub _HTML {
	my ($html_parts) = @_;

	my $js_files = [];
	my $seen = {};
	my $css_files = [];
	my $html = '';

	foreach my $part (@$html_parts) {
		foreach my $file (@{$part->{js}}) {
			push(@$js_files, $file) unless exists $seen->{$file};
			$seen->{$file} = undef;
		}
		foreach my $file (@{$part->{css}}) {
			push(@$css_files, $file) unless exists $seen->{$file};
			$seen->{$file} = undef;
		}
		$html .= $part->{html};
	}
	my $js = join("\n", map {"<script type='text/javascript' src='$_'></script>"} @$js_files) || '';
	my $css = join("\n", map {"<link rel='stylesheet' href='$_'></link>"} @$css_files) || '';

"<html>
<body>
<script type='text/javascript' src='/static/js/jquery-1.7.min.js'></script>
$js
<div>
		<ul class='breadcrumb' style='font-family: nova-mono, sans-serif;'>
			<li><a href='/'>REST API</a></li>
		</ul>
		$html
</div>
$css
<link rel='stylesheet' href='//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css'>
</body></html>";
}	

1;

__END__

