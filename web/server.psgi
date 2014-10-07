use Plack::Request;
use Plack::Response;
use Plack::Builder;
use HTTP::Exception;
use JSON::XS;
use URI::Escape::XS 'encodeURIComponent';
use utf8;
use FindBin qw/$Bin/;
use JSON::XS;
use Plack::App::URLMap;
use Plack::App::File;
use Plack::Middleware::Static;
use Plack::Middleware::Auth::Basic;

use lib ($FindBin::Bin, "$FindBin::Bin/lib", "$FindBin::Bin/../common/lib");
use Middleware::Rest;
use Const;

Const::Init("$Bin/../config.yaml");

##############################################################################
builder {

	enable "Auth::Basic", authenticator => sub {
        my($username, $password) = @_;
        return $username eq Const::Get('AdminUser') && $password eq Const::Get('AdminPassword');
    };
	enable '+Middleware::GreyPages';
	enable "HTTPExceptions";
    enable '+Middleware::Rest';

	### url mapping
	my $urlmap = Plack::App::URLMap->new;

	foreach my $path (keys %{Const::Get('Resources')}) {
		my $module = Const::Get('Resources')->{$path};
		eval "require $module";
		die $@ if $@;
		$urlmap->mount($path => sub { $module });
	}

	$urlmap->mount('/static' => builder {
		enable 'Plack::Middleware::Static',
			path => qr/./,
			root => "$FindBin::Bin/static";
	});

	$urlmap->to_app();
};

