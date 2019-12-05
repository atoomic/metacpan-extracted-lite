package Mojolicious::Plugin::AssetPack::Asset;
use Mojo::Base -base;

use Mojo::Asset::Memory;
use Mojo::URL;
use Mojo::File;
use Mojolicious::Plugin::AssetPack::Util qw(diag has_ro DEBUG);

has checksum => sub { Mojolicious::Plugin::AssetPack::Util::checksum(shift->content) };
has format => sub {
  my $self = shift;
  my $name
    = $self->url =~ /^https?:/
    ? Mojo::URL->new($self->url)->path->[-1]
    : (split m!(\\|/)!, $self->url)[-1];

  return $name =~ /\.(\w+)$/ ? lc $1 : '';
};

has minified => sub { shift->url =~ /\bmin\b/ ? 1 : 0 };

has _asset => sub {
  my $self = shift;
  return $self->content(delete $self->{content})->_asset if $self->{content};
  return Mojo::Asset::File->new(path => delete $self->{path}) if $self->{path};
  return Mojo::Asset::Memory->new;
};

has_ro name => sub {
  my $self = shift;
  my $name;

  if ($self->url =~ /^https?:/) {
    my $url = Mojo::URL->new($self->url);
    my $qs  = $url->query->to_string;
    $name = $url->path->[-1];
    $qs =~ s!\W!_!g;
    $name =~ s!\.\w+$!!;
    $name .= "_$qs" if $qs;
  }
  else {
    $name = (split m!(\\|/)!, $self->url)[-1];
    $name =~ s!\.\w+$!!;
  }

  return $name;
};

has_ro 'url';

sub asset {
  my $self  = shift;
  my $orig  = $self->_asset;
  my $clone = $orig->new;

  if ($orig->is_file) {
    $clone->cleanup(0)->path($orig->path);
  }
  else {
    $clone->auto_upgrade(0)->mtime($orig->mtime)->add_chunk($orig->slurp);
  }

  return $clone;
}

sub content {
  my $self = shift;
  return $self->_asset->slurp unless @_;
  return $self->_asset($_[0]->_asset) if UNIVERSAL::isa($_[0], __PACKAGE__);
  return $self->_asset($_[0])         if UNIVERSAL::isa($_[0], 'Mojo::Asset');
  return $self->_asset(Mojo::Asset::Memory->new->add_chunk($_[0]));
}

sub path {
  my $self = shift;
  return $self->_asset(Mojo::Asset::File->new(path => $_[0])) if $_[0];
  return Mojo::File->new($self->_asset->path) if $self->_asset->isa('Mojo::Asset::File');
  return undef;
}

sub size { $_[0]->_asset->size }

sub url_for { $_[1]->url_for(assetpack => $_[0]->TO_JSON); }

sub FROM_JSON {
  my ($self, $attrs) = @_;
  $self->$_($attrs->{$_}) for grep { defined $attrs->{$_} } qw(checksum format minified);
  $self;
}

sub TO_JSON {
  return {map { ($_ => $_[0]->$_) } qw(checksum format minified name url)};
}

1;

=encoding utf8

=head1 NAME

Mojolicious::Plugin::AssetPack::Asset - An asset

=head1 DESCRIPTION

L<Mojolicious::Plugin::AssetPack::Asset> represents an asset.

=head1 SYNOPSIS

  use Mojolicious::Plugin::AssetPack::Asset;
  my $asset = Mojolicious::Plugin::AssetPack::Asset->new(url => "...");

=head1 ATTRIBUTES

=head2 checksum

  $str = $self->checksum;
  $self = $self->checksum($str);

The L<checksum|Mojolicious::Plugin::AssetPack::Util/checksum> of L</content>.

=head2 format

  $str = $self->format;
  $self = $self->format($str);

The format of L</content>. Defaults to the extension of L</url> or empty string.

=head2 minified

  $bool = $self->minified;
  $self = $self->minified($bool);

Will be set to true if either L</url> contains "min" or if a pipe has
minified L</content>.

=head2 name

  $str = $self->name;

Returns the basename of L</url>, without extension.

=head2 url

  $str = $self->url;

Returns the location of the asset.

=head1 METHODS

=head2 asset

  $asset = $self->asset;

Returns a new L<Mojo::Asset::File> or L<Mojo::Asset::Memory> object, with the
content or path from this object.

This method is EXPERIMENTAL.

=head2 content

  $bytes = $self->content;
  $self = $self->content($bytes);
  $self = $self->content(Mojo::Asset::Memory->new);

Used to get or set the content of this asset. The default will be built from
passing L</url> to L<Mojolicious::Plugin::AssetPack::Store/file>.

=head2 path

  $str = $self->path;

Returns a L<Mojo::File> object that holds the location to the asset on disk or
C<undef> if this asset is in memory.

=head2 size

  $int = $self->size;

Returns the size of the asset in bytes.

=head2 url_for

  $url = $self->url_for($c);

Returns a L<Mojo::URL> object for this asset. C<$c> need to be a
L<Mojolicious::Controller>.

=head2 FROM_JSON

  $self = $self->FROM_JSON($hash_ref);

The opposite of L</TO_JSON>. Will set the read/write L</ATTRIBUTES> from the
values in C<$hash_ref>.

=head2 TO_JSON

  $hash_ref = $self->FROM_JSON;

The opposite of L</FROM_JSON>. Will generate a hash ref from L</ATTRIBUTES>.

=head1 SEE ALSO

L<Mojolicious::Plugin::AssetPack>.

=cut
