use Mojo::Base -strict;
use Test::Mojo;
use Test::More;

my $REQUEST = {};

{
  use Mojolicious::Lite;
  post '/mocked/stripe-payment/charges' => sub {
    my $c = shift;
    $REQUEST = Mojo::Parameters->new($c->req->body);
    $c->render(json => $REQUEST->to_hash);
  };

  post '/charge' => sub {
    my $c = shift;
    my %args = (metadata => {foo => 24, bar => 42});
    $c->delay(
      sub { $c->stripe->create_charge(\%args, shift->begin) },
      sub { $c->render(json => $_[1] ? {oops => $_[1]} : $_[2]); }
    );
  };

  plugin 'StripePayment' => {mocked => 1};
}

my $t = Test::Mojo->new;
my %form = (amount => 100, stripeToken => 'tok_42');
$t->post_ok('/charge', form => \%form)->status_is(200);
is $REQUEST->param('metadata[foo]'), '24', 'foo';
is $REQUEST->param('metadata[bar]'), '42', 'bar';

done_testing;
