use Mojo::Base -strict;

use Test::More;
use Mojolicious::Lite;
use Test::Mojo;
use Mojo::Util qw(url_escape);

plugin 'AdditionalValidationChecks';

my %colors = (
    '2'                 => 0,
    'abcd'              => 0,
    'rgb[1,2,3]'        => 0,
    'rgb(a1,2,3)'       => 0,
    'rgb(311,12,33)'    => 0,
    'rgb(311,12,33,)'   => 0,
    'rgb(255,255,255,)' => 0,
    'rgb(255%,255%,255%)' => 0,
    'rgb(11%,12,33)'     => 0,
    'rgb(255,255,255a)'  => 0,
    'rgb(0%,0%,0%)'        => 1,
    'rgb(0%, 0%, 0%)'      => 1,
    'rgb(90%, 90%, 90%)'      => 1,
    'rgb(100%, 100%, 100%)'      => 1,
    'rgb(110%, 110%, 110%)'      => 0,
    'rgb(a%, b%, c%)'      => 0,
    'rgb(00%,0%,0%)'        => 0,
);

get '/' => sub {
  my $c = shift;

  my $validation = $c->validation;
  my $params     = $c->req->params->to_hash;

  $validation->input( $params );
  $validation->required( 'color' )->color( 'rgb' );

  my $result = $validation->has_error() ? 0 : 1;
  $c->render(text => $result );
};

my $t = Test::Mojo->new;
for my $color ( sort keys %colors ) {
    my $res = $colors{$color};
    my $escaped = url_escape $color;
    $t->get_ok('/?color=' . $escaped )
      ->status_is(200)->content_is( $res, "Check: $color" );
}

done_testing();
