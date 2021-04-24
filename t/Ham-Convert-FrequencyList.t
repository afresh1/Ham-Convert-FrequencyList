use Test2::V0
    -target => 'Ham::Convert::FrequencyList',
    qw< ok is subtest diag done_testing >;

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

subtest 'internal_header' => sub {
    my %expect = (
        'Channel No'         => 'channel_no',
        'Receive Frequency'  => 'rx_freq',
        'Transmit Frequency' => 'tx_freq',
        'Offset Frequency'   => 'offset_freq',
        'Offset Direction'   => 'offset_direction',
        'Operating Mode'     => 'operating_mode',
        'Dig / Analog'       => 'dig_analog',
        'Name'               => 'name',
        'User CTCSS'         => 'user_ctcss',
        'RX-DG-ID'           => 'rx_dg_id',
        'TX DG-ID'           => 'tx_dg_id',
        'S-Meter SQL'        => 's_meter_sql',
        'Bank: 1'            => 'bank_1',
    );

    my $c = CLASS->new;
    is $c->internal_header($_), $expect{$_},
        sprintf( "%-20s -> %s", $_, $expect{$_} )
        for sort keys %expect;
};

done_testing;
