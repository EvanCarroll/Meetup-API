#!/usr/bin/env perl
use strict;
use warnings;
use feature ':5.10';
use LWP::Simple;
use JSON::XS ();
use Encode ();
use URI ();
use Getopt::Long;
use DBD::Pg;

my ( $api_key, $group_id );
GetOptions(
	'api_key=s' => \$api_key
	, 'group=i' => \$group_id
);

use DB::Schema;
my $db = DB::Schema->connect('dbi:Pg:dbname=meetup');

my $uri = URI->new('https://api.meetup.com/members.json/');
$uri->query_form(
	group_id => $group_id
	, key => $api_key
	, order => 'name'
	, format => 'json'
	, page => 200
	, offset => 0
);

my $json;
my $count;
do {
	warn "Retreiving url $uri";
	my $file = get( $uri ) or die "Couldn't fetch";
	$json = _get_json_from_content( $file );

	foreach my $u ( @{$json->{results}} ) {
		
		my $rs_group = $db->resultset('Meetupcom::Groups');
		unless ( $rs_group->find($group_id) ) {
			my $uri = $uri->clone;
			$uri->path('/groups.json/');
			$uri->query_form({ id => $group_id, key => $api_key });
			my $file = get( $uri ) or die "Couldn't fetch $uri";
			my $json = _get_json_from_content( $file );

			foreach my $group (  @{$json->{results}}  ) {
				my $rs = $rs_group->create({
					id_group       => $group->{id}
					, group_alias  => $group->{who}
					, members      => $group->{members}
					, description  => $group->{description}
					, state        => $group->{state}
					, city         => $group->{city}
					, zip          => $group->{zip}
					, lat          => $group->{lat}
					, long         => $group->{lon}
					, organizer_id => $group->{organizer_id}
					, date_created => $group->{created}
					, date_updated => $group->{updated}
					, is_private   => ( $group->{visibility} eq 'private' ? 1 : 0)
				});
				foreach my $topic (  @{$group->{topics}}  ) {
					$rs->add_to_topics({
						id_topic => $topic->{id}
						, topic_urlkey => $topic->{urlkey}
						, topic_name   => $topic->{name}
					});
				}
			}
		}

		{
			my $rs = $db->resultset('Meetupcom::Members')->create({
				id_group => $group_id
				, id_member => $u->{id}
				, alias => $u->{name}
				, country => $u->{country}
				, state => $u->{state}
				, city => $u->{city}
				, zip => (
					DBI::looks_like_number($u->{zip})
					? $u->{zip}
					: undef
				) # meetup3 seriously wtf
				, lat => $u->{lat}
				, long => $u->{lon}
				, date_join => $u->{joined}
				, date_visit => $u->{visited}
				, l_facebook => $u->{other_services}{facebook}{identifier}
				, l_linkedin => $u->{other_services}{linkedin}{identifier}
				, l_flickr => $u->{other_services}{flickr}{identifier}
				, l_twitter => $u->{other_services}{twitter}{identifier}
				, bio => $u->{bio}
				, picture_url => $u->{photo_url}
			});
			
			foreach my $topic (  @{$u->{topics}}  ) {
				$rs->add_to_topics({
					id_topic => $topic->{id}
					, topic_urlkey => $topic->{urlkey}
					, topic_name   => $topic->{name}
				});
			}
				
		}

	}

} while (
	$uri = $json->{meta}{'next'}
	and @{ $json->{results} }
);

sub _get_json_from_content {
	my $file = shift;
	Encode::from_to($file, 'iso-8859-1', 'utf8');
	JSON::XS::decode_json( $file );
}

say "Done!";
__END__
		# $sth->execute(
		# 	$group_id
		# 	, $u->{id}
		# 	, $u->{name}
		# 	, $u->{country}
		# 	, $u->{state}
		# 	, $u->{city}
		# 	, (
		# 		DBI::looks_like_number($u->{zip})
		# 		? $u->{zip}
		# 		: undef
		# 	) # meetup3 seriously wtf
		# 	, $u->{lat}
		# 	, $u->{lon}
		# 	, $u->{joined}
		# 	, $u->{visited}
		# 	, $u->{other_services}{facebook}{identifier}
		# 	, $u->{other_services}{linkedin}{identifier}
		# 	, $u->{other_services}{flickr}{identifier}
		# 	, $u->{other_services}{twitter}{identifier}
		# 	, $u->{bio}
		# 	, $u->{photo_url}
		# );
		
		# die $dbh->errstr if $dbh->err;
