package VMachine::Test;

use base qw/Test::Class/;
use Test::Most;
use Test::Output;

use VMachine;

my $productData = {
  one => { name => 'Cola',
      cost => 100,
    },
    two => { name => 'chips',
      cost => 50,
    },
    three => { name => 'candy',
      cost => 65,
    },
};
my $comparatorData = {
    nickel => {
        value     => 5,
        pulse     => 2,
        diameter  => 3,
        flux      => 40,
        tolerance => 5,
    },
    dime => {
        value     => 10,
        pulse     => 3,
        diameter  => 1,
        flux      => 25,
        tolerance => 3,
    },
    quarter => {
        value     => 25,
        pulse     => 4,
        diameter  => 4,
        flux      => 85,
        tolerance => 10,
    },
};

sub startup : Test(startup) {
    my $self = shift;

    # we have a coin return
    $self->{machine} = VMachine->new( comparatorConfig => $comparatorData, productConfig => $productData );
}

sub shutdown : Test(shutdown) {
}

sub select_product {
  my ($self) = @_;
  # When a respective button is pressed AND enough money is inserted, product
  # is dispensed and machine says THANK YOU && resets display

  # If there is not sufficient inserted the mahine displays PRICE and the price
  # of the item
}

sub accept_coin : Test(22) {
    my $self = shift;

    # As a vendor
    # I want a vending machine that accepts coins
    # So that I can collect money from the customer

    is $self->{machine}->read_display(), 'INSERT COIN',
      "display shows INSERT COIN";

    # The vending machine will accept nickels dimes and quarter and reject others
    stderr_is {
        ok $self->{machine}->coin_in( 1, 28, 0 );
    }
    qq/click a coin in the chopper\n/;
    is $self->{machine}->read_display(), '0.10', 'initial dime';
    stderr_is {
        ok !$self->{machine}->coin_in( 1, 20, 0 ), 'reject light dime';
    }
    qq/clink a coin in the return\n/;
    is $self->{machine}->read_display(), '0.10', 'rejected no change';
    stderr_is {
        ok !$self->{machine}->coin_in( 1, 25, 1 ), 'reject ferrous dime';
    }
    qq/clink a coin in the return\n/;
    is $self->{machine}->read_display(), '0.10', 'rejected no change';
    stderr_is {
        ok $self->{machine}->coin_in( 3, 35, 0 ), 'nickel';
    }
    qq/click a coin in the chopper\n/;
    is $self->{machine}->read_display(), '0.15','add a nickel';
    stderr_is {
        ok $self->{machine}->coin_in( 4, 75, 0 ), 'quarter';
    }
    qq/click a coin in the chopper\n/;
    is $self->{machine}->read_display(), '0.40','add a quarter';
    stderr_is {
        ok !$self->{machine}->coin_in( 5, 150, 0 ), 'reject fifty cent';
    }
    qq/clink a coin in the return\n/;
    is $self->{machine}->read_display(), '0.40','reject, no fitty';
    stderr_is {
        ok !$self->{machine}->coin_in( 6, 110, 0 ), 'reject dollar';
    }
    qq/clink a coin in the return\n/;
    is $self->{machine}->read_display(), '0.40','reject, no dollar';
    # not comprehansive bug okay.
}


sub setup : Test(setup) {
}

sub teardown : Test(teardown) {
    my $self = shift;
    undef $self->{machine};
}

__PACKAGE__->runtests();
