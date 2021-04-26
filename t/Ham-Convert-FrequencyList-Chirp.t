use Test2::V0
    -target => 'Ham::Convert::FrequencyList::Chirp',
    qw< ok is like subtest dies diag done_testing >;

diag "Testing $CLASS on perl $^V";

ok CLASS, "Loaded $CLASS";

ok my $converter = CLASS->new, "Created a new $CLASS instance";

is [ $converter->headers ], [ qw<
    Location
    Name
    Frequency
    Duplex
    Offset
    Tone
    rToneFreq
    cToneFreq
    DtcsCode
    DtcsPolarity
    Mode
    TStep
    Skip
    Comment
    URCALL
    RPT1CALL
    RPT2CALL
    DVCODE
> ], "Found expected headers";

my $parsed = $converter->read( \*DATA );

is $parsed,
    [
    {   'comment'  => '',
        'ctcss'    => '88.5',
        'dtcsc'    => '23',
        'dtcsp'    => 'NN',
        'duplex'   => '-',
        'dvcode'   => '',
        'mode'     => 'FM',
        'name'     => 'MC 1',
        'rpt1call' => '',
        'rpt2call' => '',
        'rx_ctcss' => '88.5',
        'rx_freq'  => '0.6',
        'skip'     => '',
        'tone'     => '',
        'tstep'    => '5',
        'tx_freq'  => '146.84',
        'urcall'   => ''
    },
    {   'comment'  => '',
        'ctcss'    => '167.9',
        'dtcsc'    => '23',
        'dtcsp'    => 'NN',
        'duplex'   => '+',
        'dvcode'   => '',
        'mode'     => 'FM',
        'name'     => 'MC 2',
        'rpt1call' => '',
        'rpt2call' => '',
        'rx_ctcss' => '88.5',
        'rx_freq'  => '0.6',
        'skip'     => '',
        'tone'     => 'Tone',
        'tstep'    => '5',
        'tx_freq'  => '147.28',
        'urcall'   => ''
    },
    undef,
    {   'comment'  => '',
        'ctcss'    => '88.5',
        'dtcsc'    => '23',
        'dtcsp'    => 'NN',
        'duplex'   => '',
        'dvcode'   => '',
        'mode'     => 'FM',
        'name'     => 'MC 4',
        'rpt1call' => '',
        'rpt2call' => '',
        'rx_ctcss' => '88.5',
        'rx_freq'  => '0.6',
        'skip'     => '',
        'tone'     => '',
        'tstep'    => '5',
        'tx_freq'  => '146.48',
        'urcall'   => ''
    },
    (undef) x 11,
    {   'comment'  => '',
        'ctcss'    => '123',
        'dtcsc'    => '23',
        'dtcsp'    => 'NN',
        'duplex'   => '+',
        'dvcode'   => '',
        'mode'     => 'FM',
        'name'     => 'W7RAT',
        'rpt1call' => '',
        'rpt2call' => '',
        'rx_ctcss' => '88.5',
        'rx_freq'  => '5',
        'skip'     => 'S',
        'tone'     => 'Tone',
        'tstep'    => '25',
        'tx_freq'  => '440.4',
        'urcall'   => ''
    },
    (undef) x 81,
    {   'comment'  => '',
        'ctcss'    => '88.5',
        'dtcsc'    => '23',
        'dtcsp'    => 'NN',
        'duplex'   => '-',
        'dvcode'   => '',
        'mode'     => 'FM',
        'name'     => 'D1-2',
        'rpt1call' => '',
        'rpt2call' => '',
        'rx_ctcss' => '88.5',
        'rx_freq'  => '0.6',
        'skip'     => 'S',
        'tone'     => '',
        'tstep'    => '5',
        'tx_freq'  => '146.84',
        'urcall'   => ''
    },
    {   'comment'  => '',
        'ctcss'    => '186.2',
        'dtcsc'    => '23',
        'dtcsp'    => 'NN',
        'duplex'   => '-',
        'dvcode'   => '',
        'mode'     => 'FM',
        'name'     => 'OEM 1',
        'rpt1call' => '',
        'rpt2call' => '',
        'rx_ctcss' => '88.5',
        'rx_freq'  => '0.6',
        'skip'     => 'S',
        'tone'     => 'Tone',
        'tstep'    => '5',
        'tx_freq'  => '145.33',
        'urcall'   => ''
    },
    {   'comment'  => '',
        'ctcss'    => '88.5',
        'dtcsc'    => '23',
        'dtcsp'    => 'NN',
        'duplex'   => '-',
        'dvcode'   => '',
        'mode'     => 'FM',
        'name'     => 'RED C1',
        'rpt1call' => '',
        'rpt2call' => '',
        'rx_ctcss' => '88.5',
        'rx_freq'  => '0.6',
        'skip'     => 'S',
        'tone'     => 'DTCS',
        'tstep'    => '5',
        'tx_freq'  => '146.98',
        'urcall'   => ''
    },
    (undef) x 399,
    {   'comment'  => '',
        'ctcss'    => '88.5',
        'dtcsc'    => '23',
        'dtcsp'    => 'NN',
        'duplex'   => '',
        'dvcode'   => '',
        'mode'     => 'FM',
        'name'     => 'STD105',
        'rpt1call' => '',
        'rpt2call' => '',
        'rx_ctcss' => '88.5',
        'rx_freq'  => '0.6',
        'skip'     => 'S',
        'tone'     => '',
        'tstep'    => '5',
        'tx_freq'  => '146.52',
        'urcall'   => ''
    }
    ],
    "Parsed the data into the expected format";

my $expect = do { local $/; readline DATA };

$converter->write( \my $output, $parsed );

# This is the exact same, but column 2 is quoted
my @expect = (
    'Location,Name,Frequency,Duplex,Offset,Tone,rToneFreq,cToneFreq,DtcsCode,DtcsPolarity,Mode,TStep,Skip,Comment,URCALL,RPT1CALL,RPT2CALL,DVCODE',
    '1,"MC 1",146.84,-,0.6,,88.5,88.5,23,NN,FM,5,,,,,,',
    '2,"MC 2",147.28,+,0.6,Tone,167.9,88.5,23,NN,FM,5,,,,,,',
    '4,"MC 4",146.48,,0.6,,88.5,88.5,23,NN,FM,5,,,,,,',
    '16,W7RAT,440.4,+,5,Tone,123,88.5,23,NN,FM,25,S,,,,,',
    '98,D1-2,146.84,-,0.6,,88.5,88.5,23,NN,FM,5,S,,,,,',
    '99,"OEM 1",145.33,-,0.6,Tone,186.2,88.5,23,NN,FM,5,S,,,,,',
    '100,"RED C1",146.98,-,0.6,DTCS,88.5,88.5,23,NN,FM,5,S,,,,,',
    '500,STD105,146.52,,0.6,,88.5,88.5,23,NN,FM,5,S,,,,,',
);

is [ split /\r\n/, $output ], \@expect, "Wrote the CSV file we expected";

done_testing;
__DATA__
Location,Name,Frequency,Duplex,Offset,Tone,rToneFreq,cToneFreq,DtcsCode,DtcsPolarity,Mode,TStep,Skip,Comment,URCALL,RPT1CALL,RPT2CALL,DVCODE
1,MC 1,146.84,-,0.6,,88.5,88.5,23,NN,FM,5,,,,,,
2,MC 2,147.28,+,0.6,Tone,167.9,88.5,23,NN,FM,5,,,,,,
4,MC 4,146.48,,0.6,,88.5,88.5,23,NN,FM,5,,,,,,
16,W7RAT,440.4,+,5,Tone,123,88.5,23,NN,FM,25,S,,,,,
98,D1-2,146.84,-,0.6,,88.5,88.5,23,NN,FM,5,S,,,,,
99,OEM 1,145.33,-,0.6,Tone,186.2,88.5,23,NN,FM,5,S,,,,,
100,RED C1,146.98,-,0.6,DTCS,88.5,88.5,23,NN,FM,5,S,,,,,
500,STD105,146.52,,0.6,,88.5,88.5,23,NN,FM,5,S,,,,,
