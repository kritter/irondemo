package SIMU::SIT::Irondemo::Modules::CreateServer;

use 5.006;
use strict;
use warnings;
use Carp qw(croak);
use File::Spec;
use File::Basename;
use lib '../../../';
use parent 'TrustAtHsH::Irondemo::AbstractIfmapPublishModule';


my $RACK = 'rack';
my $SERVER = 'server';
my $SERVERADDRESS = 'serveraddress';
my $IFMAP_USER = 'ifmap-user';
my $IFMAP_PASS = 'ifmap-pass';

my @REQUIRED_ARGS = ($RACK,$SERVER,$SERVERADDRESS);


### INSTANCE METHOD ###
# Purpose     :
# Returns     : True value on success, false value on failure
# Parameters  : None
# Comments    :
sub execute {
	my $self = shift;
	my $data = $self->{'data'};

	my $rack = $data->{$RACK};
	my $server = $data->{$SERVER};
	my $serveraddress= $data->{$SERVERADDRESS};

	my $updates00 = <<"END_MESSAGE";
<update lifetime="forever">
	<device>
		<name>$rack</name>
	</device>
	<device>
		<name>$server</name>
	</device>
	<metadata>
		<meta:associated-with ifmap-cardinality="singleValue" xmlns:meta="http://www.trustedcomputinggroup.org/2010/IFMAP-METADATA/2"/>
	</metadata>
</update>
END_MESSAGE
	my $updates01 = <<"END_MESSAGE";
<update lifetime="forever">
	<device>
		<name>$server</name>
	</device>
	<ip-address type="IPv4" value="$serveraddress"/>
	<metadata>
		<meta:device-ip ifmap-cardinality="singleValue" xmlns:meta="http://www.trustedcomputinggroup.org/2010/IFMAP-METADATA/2"/>
	</metadata>
</update>
END_MESSAGE

	my $connectionArgs = {
		"ifmap-user" => $data->{$IFMAP_USER},
		"ifmap-pass" => $data->{$IFMAP_PASS}
	};

	my $result00 = $self->send_soap_publish_request({
		'update_elements' => $updates00,
		'connection_args' => $connectionArgs});
	my $result01 = $self->send_soap_publish_request({
		'update_elements' => $updates01,
		'connection_args' => $connectionArgs});

	return $result00 && $result01;
}


### INSTANCE METHOD ###
# Purpose     :
# Returns     :
# Parameters  :
# Comments    :
sub get_required_arguments {
	my $self = shift;

	return @REQUIRED_ARGS;
}


### INTERNAL UTILITY ###
# Purpose     :
# Returns     :
# Parameters  : data ->
#                 ifmap-user          ->(optional)
#                 ifmap-pass          ->(optional)
#                 ifmap-url           ->(optional)
# Comments    : Override, called from parent's constructor
sub _init {
	my $self = shift;
	my $args = shift;

	while ( my ($key, $val) = each %{$args} ) {
		$self->{'data'}->{$key} = $val;
	}
}

1;
