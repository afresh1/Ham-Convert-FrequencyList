package Ham::Convert::FrequencyList;
use utf8;     # so literals and identifiers can be in UTF-8
use v5.16;    # to get "unicode_strings" and "charnames"
use warnings;
use warnings qw(FATAL utf8);           # fatalize encoding glitches
use open qw(:std :encoding(UTF-8));    # undeclared streams in UTF-8

use Carp;

# ABSTRACT: Convert Frequency List files between formats
# VERSION

sub new {
    my ( $class, %params ) = @_;
    return bless {%params}, $class;
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

=head1 BUGS AND LIMITATIONS

Likely a lot.

=head1 DEPENDENCIES

Perl 5.16 or higher.

=head1 SEE ALSO

