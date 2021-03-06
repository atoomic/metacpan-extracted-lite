#!/usr/bin/perl

use warnings;
use strict;
use utf8;
use open qw(:std :utf8);
use lib qw(lib ../lib ../../lib);

use Test::More tests => 6;
use Encode qw(decode encode);


BEGIN {
    use_ok 'Test::Mojo';
    use_ok 'Mojolicious::Plugin::Vparam';
}

{
    package MyApp;
    use Mojo::Base 'Mojolicious';

    sub startup {
        my ($self) = @_;
        $self->log->level( $ENV{MOJO_LOG_LEVEL} = 'warn' );
        $self->plugin('Vparam');
    }
    1;
}

my $t = Test::Mojo->new('MyApp');
ok $t, 'Test Mojo created';

note 'object';
{
    $t->app->routes->any("/test/objects/vparam")->to( cb => sub {
        my ($self) = @_;

        is_deeply
            $self->vparam( object1 => 'object' ),
            {a => {b => 1, c => 2}, d => [{e => 3, f => 4}]},
            'object1';

        $self->render(text => 'OK.');
    });

    my $url = $t->app->url_for("/test/objects/vparam")->to_string;
    $url .= '?' . join '&',
        'object1[a][b]=1',
        'object1[a][c]=2',
        'object1[d][0][e]=3',
        'object1[d][0][f]=4',
    ;
    $t->get_ok($url)-> status_is( 200 );

    diag decode utf8 => $t->tx->res->body unless $t->tx->success;
}

=head1 COPYRIGHT

Copyright (C) 2011 Dmitry E. Oboukhov <unera@debian.org>

Copyright (C) 2011 Roman V. Nikolaev <rshadow@rambler.ru>

All rights reserved. If You want to use the code You
MUST have permissions from Dmitry E. Oboukhov AND
Roman V Nikolaev.

=cut

