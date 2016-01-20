package Coin::Test;

use base qw/Test::Class/;

my $comparatorData = {
      nickel => { 
        value => 5,
        pulse => 2,
        diameter => 2,
      },
      dime => {
        value => 10,
        pulse => 3,
        diameter => 1,
      },
      quarter => {
        value => 25,
        pulse => 4,
        diameter => 3,
      },
    };

sub startup : Test(startup) {
  my $self = shift;
  # we have a coin return
  my $self->{machine} = VMachine->new(
    comparatorConfig => $comparatorData,
  );
}

sub shutdown : Test(shutdown) {
}

sub test_coin : Test {
  my $self = shift;
  # As a vendor
  # I want a vending machine that accepts coins
  # So that I can collect money from the customer

  is $self->{machine}->read_display(), 'INSERT COIN', "display shows INSERT COIN";
}

sub setup : Test(setup) {
}

sub teardown : Test(teardown) {
  undef $self->{machine};
}


