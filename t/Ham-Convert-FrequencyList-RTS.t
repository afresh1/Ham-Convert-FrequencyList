use Test2::V0
    -target => 'Ham::Convert::FrequencyList::RTS',
    qw< ok is like subtest dies diag done_testing >;

diag "Testing $CLASS on perl $^V";

ok CLASS, "Loaded $CLASS";

ok my $converter = CLASS->new, "Created a new $CLASS instance";

my @headers = (
    'Channel Number',
    'Receive Frequency',
    'Transmit Frequency',
    'Offset Frequency',
    'Offset Direction',
    'Operating Mode',
    'Name',
    'Tone Mode',
    'CTCSS',
    'Rx CTCSS',
    'DCS',
    'Skip',
    'Step',
    'Comment',
    'Tx Step',
    '',
);

is [ $converter->headers ], \@headers, "Found expected headers";

my $location = DATA->tell;

my $parsed = $converter->read( \*DATA );
is $parsed, [
    {   'comment' =>
            'Multnomah Primary Repeater  - Command Net - Larch Mt. - WA',
        'ctcss'            => '88.5 Hz',
        'dcs'              => '023',
        'name'             => 'MC 1',
        'offset_direction' => 'Minus',
        'offset_freq'      => '600 kHz',
        'operating_mode'   => 'FM',
        'rx_ctcss'         => '88.5 Hz',
        'rx_freq'          => '146.84000',
        'skip'             => 'Off',
        'step'             => '5 kHz',
        'terminator'       => '',
        'tone_mode'        => 'None',
        'tx_freq'          => '146.24000',
        'tx_step'          => '5 kHz'
    },
    {   'comment' =>
            'Multnomah Secondary Repeater - Resource Net - Mt. Scott',
        'ctcss'            => '167.9 Hz',
        'dcs'              => '023',
        'name'             => 'MC 2',
        'offset_direction' => 'Plus',
        'offset_freq'      => '600 kHz',
        'operating_mode'   => 'FM',
        'rx_ctcss'         => '88.5 Hz',
        'rx_freq'          => '147.28000',
        'skip'             => 'Off',
        'step'             => '5 kHz',
        'terminator'       => '',
        'tone_mode'        => 'Tone',
        'tx_freq'          => '147.88000',
        'tx_step'          => '5 kHz'
    },
    {   'comment'          => 'Multnomah Tertiary Repeater - Mt. Scott',
        'ctcss'            => '88.5 Hz',
        'dcs'              => '023',
        'name'             => 'MC 3',
        'offset_direction' => 'Minus',
        'offset_freq'      => '600 kHz',
        'operating_mode'   => 'FM',
        'rx_ctcss'         => '88.5 Hz',
        'rx_freq'          => '146.94000',
        'skip'             => 'Off',
        'step'             => '5 kHz',
        'terminator'       => '',
        'tone_mode'        => 'None',
        'tx_freq'          => '146.34000',
        'tx_step'          => '5 kHz'
    },
    {   'comment'          => 'Multnomah Primary Simplex - Command',
        'ctcss'            => '88.5 Hz',
        'dcs'              => '023',
        'name'             => 'MC 4',
        'offset_direction' => 'Simplex',
        'offset_freq'      => ' ',
        'operating_mode'   => 'FM',
        'rx_ctcss'         => '88.5 Hz',
        'rx_freq'          => '146.48000',
        'skip'             => 'Off',
        'step'             => '5 kHz',
        'terminator'       => '',
        'tone_mode'        => 'None',
        'tx_freq'          => '146.48000',
        'tx_step'          => '5 kHz'
    },
    {   'comment'          => 'Multnomah Secondary Simplex - Tactical',
        'ctcss'            => '88.5 Hz',
        'dcs'              => '023',
        'name'             => 'MC 5',
        'offset_direction' => 'Simplex',
        'offset_freq'      => ' ',
        'operating_mode'   => 'FM',
        'rx_ctcss'         => '88.5 Hz',
        'rx_freq'          => '146.40000',
        'skip'             => 'Off',
        'step'             => '5 kHz',
        'terminator'       => '',
        'tone_mode'        => 'None',
        'tx_freq'          => '146.40000',
        'tx_step'          => '5 kHz'
    },
    {   'comment'          => 'Multnomah Delta Repeater - KOIN Tower',
        'ctcss'            => '100.0 Hz',
        'dcs'              => '023',
        'name'             => 'MC 6',
        'offset_direction' => 'Plus',
        'offset_freq'      => '600 kHz',
        'operating_mode'   => 'FM',
        'rx_ctcss'         => '88.5 Hz',
        'rx_freq'          => '147.04000',
        'skip'             => 'On',
        'step'             => '5 kHz',
        'terminator'       => '',
        'tone_mode'        => 'Tone',
        'tx_freq'          => '147.64000',
        'tx_step'          => '5 kHz'
    },
    {   'comment'          => 'Gresham Simplex',
        'ctcss'            => '88.5 Hz',
        'dcs'              => '023',
        'name'             => 'MC 7',
        'offset_direction' => 'Simplex',
        'offset_freq'      => ' ',
        'operating_mode'   => 'FM',
        'rx_ctcss'         => '88.5 Hz',
        'rx_freq'          => '147.56000',
        'skip'             => 'On',
        'step'             => '5 kHz',
        'terminator'       => '',
        'tone_mode'        => 'None',
        'tx_freq'          => '147.56000',
        'tx_step'          => '5 kHz'
    },
    {   'comment' => 'NET-Tac 1 Portland Bureau of Emergency Management',
        'ctcss'   => '88.5 Hz',
        'dcs'     => '023',
        'name'    => 'MC 8',
        'offset_direction' => 'Simplex',
        'offset_freq'      => ' ',
        'operating_mode'   => 'FM',
        'rx_ctcss'         => '88.5 Hz',
        'rx_freq'          => '147.58000',
        'skip'             => 'On',
        'step'             => '5 kHz',
        'terminator'       => '',
        'tone_mode'        => 'None',
        'tx_freq'          => '147.58000',
        'tx_step'          => '5 kHz'
    },
    {   'comment' => 'NET-Tac 2 Portland Bureau of Emergency Management',
        'ctcss'   => '88.5 Hz',
        'dcs'     => '023',
        'name'    => 'MC 9',
        'offset_direction' => 'Simplex',
        'offset_freq'      => ' ',
        'operating_mode'   => 'FM',
        'rx_ctcss'         => '88.5 Hz',
        'rx_freq'          => '146.46000',
        'skip'             => 'On',
        'step'             => '5 kHz',
        'terminator'       => '',
        'tone_mode'        => 'None',
        'tx_freq'          => '146.46000',
        'tx_step'          => '5 kHz'
    },
    {   'comment' =>
            "RMS K7MCE-10\x{a0}/ EOC: k7mce\@winlink.org - KF7LJH-10  NE PDX",
        'ctcss'            => '88.5 Hz',
        'dcs'              => '023',
        'name'             => 'MC 10',
        'offset_direction' => 'Simplex',
        'offset_freq'      => ' ',
        'operating_mode'   => 'FM',
        'rx_ctcss'         => '88.5 Hz',
        'rx_freq'          => '145.07000',
        'skip'             => 'On',
        'step'             => '5 kHz',
        'terminator'       => '',
        'tone_mode'        => 'None',
        'tx_freq'          => '145.07000',
        'tx_step'          => '5 kHz'
    },
    {   'comment'          => "Multnomah UHF Simplex\x{a0}",
        'ctcss'            => '88.5 Hz',
        'dcs'              => '023',
        'name'             => 'MC 11',
        'offset_direction' => 'Simplex',
        'offset_freq'      => ' ',
        'operating_mode'   => 'FM',
        'rx_ctcss'         => '88.5 Hz',
        'rx_freq'          => '432.15000',
        'skip'             => 'Off',
        'step'             => '25 kHz',
        'terminator'       => '',
        'tone_mode'        => 'None',
        'tx_freq'          => '432.15000',
        'tx_step'          => '5 kHz'
    },
    {   'comment' => 'Multnomah Resource Net Simplex if MC2 is off-line',
        'ctcss'   => '88.5 Hz',
        'dcs'     => '023',
        'name'    => 'MC 12',
        'offset_direction' => 'Simplex',
        'offset_freq'      => ' ',
        'operating_mode'   => 'FM',
        'rx_ctcss'         => '88.5 Hz',
        'rx_freq'          => '147.28000',
        'skip'             => 'On',
        'step'             => '5 kHz',
        'terminator'       => '',
        'tone_mode'        => 'None',
        'tx_freq'          => '147.28000',
        'tx_step'          => '5 kHz'
    },
    {   'comment'          => 'Multnomah Portable UHF Repeater - CTCSS 151.4',
        'ctcss'            => '151.4 Hz',
        'dcs'              => '023',
        'name'             => 'MC 13',
        'offset_direction' => 'Plus',
        'offset_freq'      => '5.00 MHz',
        'operating_mode'   => 'FM',
        'rx_ctcss'         => '151.4 Hz',
        'rx_freq'          => '440.27500',
        'skip'             => 'Off',
        'step'             => '25 kHz',
        'terminator'       => '',
        'tone_mode'        => 'T Sql',
        'tx_freq'          => '445.27500',
        'tx_step'          => '5 kHz'
    },
    {   'comment'          => 'Multnomah Crossband Repeater',
        'ctcss'            => '151.4 Hz',
        'dcs'              => '023',
        'name'             => 'MC 14',
        'offset_direction' => 'Simplex',
        'offset_freq'      => ' ',
        'operating_mode'   => 'FM',
        'rx_ctcss'         => '88.5 Hz',
        'rx_freq'          => '446.15000',
        'skip'             => 'Off',
        'step'             => '25 kHz',
        'terminator'       => '',
        'tone_mode'        => 'Tone',
        'tx_freq'          => '446.15000',
        'tx_step'          => '5 kHz'
    },
    {   'comment'          => 'Automatic Packet Reporting System',
        'ctcss'            => '88.5 Hz',
        'dcs'              => '023',
        'name'             => 'APRS',
        'offset_direction' => 'Simplex',
        'offset_freq'      => ' ',
        'operating_mode'   => 'FM',
        'rx_ctcss'         => '88.5 Hz',
        'rx_freq'          => '144.39000',
        'skip'             => 'On',
        'step'             => '5 kHz',
        'terminator'       => '',
        'tone_mode'        => 'None',
        'tx_freq'          => '144.39000',
        'tx_step'          => '5 kHz'
    },
    {   'comment'          => 'MMSSTV - ARES Digital - KOIN Tower',
        'ctcss'            => '123.0 Hz',
        'dcs'              => '023',
        'name'             => 'W7RAT',
        'offset_direction' => 'Plus',
        'offset_freq'      => '5.00 MHz',
        'operating_mode'   => 'FM',
        'rx_ctcss'         => '88.5 Hz',
        'rx_freq'          => '440.40000',
        'skip'             => 'On',
        'step'             => '25 kHz',
        'terminator'       => '',
        'tone_mode'        => 'Tone',
        'tx_freq'          => '445.40000',
        'tx_step'          => '5 kHz'
    },
    undef, undef, undef, undef,
    {   'comment' => 'Clackamas Primary Repeater  [OEM Monitored]  - Mt Hood',
        'ctcss'   => '100.0 Hz',
        'dcs'     => '023',
        'name'    => 'CLAC 1',
        'offset_direction' => 'Plus',
        'offset_freq'      => '600 kHz',
        'operating_mode'   => 'FM',
        'rx_ctcss'         => '88.5 Hz',
        'rx_freq'          => '147.12000',
        'skip'             => 'Off',
        'step'             => '5 kHz',
        'terminator'       => '',
        'tone_mode'        => 'Tone',
        'tx_freq'          => '147.72000',
        'tx_step'          => '5 kHz'
    },
    {   'comment'          => 'Clackamas Secondary Repeater',
        'ctcss'            => '107.2 Hz',
        'dcs'              => '023',
        'name'             => 'CLAC 2',
        'offset_direction' => 'Plus',
        'offset_freq'      => '600 kHz',
        'operating_mode'   => 'FM',
        'rx_ctcss'         => '88.5 Hz',
        'rx_freq'          => '147.14000',
        'skip'             => 'On',
        'step'             => '5 kHz',
        'terminator'       => '',
        'tone_mode'        => 'Tone',
        'tx_freq'          => '147.74000',
        'tx_step'          => '5 kHz'
    },
    {   'comment'          => 'Clackamas Primary Simplex',
        'ctcss'            => '88.5 Hz',
        'dcs'              => '023',
        'name'             => 'CLAC 3',
        'offset_direction' => 'Simplex',
        'offset_freq'      => ' ',
        'operating_mode'   => 'FM',
        'rx_ctcss'         => '88.5 Hz',
        'rx_freq'          => '146.41500',
        'skip'             => 'On',
        'step'             => '5 kHz',
        'terminator'       => '',
        'tone_mode'        => 'None',
        'tx_freq'          => '146.41500',
        'tx_step'          => '5 kHz'
    },
    {   'comment'          => 'Clackamas Tertiary Repeater (W7OTV)',
        'ctcss'            => '127.3 Hz',
        'dcs'              => '023',
        'name'             => 'CLAC 4',
        'offset_direction' => 'Minus',
        'offset_freq'      => '600 kHz',
        'operating_mode'   => 'FM',
        'rx_ctcss'         => '88.5 Hz',
        'rx_freq'          => '146.96000',
        'skip'             => 'On',
        'step'             => '5 kHz',
        'terminator'       => '',
        'tone_mode'        => 'Tone',
        'tx_freq'          => '146.36000',
        'tx_step'          => '5 kHz'
    },
    {   'comment'          => 'Clackamas South County ARES Repeater',
        'ctcss'            => '107.2 Hz',
        'dcs'              => '023',
        'name'             => 'CLAC 5',
        'offset_direction' => 'Minus',
        'offset_freq'      => '600 kHz',
        'operating_mode'   => 'FM',
        'rx_ctcss'         => '88.5 Hz',
        'rx_freq'          => '146.92000',
        'skip'             => 'On',
        'step'             => '5 kHz',
        'terminator'       => '',
        'tone_mode'        => 'Tone',
        'tx_freq'          => '146.32000',
        'tx_step'          => '5 kHz'
    },
    {   'comment'          => 'Clackamas South County ARES Simplex',
        'ctcss'            => '88.5 Hz',
        'dcs'              => '023',
        'name'             => 'CLAC 6',
        'offset_direction' => 'Simplex',
        'offset_freq'      => ' ',
        'operating_mode'   => 'FM',
        'rx_ctcss'         => '88.5 Hz',
        'rx_freq'          => '146.58000',
        'skip'             => 'On',
        'step'             => '5 kHz',
        'terminator'       => '',
        'tone_mode'        => 'None',
        'tx_freq'          => '146.58000',
        'tx_step'          => '5 kHz'
    },
    {   'comment'          => 'Oregon City ARES Repeater',
        'ctcss'            => '103.5 Hz',
        'dcs'              => '023',
        'name'             => 'CLAC 7',
        'offset_direction' => 'Plus',
        'offset_freq'      => '5.00 MHz',
        'operating_mode'   => 'FM',
        'rx_ctcss'         => '88.5 Hz',
        'rx_freq'          => '442.07500',
        'skip'             => 'On',
        'step'             => '25 kHz',
        'terminator'       => '',
        'tone_mode'        => 'Tone',
        'tx_freq'          => '447.07500',
        'tx_step'          => '5 kHz'
    },
    {   'comment'          => 'Oregon City ARES Simplex',
        'ctcss'            => '88.5 Hz',
        'dcs'              => '023',
        'name'             => 'CLAC 8',
        'offset_direction' => 'Simplex',
        'offset_freq'      => ' ',
        'operating_mode'   => 'FM',
        'rx_ctcss'         => '88.5 Hz',
        'rx_freq'          => '146.56000',
        'skip'             => 'On',
        'step'             => '5 kHz',
        'terminator'       => '',
        'tone_mode'        => 'None',
        'tx_freq'          => '146.56000',
        'tx_step'          => '5 kHz'
    }
], "Parsed the data into the expected format";

$converter->write( \my $output, $parsed );

DATA->seek( $location, 0 );
DATA->binmode;
my @expect = ( readline DATA );
chomp @expect;

# Not sure why it wants to quote the non-breaking space when I set
# "quote_binary" falsy.
for my $i ( 10, 11 ) {
    $expect[$i] = join ',', map { @{$_} }
        map { $_->[13] = qq{"$_->[13]"}; $_ }
        map { [ split /,/, $_, -1 ] } $expect[$i];
}

is [ split /\r\n/, $output ], \@expect, "Wrote the CSV file we expected";

$output = '';
$converter->write( \$output, [] );
is [ split /\r\n/, $output ],
    [ join ",", @headers ],
    "An empty list still writes the default first row";

done_testing;

__DATA__
Channel Number,Receive Frequency,Transmit Frequency,Offset Frequency,Offset Direction,Operating Mode,Name,Tone Mode,CTCSS,Rx CTCSS,DCS,Skip,Step,Comment,Tx Step,
1,146.84000,146.24000,600 kHz,Minus,FM,MC 1,None,88.5 Hz,88.5 Hz,023,Off,5 kHz,Multnomah Primary Repeater  - Command Net - Larch Mt. - WA,5 kHz,
2,147.28000,147.88000,600 kHz,Plus,FM,MC 2,Tone,167.9 Hz,88.5 Hz,023,Off,5 kHz,Multnomah Secondary Repeater - Resource Net - Mt. Scott,5 kHz,
3,146.94000,146.34000,600 kHz,Minus,FM,MC 3,None,88.5 Hz,88.5 Hz,023,Off,5 kHz,Multnomah Tertiary Repeater - Mt. Scott,5 kHz,
4,146.48000,146.48000, ,Simplex,FM,MC 4,None,88.5 Hz,88.5 Hz,023,Off,5 kHz,Multnomah Primary Simplex - Command,5 kHz,
5,146.40000,146.40000, ,Simplex,FM,MC 5,None,88.5 Hz,88.5 Hz,023,Off,5 kHz,Multnomah Secondary Simplex - Tactical,5 kHz,
6,147.04000,147.64000,600 kHz,Plus,FM,MC 6,Tone,100.0 Hz,88.5 Hz,023,On,5 kHz,Multnomah Delta Repeater - KOIN Tower,5 kHz,
7,147.56000,147.56000, ,Simplex,FM,MC 7,None,88.5 Hz,88.5 Hz,023,On,5 kHz,Gresham Simplex,5 kHz,
8,147.58000,147.58000, ,Simplex,FM,MC 8,None,88.5 Hz,88.5 Hz,023,On,5 kHz,NET-Tac 1 Portland Bureau of Emergency Management,5 kHz,
9,146.46000,146.46000, ,Simplex,FM,MC 9,None,88.5 Hz,88.5 Hz,023,On,5 kHz,NET-Tac 2 Portland Bureau of Emergency Management,5 kHz,
10,145.07000,145.07000, ,Simplex,FM,MC 10,None,88.5 Hz,88.5 Hz,023,On,5 kHz,RMS K7MCE-10?/ EOC: k7mce@winlink.org - KF7LJH-10  NE PDX,5 kHz,
11,432.15000,432.15000, ,Simplex,FM,MC 11,None,88.5 Hz,88.5 Hz,023,Off,25 kHz,Multnomah UHF Simplex?,5 kHz,
12,147.28000,147.28000, ,Simplex,FM,MC 12,None,88.5 Hz,88.5 Hz,023,On,5 kHz,Multnomah Resource Net Simplex if MC2 is off-line,5 kHz,
13,440.27500,445.27500,5.00 MHz,Plus,FM,MC 13,T Sql,151.4 Hz,151.4 Hz,023,Off,25 kHz,Multnomah Portable UHF Repeater - CTCSS 151.4,5 kHz,
14,446.15000,446.15000, ,Simplex,FM,MC 14,Tone,151.4 Hz,88.5 Hz,023,Off,25 kHz,Multnomah Crossband Repeater,5 kHz,
15,144.39000,144.39000, ,Simplex,FM,APRS,None,88.5 Hz,88.5 Hz,023,On,5 kHz,Automatic Packet Reporting System,5 kHz,
16,440.40000,445.40000,5.00 MHz,Plus,FM,W7RAT,Tone,123.0 Hz,88.5 Hz,023,On,25 kHz,MMSSTV - ARES Digital - KOIN Tower,5 kHz,
21,147.12000,147.72000,600 kHz,Plus,FM,CLAC 1,Tone,100.0 Hz,88.5 Hz,023,Off,5 kHz,Clackamas Primary Repeater  [OEM Monitored]  - Mt Hood,5 kHz,
22,147.14000,147.74000,600 kHz,Plus,FM,CLAC 2,Tone,107.2 Hz,88.5 Hz,023,On,5 kHz,Clackamas Secondary Repeater,5 kHz,
23,146.41500,146.41500, ,Simplex,FM,CLAC 3,None,88.5 Hz,88.5 Hz,023,On,5 kHz,Clackamas Primary Simplex,5 kHz,
24,146.96000,146.36000,600 kHz,Minus,FM,CLAC 4,Tone,127.3 Hz,88.5 Hz,023,On,5 kHz,Clackamas Tertiary Repeater (W7OTV),5 kHz,
25,146.92000,146.32000,600 kHz,Minus,FM,CLAC 5,Tone,107.2 Hz,88.5 Hz,023,On,5 kHz,Clackamas South County ARES Repeater,5 kHz,
26,146.58000,146.58000, ,Simplex,FM,CLAC 6,None,88.5 Hz,88.5 Hz,023,On,5 kHz,Clackamas South County ARES Simplex,5 kHz,
27,442.07500,447.07500,5.00 MHz,Plus,FM,CLAC 7,Tone,103.5 Hz,88.5 Hz,023,On,25 kHz,Oregon City ARES Repeater,5 kHz,
28,146.56000,146.56000, ,Simplex,FM,CLAC 8,None,88.5 Hz,88.5 Hz,023,On,5 kHz,Oregon City ARES Simplex,5 kHz,
