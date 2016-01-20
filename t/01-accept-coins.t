package VMachine::Test;

use base qw/Test::Class/;
use Test::Most;

use VMachine;

my $comparatorData = {
      nickel => { 
        value => 5,
        pulse => 2,
        diameter => 3,
        flux => 40,
        tolerance => 5,
      },
      dime => {
        value => 10,
        pulse => 3,
        diameter => 1,
        flux => 25,
        tolerance => 3,
      },
      quarter => {
        value => 25,
        pulse => 4,
        diameter => 4,
        flux => 85,
        tolerance => 10,
      },
    };

sub startup : Test(startup) {
  my $self = shift;
  # we have a coin return
  $self->{machine} = VMachine->new(
    comparatorConfig => $comparatorData,
  );
}

sub shutdown : Test(shutdown) {
}

sub test_coin : Test(8) {
  my $self = shift;
  # As a vendor
  # I want a vending machine that accepts coins
  # So that I can collect money from the customer

  is $self->{machine}->read_display(), 'INSERT COIN', "display shows INSERT COIN";

  # The vending machine will accept nickels dimes and quarter and reject others
  ok $self->{machine}->coin_in( 1, 35, 0 );
  ok ! $self->{machine}->coin_in( 1, 30, 0 ), 'reject light dime';
  ok ! $self->{machine}->coin_in( 1, 40, 1 ), 'reject ferrous dime';
  ok $self->{machine}->coin_in( 2, 35, 0 ), 'nickel';
  ok $self->{machine}->coin_in( 3, 35, 0 ), 'quarter';
  ok !$self->{machine}->coin_in( 4, 35, 0 ), 'fifty cent';
  ok !$self->{machine}->coin_in( 5, 35, 0 ), 'dollar';
}

sub setup : Test(setup) {
}

sub teardown : Test(teardown) {
  my $self = shift;
  undef $self->{machine};
}

__PACKAGE__->runtests();
