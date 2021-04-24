use Test2::V0 -target => 'Ham::Convert::FrequencyList',
    qw< ok diag done_testing >;

diag "Testing $CLASS on perl $^V";

ok CLASS, "Loaded $CLASS";

ok my $converter = CLASS->new, "Created a new $CLASS instance";

done_testing;
