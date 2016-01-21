package VMachine::Chopper;

use Moose::Role;
with 'VMachine::Bin';

has stackmax => (
    is      => 'ro',
    isa     => 'Num',
    default => '50',
);
has choppers => (
    is      => 'rw',
    isa     => 'ArrayRef',
    builder => 'build_choppers',
);

sub build_choppers {
    my ($self) = @_;
    return [ 1 => 25, 3 => 25, 4 => 25 ];
}

sub chop_in {
    my ( $self, $diameter ) = @_;
    return $self->bin_drop if $self->choppers->[$diameter] > $self->stackmax;
    $self->choppers->[$diameter] += 1;
    $self->click($diameter);
    return $self;
}

sub chop_out {
    my ( $self, $diameter ) = @_;
    do { die "no change available for diameter $diameter"; $self->no_change;} if $self->choppers->[$diameter] <= 0;
    # take the comparator values select the proper diameter and use its value
    if (
        $self->remove_value(
            map    { $_->{value} }
              grep { $_->{diameter} eq $diameter }
              values %{ $self->comparatorConfig }
        )
      )
    {
        $self->whir($diameter);
        $self->choppers->[$diameter] -= 1;
        $self->return_drop($diameter);
    }
}

sub has_coins {
  my ($self, $diameter)  = @_;
  return 1;
}
sub largest_coin_diameter {
    my ( $self, $value ) = @_;
    my ($coin) = sort { $b->{value} <=> $a->{value} } grep { $self->has_coins($_->{diameter}) && $_->{value} <= $value  } values %{$self->comparatorConfig};
    return $coin->{diameter};
}

sub refund {
    my ($self) = @_;
    my $max = 10; # how many times we loop max
    while ($self->current_count > 0 && $max--) {
      $self->chop_out($self->largest_coin_diameter($self->current_count));
    }
}

sub whir {
    warn "whir a coin is chopped out\n";
}

sub click {
    warn "click a coin in the chopper\n";
}

1;
