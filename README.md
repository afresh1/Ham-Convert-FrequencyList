# NAME

Ham::Convert::FrequencyList - Convert Frequency List files between formats

# VERSION

version v0.0.1

# SYNOPSIS

    use Ham::Convert::FrequencyList;

# DESCRIPTION

Provides converters between different formats of frequency lists
commonly used to program frequencies into amateur radio equipment.
Different radios use different software to program them,
sometimes just by preference.
Trading frequency lists can be difficult due to these incompatibilities
in the formats and the inability for one piece of software to read
files another.
This code aims to make it easier to convert from one format to another to
ease that pain.

# METHODS

## new

    my $converter = Ham::Convert::FrequencyList->new(
        ...,
    );

## read

    my @list = @{ Ham::Convert::FreqencyList->new->read($file) };

Reads an arrayref of frequencies from a valid argument to
`Text::CSV/in`.
The frequencies returned are a list of hashrefs or undef,
the hashrefs are keyed off the ["internal\_header"](#internal_header) name.

## write

    Ham::Convert::FreqencyList->new->write( $file, \@list );

Writes an arrayref of frequency definitions to the specified `$file`.

## headers

Returns a list of the header names for the columns in the current format.

# INTERNALS

These methods are used by subclasses to set up conversions.

## column\_defs

Returns a list of hashrefs defining the columns expected to be in
the file.

    my $defs = [ $converter->column_defs ];

Now `$defs` could look like:

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

The `in` filter is used by ["read"](#read) to convert to the internal
conversion format.

## is\_empty\_row

    do_something($row) unless $converter->is_empty_row($row);

Takes a parsed row hashref  and returns truthy if it is an "empty" row.

## read\_csv\_params

A hashref of additional parameters to be passed to the ["csv" in Text::CSV](https://metacpan.org/pod/Text%3A%3ACSV#csv)
call.

## write\_csv\_params

This allows subclasses to adjust the parameters passed to
["new" in Text::CSV](https://metacpan.org/pod/Text%3A%3ACSV#new) to control the output of the file.

The default is `eol => "\r\n", quote_space => 0`.

## write\_headers

This boolean indicates whether we should write out the header line
in the CSV file.

## write\_all\_columns

This is a boolean that indicates whether this file type supports
extra columns or whether they are ignored.

Defaults to the value of ["write\_headers"](#write_headers).

## write\_empty\_rows

A boolean value that indicates whether the empty rows should be
included when writing.

## internal\_header

    my $internal_name = $converter->internal_header( $external_name );

Looks up the internal header name from the format specific name.

Also caches the conversion to enable ["external\_header"](#external_header) lookups.

Does this normally by checking the ["column\_defs"](#column_defs) for a matching `name`
and returning the `internal` version if it exists.
Otherwise does some basic conversions to make the headers more
friendly to use in perl.

Currently the conversions are:

- Convert to lowercase.
- transmit -> tx
- receive -> rx
- frequency -> freq
- Replace non-word characters to underscores.

## external\_header

    my $external_name = $converter->external_header( $internal_name );

If the ["internal\_name"](#internal_name) has been calculated,
looks up the external name from the cache.
Otherwise throws an exception.

## filter\_for

    my $filter = $converter->filter_for( in => $internal_header );

Returns a filter, or `undef` if none exists, for the column, looked
up in ["column\_defs"](#column_defs).

# BUGS AND LIMITATIONS

Likely a lot.

# DEPENDENCIES

Perl 5.16 or higher.

[Text::CSV](https://metacpan.org/pod/Text%3A%3ACSV).

# SEE ALSO

# AUTHOR

Andrew Hewus Fresh <andrew@afresh1.com>

# COPYRIGHT AND LICENSE

This software is Copyright (c) 2021 by Andrew Hewus Fresh <andrew@afresh1.com>.

This is free software, licensed under:

    The MIT (X11) License
