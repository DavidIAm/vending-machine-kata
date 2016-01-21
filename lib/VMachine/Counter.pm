package VMachine::Counter;

use Moose::Role;

requires 'comparatorConfig';

has current_count => (
    is      => 'rw',
    isa     => 'Num',
    clearer => 'clear_count',
    trigger => \&fixtrigger,
    default => 0,
);

sub coin_accepted {
    my ( $self, $pulses ) = @_;
    foreach ( values %{ $self->comparatorConfig } ) {
        $self->add_value( $_->{value} ) if $_->{pulse} == $pulses;
    }
    return $self;
}

sub add_value {
    my ( $self, $value ) = @_;
    $self->current_count( $self->current_count + $value );
}

sub purchase {
    my ( $self, $value ) = @_;
    if ($value >= $self->current_count) {
      $self->current_count($self->current_count - $value);
      return 1;
    }
    return 0;
}

sub fixtrigger {
  my ($self, $value) = @_;
  $self->set_display( sprintf '%0.2f', $value / 100 );
  $self->set_display($self->DEFAULT_DISPLAY) if $value <= 0;
  return $value;
}

1;
