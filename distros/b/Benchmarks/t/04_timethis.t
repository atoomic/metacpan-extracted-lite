use strict;
use warnings;

use Benchmarks sub {
    my $x = 2;
    sub { $x * $x };
}, 100;

use Test::More tests => 1;
ok 1;