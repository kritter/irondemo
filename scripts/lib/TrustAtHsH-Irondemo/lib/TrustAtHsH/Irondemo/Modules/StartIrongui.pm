package TrustAtHsH::Irondemo::Modules::StartIrongui;

use 5.006;
use strict;
use warnings;
use File::Spec;
use lib '../../../';
use TrustAtHsH::Irondemo::Config;
use parent 'TrustAtHsH::Irondemo::AbstractProcessStarterModule';

### INSTANCE METHOD ###
# Purpose     :
# Returns     :
# Parameters  :
# Comments    :
sub execute {
	my $self = shift;
	my $irond;
	
	if ( $^O eq 'MSWin32' ) {
		$irond = File::Spec->catfile(
		  TrustAtHsH::Irondemo::Config->instance->get_current_scenario_dir(),
		  "irongui/start.bat"
		);
	} else {
		$irond = File::Spec->catfile(
		  TrustAtHsH::Irondemo::Config->instance->get_current_scenario_dir(),
		  "irongui/start.sh"
		);
	}
	
	return $self->start_process( $irond );
}

1;