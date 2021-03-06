package Mojolicious::Plugin::LinkEmbedder::Link::Video::Collegehumor;

=head1 NAME

Mojolicious::Plugin::LinkEmbedder::Link::Video::Collegehumor - collegehumor.com link

=head1 DESCRIPTION

This class inherit from L<Mojolicious::Plugin::LinkEmbedder::Link::Text::HTML>.

=cut

use Mojo::Base 'Mojolicious::Plugin::LinkEmbedder::Link::Text::HTML';

=head1 ATTRIBUTES

=head2 media_id

Returns the the digit from the second path part from L</url>.

=head2 provider_name

=cut

has media_id => sub { shift->url->path =~ m!/(\d+)/! ? $1 : '' };
sub provider_name {'Collegehumor'}

=head1 METHODS

=head2 learn

=cut

sub learn {
  my ($self, $c, $cb) = @_;

  if ($self->media_id) {
    $self->$cb;
  }
  else {
    $self->SUPER::learn($c, $cb);
  }

  return $self;
}

=head2 to_embed

Returns the HTML code for an iframe embedding this movie.

=cut

sub to_embed {
  my $self     = shift;
  my $media_id = $self->media_id or return $self->SUPER::to_embed;
  my $src      = Mojo::URL->new('http://www.collegehumor.com/e');
  my %args     = @_;

  push @{$src->path}, $media_id;

  $self->_iframe(
    src    => $src,
    class  => 'link-embedder video-collegehumor',
    width  => $args{width} || 600,
    height => $args{height} || 369
  );
}

=head1 AUTHOR

Marcus Ramberg

=cut

1;
