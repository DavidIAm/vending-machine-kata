package VMachine::Bin;

use Moose::Role;

has bincontents => ( is => 'ro', isa => 'ArrayRef', builder => 'build_bin', );

sub build_bin {
    my ($self) = @_;
    return [];
}

sub bin_drop {
    my ( $self, $diameter ) = @_;
    push @{ $self->bincontents }, $diameter;
    $self->clank($diameter);
}

sub clank {
    warn "clank a coin in the bin\n";
}

1;
