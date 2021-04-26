package Ham::Convert::FrequencyList::Chirp;
use parent 'Ham::Convert::FrequencyList';
use utf8;     # so literals and identifiers can be in UTF-8
use v5.16;    # to get "unicode_strings" and "charnames"
use warnings;
use warnings qw(FATAL utf8);           # fatalize encoding glitches
use open qw(:std :encoding(UTF-8));    # undeclared streams in UTF-8

use Carp;

# ABSTRACT: Convert Frequency List files from Chirp
# VERSION

sub column_defs {
    my @defs = (
        { name => 'Location', internal => 'id' },
        { name => 'Name' },
        { name => 'Frequency', internal => 'tx_freq' },
        { name => 'Duplex' },
        { name => 'Offset', internal => 'rx_freq' },
        { name => 'Tone' },
        { name => 'rToneFreq',    internal => 'ctcss' },
        { name => 'cToneFreq',    internal => 'rx_ctcss' },
        { name => 'DtcsCode',     internal => 'dtcsc' },
        { name => 'DtcsPolarity', internal => 'dtcsp' },
        { name => 'Mode' },
        { name => 'TStep' },
        { name => 'Skip' },
        { name => 'Comment' },
        { name => 'URCALL' },
        { name => 'RPT1CALL' },
        { name => 'RPT2CALL' },
        { name => 'DVCODE' },
    );

    return @defs;
}

1;
__END__

=head1 SYNOPSIS

    use Ham::Convert::FrequencyList::Chirp;

=head1 DESCRIPTION

Reads and writes files in the Chirp CSV format.

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
