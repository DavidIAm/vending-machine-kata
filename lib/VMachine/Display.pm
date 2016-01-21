package VMachine::Display;

use Moose::Role;

has message_queue =>
    ( is => 'ro', isa => 'ArrayRef', builder => 'build_queue', );
has display_text => ( is => 'rw', isa => 'Str', clearer => 'clear_display', );

sub set_display {
    my ( $self, $new ) = @_;
    $self->display_text($new);
    return $self->display_text();
}

sub read_display {
    my ($self) = @_;
    if ( $self->has_entries ) {
        return $self->message_get();
    }
    return $self->display_text() if $self->display_text();
    return 'INSERT COINS' if grep { $_ > 0 } values %{ $self->choppers };
    return 'EXACT CHANGE ONLY';
}

sub message_get {
    my ($self) = @_;
    shift @{ $self->{message_queue} };
}

sub message {
    my ( $self, $message ) = @_;
    push @{ $self->{message_queue} }, $message if defined $message;
}

sub has_entries {
    my ($self) = @_;
    return scalar @{ $self->message_queue };
}

sub build_queue {
    return [];
}

1;
