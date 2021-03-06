use Mojo::Base -strict;

BEGIN { $ENV{MOJO_REACTOR} = 'Mojo::Reactor::Poll' }

use Test::More;
use Mojo::IOLoop;
use Mojo::IOLoop::Server;
use Mojo::Server::Daemon;
use Mojo::UserAgent;
use Mojolicious::Lite;

# Silence
app->log->level('fatal');

get '/' => sub {
  my $c   = shift;
  my $rel = $c->req->url;
  my $abs = $rel->to_abs;
  $c->render(text => "Hello World! $rel $abs");
};

get '/proxy' => sub {
  my $c = shift;
  $c->render(text => $c->req->url);
};

websocket '/test' => sub {
  my $c = shift;
  $c->on(message => sub { shift->send(shift() . 'test2') });
};

# HTTP server for testing
my $ua = Mojo::UserAgent->new(ioloop => Mojo::IOLoop->singleton);
my $daemon = Mojo::Server::Daemon->new(app => app, silent => 1);
my $port = $daemon->listen(['http://127.0.0.1'])->start->ports->[0];

# CONNECT proxy server for testing
my (%buffer, $connected, $read, $sent);
my $nf
  = "HTTP/1.1 404 NOT FOUND\x0d\x0a"
  . "Content-Length: 0\x0d\x0a"
  . "Connection: close\x0d\x0a\x0d\x0a";
my $ok    = "HTTP/1.0 201 BAR\x0d\x0aX-Something: unimportant\x0d\x0a\x0d\x0a";
my $dummy = Mojo::IOLoop::Server->generate_port;
my $id    = Mojo::IOLoop->server(
  {address => '127.0.0.1'} => sub {
    my ($loop, $stream, $id) = @_;

    # Connection to client
    $stream->on(
      read => sub {
        my ($stream, $chunk) = @_;
        #        say qq{READ chunk: $chunk};
        # Write chunk from client to server
        my $server = $buffer{$id}{connection};
        say qq{Write chunk to server: |BEGIN|$chunk|END|};
        return Mojo::IOLoop->stream($server)->write($chunk) if $server;

        # Read connect request from client
        my $buffer = $buffer{$id}{client} .= $chunk;
        if ($buffer =~ /\x0d?\x0a\x0d?\x0a$/) {
          $buffer{$id}{client} = '';
          if ($buffer =~ /CONNECT (\S+):(\d+)?/) {
            $connected = "$1:$2";
            my $fail = $2 == $dummy;

            # Connection to server
            $buffer{$id}{connection} = Mojo::IOLoop->client(
              {address => $1, port => $fail ? $port : $2} => sub {
                my ($loop, $err, $stream) = @_;

                # Connection to server failed
                if ($err) {
                  Mojo::IOLoop->remove($id);
                  return delete $buffer{$id};
                }

                # Start forwarding data in both directions
                Mojo::IOLoop->stream($id)->write($fail ? $nf : $ok);
                $stream->on(
                  read => sub {
                    my ($stream, $chunk) = @_;
                    $read += length $chunk;
                    $sent += length $chunk;
                    say qq{Write chunk to client |BEGIN|$chunk|END|};
                    Mojo::IOLoop->stream($id)->write($chunk);
                  }
                );

                # Server closed connection
                $stream->on(
                  close => sub {
                    Mojo::IOLoop->remove($id);
                    delete $buffer{$id};
                  }
                );
              }
            );
          }

          # Invalid request from client
          else { Mojo::IOLoop->remove($id) }
        }
      }
    );

    # Client closed connection
    $stream->on(
      close => sub {
        my $buffer = delete $buffer{$id};
        Mojo::IOLoop->remove($buffer->{connection}) if $buffer->{connection};
      }
    );
  }
);
my $proxy = Mojo::IOLoop->acceptor($id)->port;

# Normal non-blocking request
my $result;

# Non-blocking proxy request
$ua->proxy->http("http://127.0.0.1:$port");
$ua->on(
    start => sub {
        my ( $ua, $tx ) = @_;
        say $tx->req->method, ' ', $tx->req->url;
        $tx->on(
            finish => sub {
                my $tx = shift;
                say $tx->req->method, ' ', $tx->req->url;
            }
        );
    }
);

my $kept_alive;
$result = undef;
$ua->get(
  'http://example.com/proxy' => sub {
    my ($ua, $tx) = @_;
    $kept_alive = $tx->kept_alive;
    $result     = $tx->res->body;
    Mojo::IOLoop->stop;
  }
);
Mojo::IOLoop->start;
# ok !$kept_alive, 'connection was not kept alive';
# is $result, 'http://example.com/proxy', 'right content';

# Kept alive proxy WebSocket
($kept_alive, $result) = ();
$ua->websocket(
  "ws://127.0.0.1:$port/test" => sub {
    my ($ua, $tx) = @_;
    $kept_alive = $tx->kept_alive;
    $tx->on(finish => sub { Mojo::IOLoop->stop });
    $tx->on(message => sub { shift->finish; $result = shift });
    $tx->send('test1');
  }
);
Mojo::IOLoop->start;
# ok $kept_alive, 'connection was kept alive';
# is $result, 'test1test2', 'right result';

# Blocking proxy request
# my $tx = $ua->get('http://example.com/proxy');
# # is $tx->res->code, 200, 'right status, amundo';
# # is $tx->res->body, 'http://example.com/proxy', 'right content';
# 
# # Proxy WebSocket
# $ua = Mojo::UserAgent->new;
# $ua->proxy->http("http://127.0.0.1:$proxy");
# $result = undef;
# $ua->websocket(
#   "ws://127.0.0.1:$port/test" => sub {
#     my ($ua, $tx) = @_;
#     $tx->on(finish => sub { Mojo::IOLoop->stop });
#     $tx->on(message => sub { shift->finish; $result = shift });
#     $tx->send('test1');
#   }
# );
# Mojo::IOLoop->start;
# is $connected, "127.0.0.1:$port", 'connected';
# is $result,    'test1test2',      'right result';
# ok $read > 25, 'read enough';
# ok $sent > 25, 'sent enough';

$ua->proxy->http("http://127.0.0.1:$port");
my $tx = $ua->get('http://somethingpositive.net');
say $tx->success ? $tx->res->body : $tx->error->{message};
# Proxy WebSocket with bad target
# $ua->proxy->http("http://127.0.0.1:$proxy");
# my ($success, $leak, $err);
# $ua->websocket(
#   "ws://127.0.0.1:$dummy/test" => sub {
#     my ($ua, $tx) = @_;
#     $success = $tx->success;
#     $leak    = !!Mojo::IOLoop->stream($tx->previous->connection);
#     $err     = $tx->error;
#     Mojo::IOLoop->stop;
#   }
# );
# Mojo::IOLoop->start;
# ok !$success, 'no success';
# ok !$leak,    'connection has been removed';
# is $err->{message}, 'Proxy connection failed', 'right message';

done_testing();
