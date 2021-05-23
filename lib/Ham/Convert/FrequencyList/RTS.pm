package Ham::Convert::FrequencyList::RTS;
use parent 'Ham::Convert::FrequencyList';
use utf8;     # so literals and identifiers can be in UTF-8
use v5.16;    # to get "unicode_strings" and "charnames"
use warnings;
use warnings qw(FATAL utf8);           # fatalize encoding glitches
use open qw(:std :encoding(UTF-8));    # undeclared streams in UTF-8

use Carp;

use List::Util qw< first >;

# ABSTRACT: Convert Frequency List files for RT Systems software
# VERSION

sub _set_encoding {
    my ( $self, $file, @extra ) = @_;
    my $encoding = "iso-8859-1";

    my $is_fh = sub {
        local $@;
        eval {
            local $SIG{__DIE__};
            defined fileno( $_[0] );
        };
    };

    if ( not ref $file and -e $file ) {
        open my $fh, "<:encoding($encoding)", $file
            or croak "Unable to open $file: $!";
        $file = $fh;
    }
    elsif ( $is_fh->($file) ) {
        $file->binmode(":encoding($encoding)");
    }

    return ( $file, @extra );
}

sub read  { my $s = shift; $s->next::method( $s->_set_encoding(@_) ) }
sub write { my $s = shift; $s->next::method( $s->_set_encoding(@_) ) }

# 1,146.84000,146.24000,600 kHz,Minus,FM,MC 1,None,88.5 Hz,88.5 Hz,023,Off,5 kHz,Multnomah Primary Repeater  - Command Net - Larch Mt. - WA,5 kHz,

sub column_defs {
    return (
        { name => 'Channel Number', internal => 'id' },
        { name => 'Receive Frequency' },
        { name => 'Transmit Frequency' },
        { name => 'Offset Frequency' },
        { name => 'Offset Direction' },
        { name => 'Operating Mode' },
        { name => 'Name' },
        { name => 'Tone Mode' },
        { name => 'CTCSS' },
        { name => 'Rx CTCSS' },
        { name => 'DCS' },
        { name => 'Skip' },
        { name => 'Step' },
        { name => 'Comment' },
        { name => 'Tx Step' },
        { name => '', internal => 'terminator' },
    );
}

sub write_csv_params {
    return (
        shift->next::method(@_),
        eol          => "\n",
        binary       => 1,
        quote_binary => 0,
    );
}

1;
__END__

=head1 SYNOPSIS

    use Ham::Convert::FrequencyList::RTS;

=head1 DESCRIPTION

Reads and writes files in RT Systems software CSV format.

You can download the software for free from L<https://www.rtsystemsinc.com>.

=head1 METHODS

All inherited from L<Ham::Convert::FrequencyList>.

=head2 read

Adjusts the encoding to be C<iso-8859-1> reading filenames or filehandles.

=head2 write

Adjusts the encoding to be C<iso-8859-1> when writing filenames or filehandles.

=head1 INTERNALS

These methods are used by subclasses to set up conversions.

=head2 column_defs

Includes custom definitions for converting to and from the standard
format used by L<Ham::Convert::FrequencyList>.

=head2 is_empty_row

Adjusts for the fact that the C<terminator> is always "0".

=head2 write_headers

Sets the line endings to be C<\n>, and attempts to disable quoting
binary characters.

TODO: This doesn't actually work, it wants to quote those characters
no matter what I do.

=head1 BUGS AND LIMITATIONS

Likely a lot.

At least the fact that it over-quotes things.
I expect that RTS will still import them, but I don't actually have
any of their software.

=head1 SEE ALSO

L<Ham::Convert::FrequencyList>

L<The RT Systems Knowledge Base|https://www.rtsystemsinc.com/knowledgebase.html>

