package VMachine::Test;

use base qw/Test::Class/;
use Test::Most;
use Test::Output;

use VMachine;

my $productData = {
    one => {
        name => 'Cola',
        cost => 100,
    },
    two => {
        name => 'chips',
        cost => 50,
    },
    three => {
        name => 'candy',
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
}

sub setup : Test(setup) {
    my $self = shift;

    # we have a coin return
    $self->{machine} = VMachine->new(
        comparatorConfig => $comparatorData,
        productConfig    => $productData,
    );
}

sub shutdown : Test(shutdown) {
}

sub select_product_smooth : Test(8) {
    my $self = shift;

    # When a respective button is pressed AND enough money is inserted, product
    # is dispensed and machine says THANK YOU && resets display
    is $self->{machine}->read_display(), 'INSERT COINS', 'empty state';
    stderr_is {
        $self->{machine}->coin_in( 4, 75, 0 );
    }
    qq/click a coin in the chopper\n/;
    is $self->{machine}->read_display(), '0.25', 'add a quarter one';
    stderr_is {
        $self->{machine}->coin_in( 4, 75, 0 );
    }
    qq/click a coin in the chopper\n/;
    is $self->{machine}->read_display(), '0.50', 'add a quarter two';
    stderr_is {
        $self->{machine}->button_press('two');
    }
    qq/THUNK a product is delivered\n/;
    is $self->{machine}->read_display(), 'THANK YOU';
    is $self->{machine}->read_display(), 'INSERT COINS';

  }

sub z_select_product_novalue : Test(9) {
    my ($self) = @_;

    # If there is not any value in the machine displays PRICE and the price
    # of the item, then goes back to INSERT COINS
    is $self->{machine}->read_display(), 'INSERT COINS', 'empty state';
    stderr_is {
        $self->{machine}->button_press('two');
    }
    q//;
    is $self->{machine}->read_display(), 'PRICE 0.50',   'price message';
    is $self->{machine}->read_display(), 'INSERT COINS', 'empty state';

    # If there is money but not enough, it displays price, then goes back to
    # amoutn
    stderr_is {
        $self->{machine}->coin_in( 4, 75, 0 );
    }
    qq/click a coin in the chopper\n/;
    is $self->{machine}->read_display(), '0.25', 'add a quarter one';
    stderr_is {
        $self->{machine}->button_press('two');
    }
    q//;
    is $self->{machine}->read_display(), 'PRICE 0.50',   'price message';
    is $self->{machine}->read_display(), '0.25', 'add a quarter one';
}

sub accept_coin : Test(22) {
    my $self = shift;

    # As a vendor
    # I want a vending machine that accepts coins
    # So that I can collect money from the customer

    is $self->{machine}->read_display(), 'INSERT COINS',
      "display shows INSERT COINS";

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
    is $self->{machine}->read_display(), '0.15', 'add a nickel';
    stderr_is {
        ok $self->{machine}->coin_in( 4, 75, 0 ), 'quarter';
    }
    qq/click a coin in the chopper\n/;
    is $self->{machine}->read_display(), '0.40', 'add a quarter';
    stderr_is {
        ok !$self->{machine}->coin_in( 5, 150, 0 ), 'reject fifty cent';
    }
    qq/clink a coin in the return\n/;
    is $self->{machine}->read_display(), '0.40', 'reject, no fitty';
    stderr_is {
        ok !$self->{machine}->coin_in( 6, 110, 0 ), 'reject dollar';
    }
    qq/clink a coin in the return\n/;
    is $self->{machine}->read_display(), '0.40', 'reject, no dollar';

    # not comprehansive bug okay.
}

sub teardown : Test(teardown) {
    my $self = shift;
    undef $self->{machine};
}

__PACKAGE__->runtests();
