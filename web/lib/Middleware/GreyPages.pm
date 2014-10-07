package Middleware::GreyPages;

use strict;
use warnings;

use parent qw/Plack::Middleware/;

use Data::Dumper;
use JSON::XS;
use HTMLVis;
use Const;

#----------------------------------------------------------------------

sub call {
    my($self, $env) = @_;

	# unwrap data from form
    if (
        (
               ( $env->{REQUEST_METHOD} eq 'POST' )
            or ( $env->{REQUEST_METHOD} eq 'PUT' )
        )
        and $env->{CONTENT_TYPE} eq 'application/x-www-form-urlencoded'
      )
    {
        my $req = Plack::Request->new($env);
        my $data = $req->body_parameters;
        $env->{'plack.request.body'} = $data->{DATA};
    }

	# call nested app
    my $ret = $self->app->($env);

	# transform JSON to HTML
	my %hdr = @{$ret->[1]};
	if ($hdr{'Content-Type'} eq 'application/json' and $env->{HTTP_ACCEPT} =~ /application\/xhtml/) {
		local $Data::Dumper::Indent=1; local $Data::Dumper::Quotekeys=0; local $Data::Dumper::Terse=1; local $Data::Dumper::Sortkeys=1;

		# modify response - add forms
		my $res = JSON::XS::decode_json($ret->[2][0]);
		#if ($env->{'x-class'}->can('POST')) {
		#	$res->{form}{POST} = undef;
		#}
		my $html = HTMLVis::GetHTML($res);
		return [$ret->[0], ['Content-Type' => 'text/html; charset=utf-8', 'Content-Length' => length($html) ], [ $html ]];
	}

	$ret;
}

#----------------------------------------------------------------------

1;

__END__


