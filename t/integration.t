use Test2::IPC;
use Test2::V0 qw< ok is like skip todo try_ok diag done_testing >;

my $CLASS = 'Ham::Convert::FrequencyList';

my %tests;
{
    my $dir = __FILE__ =~ s/\.t$//r;
    opendir my $dh, $dir or die $!;
    for ( grep { !/^\./ && /\.csv$/i } readdir $dh ) {
        my ($src, $dst, $direction, $todo) = split /[-\.]/;
        next unless $direction =~ /^(?:in|out)$/;

        # allow "$type-in-out.csv" or "out-in" for a round-trip
        if ( $dst =~ /^(?:in|out)$/ ) {
            $tests{$src}{$src}{$dst}       = { path => "$dir/$_", TODO => $todo };
            $tests{$src}{$src}{$direction} = { path => "$dir/$_", TODO => $todo };
        }
        else {
            $tests{$src}{$dst}{$direction} = { path => "$dir/$_", TODO => $todo };
        }
    }
    closedir $dh;
}

sub slurp ($) { open my $fh, $_[0] || die $!; local $/; readline $fh }

foreach my $src ( sort keys %tests ) {
    SKIP: foreach my $dst ( sort keys %{ $tests{$src} } ) {
        my ($in, $out) = @{ $tests{$src}{$dst} }{qw< in out >};
        $in ||= $tests{$src}{$src}{in};    # allow a standard src file

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
            try_ok { $parsed = $c{src}->new->read($in->{path}) } "Read $in";

            my $got;
            try_ok { $c{dst}->new->write( \$got, $parsed ) } "Wrote $out";

            my $todo = todo("Not working yet") if $out->{TODO} && $out->{TODO} eq 'TODO';
            is [ split /\r\n/, $got ], [ split /\r\n/, slurp($out->{path}) ],
                "$src converted to $dst [$in->{path} -> $out->{path}]";

            exit;
        }

        wait;
    }
}


done_testing;
