#!perl

use Test::More;
use Mojolicious::Commands;
use_ok( 'Mojolicious::Command::generate::routes_restsful' ) || print "Bail out!\n";
 

ok my $o = Mojolicious::Command::generate::routes_restsful->new;
ok $o->can('run');
 
done_testing();