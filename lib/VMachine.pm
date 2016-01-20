package VMachine;

use Moose;
our $VERSION = '0.01';

has comparatorConfig => (
    is       => 'ro',
    isa      => 'HashRef',
    required => 1,
);

with 'VMachine::Display';
with 'VMachine::Comparator';
with 'VMachine::Counter';
with 'VMachine::Return';

sub no_change {
    my ($self) = @_;

}

1;
