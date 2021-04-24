package Ham::Convert::FrequencyList;
use utf8;     # so literals and identifiers can be in UTF-8
use v5.16;    # to get "unicode_strings" and "charnames"
use warnings;
use warnings qw(FATAL utf8);           # fatalize encoding glitches
use open qw(:std :encoding(UTF-8));    # undeclared streams in UTF-8

use Carp;
use List::Util qw< first >;

# ABSTRACT: Convert Frequency List files between formats
# VERSION

sub new {
    my ( $class, %params ) = @_;
    return bless {%params}, $class;
}

sub headers {
    my ($self) = @_;
    return map { $_->{name} } $self->column_defs;
}

sub internal_header {
    my ( $self, $name ) = @_;

    return $self->{_header}->{internal}->{$name}
        if exists $self->{_header}->{internal}->{$name};

    my $def = first { $_->{name} eq $name } $self->column_defs,
        { name => $name };

    $self->{_header}->{internal}->{$name} = $def->{internal} ||= do {
        local $_ = $name;
        s/transmit/tx/ig;
        s/receive/rx/ig;
        s/frequency/freq/ig;
        s/\W+/_/g;
        lc;
    };

    return $def->{internal};
}

sub column_defs {
    my @defs = map { { name => $_ } } qw<
        id

        tx_freq
        duplex
        rx_freq

        ctcss
        dtcsc
        dtcsp

        mode

        name
        comment
    >;

    push @defs, {
        name => 'groups',
        in   => sub { [ split /\s*:\s*/, $_ // '' ] },
        out  => sub { join ':', @{ $_ || [] } },
    };

    return @defs;
}

1;
__END__

=head1 SYNOPSIS

    use Ham::Convert::FrequencyList;

=head1 DESCRIPTION

Provides converterters between different formats of frequency lists
commonly used to program frequencies into amateur radio equipment.
Different radios use different software to program them,
sometimes just by preference.
Trading frequency lists can be difficult due to these incompatibilities
in the formats and the inability for one piece of software to read
files another.
This code aims to make it easier to convert from one format to another to
ease that pain.

=head1 METHODS

=head2 new

    my $converter = Ham::Convert::FrequencyList->new(
        ...,
    );

=head2 headers

Returns a list of the header names for the columns in the current format.

=head1 INTERNALS

These methods are used by subclasses to set up conversions.

=head2 column_defs

Returns a list of hashrefs defining the columns expected to be in
the file.

    my $defs = [ $converter->column_defs ];

Now C<$defs> could look like:

    [   {   name     => 'Number',
            internal => 'id',
        },
        {   name     => 'Frequency' },
        {   name     => 'group',
            in       => sub {...},
            out      => sub {...},
        },
        ...,
    ];

=head2 internal_header

    my $internal_name = $converter->internal_header( $external_name );

Looks up the internal header name from the format specific name.

Does this normally by checking the L</column_defs> for a matching C<name>
and returning the C<internal> version if it exists.
Otherwise does some basic conversions to make the headers more
friendly to use in perl.

Currently the conversions are:

=over

=item Convert to lowercase.

=item transmit -> tx

=item receive -> rx

=item frequency -> freq

=item Replace non-word characters to underscores.

=back

=head1 BUGS AND LIMITATIONS

Likely a lot.

=head1 DEPENDENCIES

Perl 5.16 or higher.

=head1 SEE ALSO

