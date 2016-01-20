package VMachine::Comparator;

use Moose::Role;
with 'VMachine::Counter';
with 'VMachine::Chopper';
with 'VMachine::Return';

sub coin_in {
  my ($self, $diameter, $magflux, $ferrous) = @_;
  foreach (values %{$self->comparatorConfig}) {
    last if $ferrous;
    next if $diameter != $_->{diameter};
    next if $magflux < $_->{flux} - $_->{tolerance};
    next if $magflux > $_->{flux} + $_->{tolerance};
    $self->coin_accepted($_->{pulse});
    $self->chop_in($diameter);
    return 1;
  }
  return $self->return_drop($diameter);
}

sub read_display {
  my ($self) = @_;
  return $self->display_text();
}

1;
