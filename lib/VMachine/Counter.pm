package VMachine::Counter;

use Moose::Role;

requires 'comparatorConfig';

has current_count => (
  is => 'rw',
  isa => 'Num',
  default => 0,
);

sub coin_accepted {
  my ($self, $pulses) = @_;
  foreach (values %{$self->comparatorConfig}) {
    $self->add_value($_->{value}) if $_->{pulse} == $pulses;
  }
  return $self;
}

sub add_value {
  my ($self, $value) = @_;
  $self->current_count($self->current_count + $value);
  $self->set_display($self->current_count);
  return $self;
}

sub purchase {
  my ($self, $value) = @_;

}

1;
