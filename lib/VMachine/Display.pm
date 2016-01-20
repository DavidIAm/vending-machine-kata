package VMachine::Display;

use Moose::Role;

has display_text => (
    is      => 'rw',
    isa     => 'Str',
    default => 'INSERT COIN',
);

sub set_display {
    my ( $self, $new ) = @_;
    $self->display_text($new);
    return $self->display_text();
}

sub read_display {
    my ($self) = @_;
    return $self->display_text();
}

1;
