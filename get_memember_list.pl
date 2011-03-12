use strict;
use warnings;
use feature ':5.10';
use LWP::Simple;
use XML::Simple;
use URI;
use Getopt::Long;
use DBD::Pg;

my $api_key;
my $group;
GetOptions( "api_key=s" => \$api_key, "group=i" => \$group );

my $dbh = DBI->connect('dbi:Pg:dbname=meetup');
my $sth = $dbh->prepare(
	'INSERT INTO members (
		meetup_id
		, alias
		, country
		, state
		, city
		, zip
		, lat
		, long
		, date_join
		, date_visit
		, l_facebook
		, l_linkedin
		, l_flickr
		, bio
	)
	VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? )
	'
);

my $uri = URI->new('https://api.meetup.com/members.xml/');
$uri->query_form(
	group_id => $group
	, key => $api_key
	, order => 'name'
	, format => 'xml'
	, page => 200
	, offset => 0
);

my $xml;
my $count;
do {
	warn "Retreiving url $uri";
	my $file = get( $uri ) or die "Couldn't fetch";
	$xml = XMLin( $file, SuppressEmpty => 1 );

	foreach my $alias ( keys %{$xml->{items}{item}} ) {
		my $u = $xml->{items}{item}{$alias};
		
		$sth->execute(
			$u->{id}
			, $alias
			, $u->{country}
			, $u->{state}
			, $u->{city}
			, (int($u->{zip})||undef) # meetup3 seriously wtf
			, $u->{lat}
			, $u->{lon}
			, $u->{joined}
			, $u->{visited}
			, $u->{other_services}{facebook}{identifier}
			, $u->{other_services}{linkedin}{identifier}
			, $u->{other_services}{flickr}{identifier}
			, $u->{bio}
		);
		
		die $dbh->errstr if $dbh->err;
	}

} while (
	$uri = $xml->{head}{'next'}
	and %{$xml->{items}{item}}
);

say "Done!";
