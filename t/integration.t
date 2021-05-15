use Test2::IPC;
use Test2::V0 qw< ok is like skip try_ok diag done_testing >;

my $CLASS = 'Ham::Convert::FrequencyList';

my %tests;
{
    my $dir = __FILE__ =~ s/\.t$//r;
    opendir my $dh, $dir or die $!;
    for ( grep { !/^\./ && /\.csv$/i } readdir $dh ) {
        my ($src, $dst, $direction) = split /[-\.]/;
        next unless $direction =~ /^(?:in|out)$/;

        # allow "$type-in-out.csv" or "out-in" for a round-trip
        if ( $dst =~ /^(?:in|out)$/ ) {
            $tests{$src}{$src}{$dst}       = "$dir/$_";
            $tests{$src}{$src}{$direction} = "$dir/$_";
        }
        else {
            $tests{$src}{$dst}{$direction} = "$dir/$_";
        }
    }
    closedir $dh;
}

sub slurp ($) { open my $fh, $_[0] || die $!; local $/; readline $fh }

foreach my $src ( sort keys %tests ) {
    SKIP: foreach my $dst ( sort keys %{ $tests{$src} } ) {
        my ($in, $out) = @{ $tests{$src}{$dst} }{qw< in out >};

        skip "Required integration files not there for '$src-$dst'", 1
            unless $in and $out;

        my $pid = fork // die "Unable to fork!";

        unless ($pid) {
            my %c = (
                src => "${CLASS}::$src",
                dst => "${CLASS}::$dst",
            );

            ok eval "require $_", "Required $_ module [$@]" for values %c;

            my $parsed;
            try_ok { $parsed = $c{src}->new->read($in) } "Read $in";

            my $got;
            try_ok { $c{dst}->new->write( \$got, $parsed ) } "Wrote $out";

            is [ split /\r\n/, $got ], [ split /\r\n/, slurp($out) ],
                "$src converted to $dst [$in -> $out]";

            exit;
        }

        wait;
    }
}


done_testing;
