package Ham::Convert::FrequencyList::FT3D;
use parent 'Ham::Convert::FrequencyList';
use utf8;     # so literals and identifiers can be in UTF-8
use v5.16;    # to get "unicode_strings" and "charnames"
use warnings;
use warnings qw(FATAL utf8);           # fatalize encoding glitches
use open qw(:std :encoding(UTF-8));    # undeclared streams in UTF-8

use Carp;

use List::Util qw< first >;

# ABSTRACT: Convert Frequency List files for the Yaesu FT-3DR/E
# VERSION

sub read {
    my $list = shift->next::method(@_);

    foreach my $item ( @{$list} ) {
        next unless $item;

        # I don't actually _know_ what this terminator is,
        # but it appears just to indicate that we've filled in all the rows.
        delete $item->{terminator} if $item->{terminator} eq '0';

        # We want to store the group
        foreach my $bank ( 1 .. 24 ) {
            my $member = delete $item->{"bank_$bank"};
            $item->{group}->[ $bank - 1 ] = $member
                if $member and $member ne 'OFF';
        }
    }

    return $list;
}

sub write {
    my ( $self, $file, $list ) = @_;

    # The printed list is required to have 900 rows
    # and have the terminator on it.
    my @list;
    for my $i ( 0 .. 899 ) {
        my %item = ( terminator => 0, %{ $list->[$i] || {} } );

        if ( first { length } values %{ $list->[$i] || {} } ) {
            my $group = delete $item{group} || [];
            $item{"bank_$_"} = $group->[ $_ - 1 ] || 'OFF' for 1 .. 24;
        }

        push @list, \%item;
    }

    return $self->next::method( $file, \@list );
}

sub column_defs {
    my @defs = (
        { name => 'Channel No', internal => 'id' },
        { name => 'Priority Ch' },
        { name => 'Receive Frequency' },
        { name => 'Transmit Frequency' },
        { name => 'Offset Frequency' },
        { name => 'Offset Direction' },
        { name => 'Auto Mode' },
        { name => 'Operating Mode' },
        { name => 'Dig/Analog' },
        { name => 'Tag' },
        { name => 'Name' },
        { name => 'Tone Mode' },
        { name => 'CTCSS Frequency' },
        { name => 'DCS Code' },
        { name => 'DCS Polarity' },
        { name => 'User CTCSS' },
        { name => 'RX DG-ID' },
        { name => 'TX DG-ID' },
        { name => 'TX Power' },
        { name => 'Skip' },
        { name => 'Auto Step' },
        { name => 'Step' },
        { name => 'Memory Mask' },
        { name => 'ATT' },
        { name => 'S-Meter SQL' },
        { name => 'Bell' },
        { name => 'Narrow' },
        { name => 'Clock Shift' },
    );

    push @defs, map { { name => "Bank $_" } } 1 .. 24;

    push @defs,
        ( { name => 'Comment' }, { name => '', internal => 'terminator' }, );

    return @defs;
}

sub read_csv_params {
    my $self   = shift;
    my $params = $self->next::method(@_);

    $params->{headers}
        = [ map { $self->internal_header($_) } $self->headers ];

    # We look to see if the first row is headers
    # That's not actually a valid file, but someone could put them in.
    my $checked_headers = 0;
    $params->{filter}->{id} = sub {
        return 1 if $checked_headers;
        $checked_headers = 1;
        return if $_ eq [ $self->headers ]->[0];
    };

    return $params;
}

sub write_headers    {0}
sub write_empty_rows {1}

1;
__END__

=head1 SYNOPSIS

    use Ham::Convert::FrequencyList::FT3D;

=head1 DESCRIPTION

Reads and writes files in the Yaesu FT-3DR/E software CSV format.

You can download the software for free from L<https://www.yaesu.com>.

=head1 METHODS

All inherited from L<Ham::Convert::FrequencyList>.

=head1 INTERNALS

These methods are used by subclasses to set up conversions.

=head2 column_defs

Includes custom definitions for converting to and from the standard
format used by L<Ham::Convert::FrequencyList>.

=head1 BUGS AND LIMITATIONS

Likely a lot.

=head1 SEE ALSO

L<Ham::Convert::FrequencyList>

L<Yaesu's FT-3DR page|https://www.yaesu.com/indexVS.cfm?cmd=DisplayProducts&encProdID=84807B1262BFED6AC816544D94D310E3>

