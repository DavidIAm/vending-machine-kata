package VMachine::Buttons;

use Moose::Role;

sub button_press {
    my ( $self, $which ) = @_;
    my $product = $self->productConfig->{$which};
    if ( $self->has_inventory($which) ) {
        if ( $self->purchase( $product->{cost} ) ) {
            $self->dispense($which);
        }
    }
    else {
        $self->message('SOLD OUT');
    }
}

sub refund_pull {
    my ($self) = @_;
    $self->refund();
}

sub read_display {
    my ($self) = @_;
    return $self->display_text();
}

1;
