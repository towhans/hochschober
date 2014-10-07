package Middleware::Rest;

use strict;
use warnings;

use parent qw/Plack::Middleware/;

use Data::Dumper;
use JSON::XS;
use Log;

#----------------------------------------------------------------------

sub call {
    my($self, $env) = @_;
    my $class = $self->app->($env);
	return $class if ref $class;

	my $method = $env->{REQUEST_METHOD};

	my $data;

	if ($method eq 'POST' or $method eq 'PUT') {
		my $req = Plack::Request->new($env);

		if ($env->{CONTENT_TYPE} eq 'application/x-www-form-urlencoded') {
			$data = $req->body_parameters;
		} else {
			$data = $req->content();
		}
	}
	my ($ret);

	eval {
		no strict 'refs';
		$ret = "${class}::$method"->($env, $data);
	};
	$env->{'x-class'} = $class;

	if (UNIVERSAL::isa($ret, 'Plack::App::File')) {
		return  $self->response_cb(
			$ret->call($env), sub {}
		)
	}

	my $error = $@;
	if ($error) {
		Log::Error($error);
		return [500, [],[]];
	}

	my $resp = ref $ret
		? _Encode($ret)
		: $ret;

	my $headers = [ "Content-Type" => 'application/json', "Content-Length" => length($resp) ];

	return [ 200,
		$headers,
		[ $resp ]
	];
}

#----------------------------------------------------------------------

sub _Encode {
	my ($data, $format) = @_;
	my $ret = eval  { JSON::XS->new->pretty->encode($data) };
	if ($@) {
		local $Data::Dumper::Indent=1; local $Data::Dumper::Quotekeys=0; local $Data::Dumper::Terse=1; local $Data::Dumper::Sortkeys=1;
		Dumper($data);
	} else {
		return $ret;
	}
}

1;

__END__


