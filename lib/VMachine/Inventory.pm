package VMachine::Inventory;

use Moose::Role;

has inventory => (
    is      => 'ro',
    isa     => 'HashRef',
    default => sub {
        +{ map { ( $_ => 1 ) } keys %{ shift->productConfig } };
    },
    lazy => 1,
);

sub has_inventory {
    my ( $self, $which ) = @_;
    return 1 if $self->inventory->{$which} > 0;
    return 0;
}

sub subtract_inventory {
    my ( $self, $which ) = @_;
    $self->inventory->{$which}--;
}

sub dispense {
    my ( $self, $which ) = @_;
    if ( $self->has_inventory($which) ) {
        $self->subtract_inventory($which);
        $self->thunk($which);
        $self->refund();
        $self->message('THANK YOU');
        return 1;
    }
    $self->message('SOLD OUT');
    return 0;
}

sub thunk {
    my ($self) = @_;
    warn "THUNK a product is delivered\n";
}

sub read_display {
    my ($self) = @_;
    return $self->display_text();
}

1;
