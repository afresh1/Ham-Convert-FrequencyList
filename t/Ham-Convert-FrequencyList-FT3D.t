use Test2::V0
    -target => 'Ham::Convert::FrequencyList::FT3D',
    qw< ok is like subtest dies diag done_testing >;

diag "Testing $CLASS on perl $^V";

ok CLASS, "Loaded $CLASS";

ok my $converter = CLASS->new, "Created a new $CLASS instance";

is [ $converter->headers ], [
    'Channel No',
    'Priority Ch',
    'Receive Frequency',
    'Transmit Frequency',
    'Offset Frequency',
    'Offset Direction',
    'Auto Mode',
    'Operating Mode',
    'Dig/Analog',
    'Tag',
    'Name',
    'Tone Mode',
    'CTCSS Frequency',
    'DCS Code',
    'DCS Polarity',
    'User CTCSS',
    'RX DG-ID',
    'TX DG-ID',
    'TX Power',
    'Skip',
    'Auto Step',
    'Step',
    'Memory Mask',
    'ATT',
    'S-Meter SQL',
    'Bell',
    'Narrow',
    'Clock Shift',
    'Bank 1',
    'Bank 2',
    'Bank 3',
    'Bank 4',
    'Bank 5',
    'Bank 6',
    'Bank 7',
    'Bank 8',
    'Bank 9',
    'Bank 10',
    'Bank 11',
    'Bank 12',
    'Bank 13',
    'Bank 14',
    'Bank 15',
    'Bank 16',
    'Bank 17',
    'Bank 18',
    'Bank 19',
    'Bank 20',
    'Bank 21',
    'Bank 22',
    'Bank 23',
    'Bank 24',
    'Comment',
    '',
    ],
    "Found expected headers";

my $parsed = $converter->read( \*DATA );

is $parsed,
    [
    {   'att'              => 'OFF',
        'auto_mode'        => 'ON',
        'auto_step'        => 'ON',
        'bell'             => 'OFF',
        'clock_shift'      => 'OFF',
        'comment'          => '',
        'ctcss_freq'       => '100.0 Hz',
        'dcs_code'         => '23',
        'dcs_polarity'     => 'RX Normal TX Normal',
        'dig_analog'       => 'AMS',
        'memory_mask'      => 'OFF',
        'name'             => '',
        'narrow'           => 'OFF',
        'offset_direction' => 'OFF',
        'offset_freq'      => '0.6',
        'operating_mode'   => 'FM',
        'priority_ch'      => 'ON',
        'rx_dg_id'         => 'RX 00',
        'rx_freq'          => '145',
        's_meter_sql'      => 'OFF',
        'skip'             => 'OFF',
        'step'             => '20.0KHz',
        'tag'              => 'ON',
        'tone_mode'        => 'OFF',
        'tx_dg_id'         => 'TX 00',
        'tx_freq'          => '145',
        'tx_power'         => 'High (5W)',
        'user_ctcss'       => '1600 Hz'
    },
    undef,
    {   'att'              => 'OFF',
        'auto_mode'        => 'ON',
        'auto_step'        => 'ON',
        'bell'             => 'OFF',
        'clock_shift'      => 'OFF',
        'comment'          => '',
        'ctcss_freq'       => '100.0 Hz',
        'dcs_code'         => '23',
        'dcs_polarity'     => 'RX Normal TX Normal',
        'dig_analog'       => 'AM',
        'memory_mask'      => 'OFF',
        'name'             => 'name',
        'narrow'           => 'OFF',
        'offset_direction' => '-RPT',
        'offset_freq'      => '0',
        'operating_mode'   => 'AM',
        'priority_ch'      => 'OFF',
        'rx_dg_id'         => '-',
        'rx_freq'          => '123',
        's_meter_sql'      => 'OFF',
        'skip'             => 'OFF',
        'step'             => '25.0KHz',
        'tag'              => 'ON',
        'tone_mode'        => 'TONE',
        'tx_dg_id'         => '-',
        'tx_freq'          => '123',
        'tx_power'         => 'High (5W)',
        'user_ctcss'       => '1600 Hz'
    },
    undef, undef, undef,
    {   'att'              => 'OFF',
        'auto_mode'        => 'ON',
        'auto_step'        => 'ON',
        'bell'             => 'OFF',
        'clock_shift'      => 'OFF',
        'comment'          => '',
        'ctcss_freq'       => '88.5 Hz',
        'dcs_code'         => '23',
        'dcs_polarity'     => 'RX Normal TX Normal',
        'dig_analog'       => 'AM',
        'group'            => [(undef)x10,'ON',(undef)x9,'ON'],
        'memory_mask'      => 'OFF',
        'name'             => '',
        'narrow'           => 'OFF',
        'offset_direction' => 'OFF',
        'offset_freq'      => '0',
        'operating_mode'   => 'AM',
        'priority_ch'      => 'OFF',
        'rx_dg_id'         => '-',
        'rx_freq'          => '123',
        's_meter_sql'      => 'OFF',
        'skip'             => 'OFF',
        'step'             => '25.0KHz',
        'tag'              => 'ON',
        'tone_mode'        => 'OFF',
        'tx_dg_id'         => '-',
        'tx_freq'          => '123',
        'tx_power'         => 'High (5W)',
        'user_ctcss'       => '1600 Hz'
    },
    undef,
    {   'att'              => '',
        'auto_mode'        => '',
        'auto_step'        => '',
        'bell'             => '',
        'clock_shift'      => '',
        'comment'          => '',
        'ctcss_freq'       => '60.0 Hz',
        'dcs_code'         => '',
        'dcs_polarity'     => '',
        'dig_analog'       => '',
        'memory_mask'      => '',
        'name'             => 'name2',
        'narrow'           => '',
        'offset_direction' => '-RPT',
        'offset_freq'      => '0.6',
        'operating_mode'   => 'FM',
        'priority_ch'      => '',
        'rx_dg_id'         => '',
        'rx_freq'          => '124',
        's_meter_sql'      => '',
        'skip'             => '',
        'step'             => '',
        'tag'              => '',
        'tone_mode'        => '',
        'tx_dg_id'         => '',
        'tx_freq'          => '',
        'tx_power'         => '',
        'user_ctcss'       => ''
    }
    ],
    "Parsed the data into the expected format";

my $expect = do { local $/; readline DATA };

$converter->write( \my $output, $parsed );

# This is the exact same, but column 2 is quoted
my $empty = ',,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,0';
my @expect = (
    # We don't write any headers
    '1,ON,145,145,0.6,OFF,ON,FM,AMS,ON,,OFF,100.0 Hz,23,RX Normal TX Normal,1600 Hz,RX 00,TX 00,High (5W),OFF,ON,20.0KHz,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,,0',
    "2,$empty",
    '3,OFF,123,123,0,-RPT,ON,AM,AM,ON,name,TONE,100.0 Hz,23,RX Normal TX Normal,1600 Hz,-,-,High (5W),OFF,ON,25.0KHz,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,,0',
    "4,$empty",
    "5,$empty",
    "6,$empty",
    '7,OFF,123,123,0,OFF,ON,AM,AM,ON,,OFF,88.5 Hz,23,RX Normal TX Normal,1600 Hz,-,-,High (5W),OFF,ON,25.0KHz,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,ON,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,ON,OFF,OFF,OFF,,0',
    "8,$empty",
    '9,,124,,0.6,-RPT,,FM,,,name2,,60.0 Hz,,,,,,,,,,,,,,,,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,,0',
    map {"$_,$empty"} 10 .. 900,
);
is [ split /\r\n/, $output ], \@expect, "Wrote the CSV file we expected";

done_testing;

__DATA__
Channel No,Priority Ch,Receive Frequency,Transmit Frequency,Offset Frequency,Offset Direction,Auto Mode,Operating Mode,Dig/Analog,Tag,Name,Tone Mode,CTCSS Frequency,DCS Code,DCS Polarity,User CTCSS,RX DG-ID,TX DG-ID,TX Power,Skip,Auto Step,Step,Memory Mask,ATT,S-Meter SQL,Bell,Narrow,Clock Shift,Bank 1,Bank 2,Bank 3,Bank 4,Bank 5,Bank 6,Bank 7,Bank 8,Bank 9,Bank 10,Bank 11,Bank 12,Bank 13,Bank 14,Bank 15,Bank 16,Bank 17,Bank 18,Bank 19,Bank 20,Bank 21,Bank 22,Bank 23,Bank 24,Comment,
1,ON,145,145,0.6,OFF,ON,FM,AMS,ON,,OFF,100.0 Hz,23,RX Normal TX Normal,1600 Hz,RX 00,TX 00,High (5W),OFF,ON,20.0KHz,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,,0
2,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,0
3,OFF,123,123,0,-RPT,ON,AM,AM,ON,name,TONE,100.0 Hz,23,RX Normal TX Normal,1600 Hz,-,-,High (5W),OFF,ON,25.0KHz,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,,0
4,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,0
5,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,0
6,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,0
7,OFF,123,123,0,OFF,ON,AM,AM,ON,,OFF,88.5 Hz,23,RX Normal TX Normal,1600 Hz,-,-,High (5W),OFF,ON,25.0KHz,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,ON,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,ON,OFF,OFF,OFF,,0
8,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,0
9,,124,,0.6,-RPT,,FM,,,name2,,60.0 Hz,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,0
10,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,0
