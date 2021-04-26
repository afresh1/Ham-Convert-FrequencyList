package Ham::Convert::FrequencyList;
use utf8;     # so literals and identifiers can be in UTF-8
use v5.16;    # to get "unicode_strings" and "charnames"
use warnings;
use warnings qw(FATAL utf8);           # fatalize encoding glitches
use open qw(:std :encoding(UTF-8));    # undeclared streams in UTF-8

use Carp;
use List::Util qw< first >;
use Text::CSV qw< csv >;

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

    if ( exists $self->{_header}->{external}->{ $def->{internal} } ) {
        my $external = $self->{_header}->{external}->{ $def->{internal} };
        croak
            "Multiple internal headers named $def->{internal}: $external, $name";
    }

    $self->{_header}->{external}->{ $def->{internal} } = $name;

    return $def->{internal};
}

sub external_header {
    my ( $self, $name ) = @_;

    return $self->{_header}->{external}->{$name}
        if exists $self->{_header}->{external}->{$name};

    croak "No external header mapping for '$name'";
}

sub read {
    my $self = shift;
    my $file = shift;
    croak "Usage: read($file)" if @_;

    my $read = csv(
        {   in      => $file,
            headers => sub { $self->internal_header($_) },
            %{ $self->read_csv_params },
        }
    );

    my $i = 0;
    my @list;
    foreach my $item ( @{$read} ) {
        my $id = delete $item->{id} || $i + 1;
        $i = $id;

        # Don't store empty rows
        next unless first {length} values %{$item};

        foreach my $name ( keys %{$item} ) {
            if ( my $filter = $self->filter_for( in => $name ) ) {
                local $_ = $item->{$name};
                $item->{$name} = $filter->($item);
            }
        }

        $list[ $i - 1 ] = $item;
    }

    return \@list;
}

sub write {
    my ( $self, $file, $list ) = @_;

    my @headers = $self->headers;
    if ( $self->write_all_columns ) {
        @headers = do {
            my %headers = map { $_ => 1 } map { keys %{ $_ || {} } } @{$list};

            my %seen;
            grep    { !$seen{$_}++ } @headers,
                map { $self->external_header($_) }
                sort keys %headers;
        };
    }

    # Can't use csv() here because there's no way to disable
    # printing headers _and_ using hashrefs.
    my $csv = Text::CSV->new( $self->write_csv_params );
    $csv->column_names( map { $self->internal_header($_) } @headers );

    # eww, am I right?  but who wants to reproduce that logic?
    my $fh = $csv->can('_csv_attr')->( { in => [], out => $file } )->{fh};

    $csv->print( $fh, \@headers ) if $self->write_headers;

    my $id = 1;
    foreach my $item ( @{$list} ) {
        my %copy = ( id => $id++ );

        # Don't store empty rows
        next
            unless $self->write_empty_rows
            or first {length} values %{$item};

        foreach my $name ( keys %{$item} ) {
            if ( my $filter = $self->filter_for( out => $name ) ) {
                local $_ = $item->{$name};
                $copy{$name} = $filter->($item);
            }
            else {
                $copy{$name} = $item->{$name};
            }
        }

        $csv->print_hr( $fh, \%copy );
    }
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

sub filter_for {
    my ( $self, $direction, $name ) = @_;

    return $self->{_filter}->{$direction}->{$name} //= do {
        my $def = first { $self->internal_header( $_->{name} ) eq $name }
        $self->column_defs;
        $def ? $def->{$direction} : "";
    };
}

sub read_csv_params    { {} }
sub write_csv_params   { return { eol => "\r\n" } }
sub write_headers      {1}
sub write_all_columns  { $_[0]->write_headers }
sub write_empty_rows   {0}

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

=head2 read

    my @list = @{ Ham::Convert::FreqencyList->new->read($file) };

Reads an arrayref of frequencies from a valid argument to
C<Text::CSV/in>.
The frequencies returned are a list of hashrefs or undef,
the hashrefs are keyed off the L</internal_header> name.

=head2 write

    Ham::Convert::FreqencyList->new->write( $file, \@list );

Writes an arrayref of frequency definitions to the specified C<$file>.

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

The C<in> filter is used by L</read> to convert to the internal
conversion format.

=head2 read_csv_params

A hashref of additional parameters to be passed to the L<Text::CSV/csv>
call.

=head2 write_csv_params

This allows subclasses to adjust the parameters passed to
L<Text::CSV/new> to control the output of the file.

The default is C<< eol => "\r\n" >>.

=head2 write_headers

This boolean indicates whether we should write out the header line
in the CSV file.

=head2 write_all_columns

This is a boolean that indicates whether this file type supports
extra columns or whether they are ignored.

Defaults to the value of L</write_headers>.

=head2 write_empty_rows

A boolean value that indicates whether the empty rows should be
included when writing.

=head2 internal_header

    my $internal_name = $converter->internal_header( $external_name );

Looks up the internal header name from the format specific name.

Also caches the conversion to enable L</external_header> lookups.

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

=head2 external_header

    my $external_name = $converter->external_header( $internal_name );

If the L</internal_name> has been calculated,
looks up the external name from the cache.
Otherwise throws an exception.

=head2 filter_for

    my $filter = $converter->filter_for( in => $internal_header );

Returns a filter, or C<undef> if none exists, for the column, looked
up in L</column_defs>.

=head1 BUGS AND LIMITATIONS

Likely a lot.

=head1 DEPENDENCIES

Perl 5.16 or higher.

L<Text::CSV>.

=head1 SEE ALSO

