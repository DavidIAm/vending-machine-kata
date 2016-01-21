package VMachine::Return;

use Moose::Role;

has seen => ( is => 'ro', isa => 'ArrayRef', default => sub { [] }, );

sub return_drop {
    my ( $self, $diameter ) = @_;
    push @{ $self->seen }, $diameter;
    $self->clink($diameter);
    return 0;
}

sub clink {
    warn "clink a coin in the return\n";
}

1;
