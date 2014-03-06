package TrustAtHsH::Irondemo::Modules::UserLogin;

use 5.006;
use strict;
use warnings;
use Carp qw(croak);
use File::Spec;
use File::Basename;
use lib '../../../';
use parent 'TrustAtHsH::Irondemo::AbstractIfmapCliModule';


my $ACCESS_REQUEST = 'access-request';
my $ROLE = 'role';
my $NAME = 'name';
my $CAPABILITY = 'capability';
my $IFMAP_USER = 'ifmap-user';
my $IFMAP_PASS = 'ifmap-pass';

my @REQUIRED_ARGS = (
	$ACCESS_REQUEST, $ROLE, $NAME, $IFMAP_USER, $IFMAP_PASS);


### INSTANCE METHOD ###
# Purpose     :
# Returns     : True value on success, false value on failure
# Parameters  : None
# Comments    :
sub execute {
	my $self = shift;
	my $data = $self->{'data'};

	my @argsList = ($data->{$ACCESS_REQUEST}, $data->{$NAME});
	my @argsListRole = ($data->{$ACCESS_REQUEST}, $data->{$NAME}, $data->{$ROLE});
	my @argsListCapability = ($data->{$ACCESS_REQUEST}, $data->{$CAPABILITY});

	my $connectionArgs = {
		"ifmap-user" => $data->{$IFMAP_USER},
		"ifmap-pass" => $data->{$IFMAP_PASS}
	};

	$self->call_ifmap_cli("auth-as", "update", \@argsList, $connectionArgs);
	$self->call_ifmap_cli("role", "update", \@argsListRole, $connectionArgs);
	$self->call_ifmap_cli("cap", "update", \@argsListCapability, $connectionArgs);
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
#                 ifmap-keystore-path ->(optional)
#                 ifmap-keystore-pass ->(optional)
#                 name                 >
#                 role                ->
#                 access-request      ->
#
# Comments    : Override, called from parent's constructor
sub _init {
	my $self = shift;
	my $args = shift;

	while ( my ($key, $val) = each %{$args} ) {
		$self->{'data'}->{$key} = $val;
	}
}


1;