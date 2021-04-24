use Test2::V0 -target => 'Ham::Convert::FrequencyList',
    qw< ok is diag done_testing >;

diag "Testing $CLASS on perl $^V";

ok CLASS, "Loaded $CLASS";

ok my $converter = CLASS->new, "Created a new $CLASS instance";

is [ $converter->headers ], [ qw<
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

    groups
> ];

done_testing;
