package VMachine::Chopper;

use Moose::Role;
with 'VMachine::Bin';

has stackmax => (
  is => 'ro',
  isa => 'Num',
  default => '50',
);
has choppers => (
  is => 'rw',
  isa => 'ArrayRef',
  builder => 'build_choppers',
);

sub build_choppers {
  my ($self) = @_;
  return [ 1 => 25, 3 => 25, 4 => 25 ];
}

sub chop_in {
  my ($self, $diameter) = @_;
  return $self->bin_drop if $self->choppers->[$diameter] > $self->stackmax;
  $self->choppers->[$diameter] += 1;
  $self->click($diameter);
  return $self;
}

sub chop_out {
  my ($self, $diameter) = @_;
  return $self->no_change if $self->choppers->[$diameter] <= 0;
  $self->whir($diameter);
  $self->choppers->[$diameter] -= 1;
}

sub refund {
  my ($self) = @_;
}

sub whir {
  warn "whir a coin is chopped out\n";
}
sub click {
  warn "click a coin in the chopper\n";
}

1;
