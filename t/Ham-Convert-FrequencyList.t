use Test2::V0
    -target => 'Ham::Convert::FrequencyList',
    qw< ok is like subtest dies diag done_testing >;

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

subtest 'header map' => sub {
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

    like dies { $c->external_header('Receive Frequency') },
        qr/^\QNo external header mapping for 'Receive Frequency' at /,
        "Looking up external_header dies before initialization";

    is $c->internal_header($_), $expect{$_},
        sprintf( "internal_header: %-20s -> %s", $_, $expect{$_} )
        for sort keys %expect;

    is $c->external_header( $expect{$_} ), $_,
        sprintf( "external_header: %-20s -> %s", $_, $expect{$_} )
        for sort keys %expect;

    like dies { $c->external_header('Another Header') },
        qr/^\QNo external header mapping for 'Another Header' at /,
        "Looking up uninitialized external_header still dies";

    like dies { $c->internal_header('RX Freq') },
        qr/^\QMultiple internal headers named rx_freq: Receive Frequency, RX Freq at /,
        "Looking up two headers that map to the same internal header dies";
};

is $converter->read( \*DATA ), [
    {   'bar'     => 'B',
        'comment' => 'Repeater comment, with a comma',
        'ctcss'   => '167.9',
        'dtcsc'   => '023',
        'dtcsp'   => 'NN',
        'foo'     => 'A',
        'tx_freq' => '440.300000',
        'rx_freq' => '5.000000',
        'duplex'  => '+',
        'groups'  => [ 1, 1, '', 1 ],
        'mode'    => 'FM',
        'name'    => 'KC7MZM',
    },
    undef, undef, undef, undef, undef, undef, undef,
    {   'bar'     => 'Y',
        'comment' => 'Sample repeater in Portland',
        'ctcss'   => '',
        'dtcsc'   => '023',
        'dtcsp'   => 'NN',
        'foo'     => 'X',
        'tx_freq' => '145.230000',
        'rx_freq' => '0.600000',
        'duplex'  => '-',
        'groups'  => [ '', '', 1, '', 1 ],
        'mode'    => 'FM',
        'name'    => 'K7LJ',
    },
], "Parsed the data into the expected format";

done_testing;
__DATA__
id,tx_freq,rx_freq,duplex,ctcss,dtcsc,dtcsp,mode,name,comment,groups,foo,bar
1,440.300000,5.000000,+,167.9,023,NN,FM,KC7MZM,"Repeater comment, with a comma",1:1::1,A,B
3,,,,,,,,0,,
5,,,,,,,,,,,
9,145.230000,0.600000,-,,023,NN,FM,K7LJ,Sample repeater in Portland,::1::1,X,Y
11,
12,,,,,,
