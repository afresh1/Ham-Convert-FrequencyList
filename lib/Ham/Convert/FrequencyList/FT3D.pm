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

# This is the required first row in file
#'1,ON,145,145,0.6,OFF,ON,FM,AMS,ON,,OFF,100.0 Hz,23,RX Normal TX Normal,1600 Hz,RX 00,TX 00,High (5W),OFF,ON,20.0KHz,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,,0'

sub write {
    my ( $self, $file, $list ) = @_;

    my %defaults
        = map { $self->internal_header( $_->{name} ) => $_->{default} }
        $self->column_defs;

    # The printed list is required to have 900 rows
    # and have the terminator on it.
    my @list;
    for my $i ( 0 .. 899 ) {
        my %item = ( terminator => 0, %{ $list->[$i] || {} } );

        unless ( $self->is_empty_row( $list->[$i] ) ) {
            my $group = delete $item{group} || [];
            $item{"bank_$_"} = $group->[ $_ - 1 ] // $defaults{"bank_$_"}
                for 1 .. 24;
        }

        push @list, \%item;
    }

    if ( $self->is_empty_row( $list[0] ) ) {
        $list[0] = {%defaults};
        delete $list[0]{id};
    }

    return $self->next::method( $file, \@list );
}

sub column_defs {
    my @defs = (
        { name => 'Channel No',         internal => 'id' },
        { name => 'Priority Ch',        default => 'ON' },
        { name => 'Receive Frequency',  default => 145 },
        { name => 'Transmit Frequency', default => 145 },
        { name => 'Offset Frequency',   default => '0.6' },
        { name => 'Offset Direction',   default => 'OFF' },
        { name => 'Auto Mode',          default => 'ON' },
        { name => 'Operating Mode',     default => 'FM' },
        { name => 'Dig/Analog',         default => 'AMS' },
        { name => 'Tag',                default => 'ON' },
        { name => 'Name',               default => '' },
        { name => 'Tone Mode',          default => 'OFF' },
        { name => 'CTCSS Frequency',    default => '100.0 Hz', },
        { name => 'DCS Code',           default => 23 },
        { name => 'DCS Polarity',       default => 'RX Normal TX Normal' },
        { name => 'User CTCSS',         default => '1600 Hz' },
        { name => 'RX DG-ID',           default => 'RX 00' },
        { name => 'TX DG-ID',           default => 'TX 00' },
        { name => 'TX Power',           default => 'High (5W)' },
        { name => 'Skip',               default => 'OFF' },
        { name => 'Auto Step',          default => 'ON' },
        { name => 'Step',               default => '20.0KHz' },
        { name => 'Memory Mask',        default => 'OFF' },
        { name => 'ATT',                default => 'OFF' },
        { name => 'S-Meter SQL',        default => 'OFF' },
        { name => 'Bell',               default => 'OFF' },
        { name => 'Narrow',             default => 'OFF' },
        { name => 'Clock Shift',        default => 'OFF' },
    );

    push @defs, map { { name => "Bank $_", default => 'OFF' } } 1 .. 24;

    push @defs, (
        { name => 'Comment' },
        { name => '', internal => 'terminator', default => 0 },
    );

    return @defs;
}

sub is_empty_row {
    my ( $self, $item ) = @_;
    local $item->{terminator} if $item;
    return $self->next::method($item);
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
        return $_ ne [ $self->headers ]->[0];
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

=head2 is_empty_row

Adjusts for the fact that the C<terminator> is always "0".

=head1 BUGS AND LIMITATIONS

Likely a lot.

=head1 SEE ALSO

L<Ham::Convert::FrequencyList>

L<Yaesu's FT-3DR page|https://www.yaesu.com/indexVS.cfm?cmd=DisplayProducts&encProdID=84807B1262BFED6AC816544D94D310E3>

