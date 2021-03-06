# NAME

Mojolicious::Plugin::StaticCache - Mojolicious Plugin

# SYNOPSIS

    # Mojolicious
    $self->plugin('StaticCache');
    # With options
    $self->plugin('StaticCache' => { even_in_dev => 1, max_age => 2592000 });

    # Mojolicious::Lite
    plugin 'StaticCache';
    # With options
    plugin 'StaticCache' => { even_in_dev => 1, max_age => 2592000 };

# DESCRIPTION

[Mojolicious::Plugin::StaticCache](https://metacpan.org/pod/Mojolicious::Plugin::StaticCache) is a [Mojolicious](https://metacpan.org/pod/Mojolicious) plugin which add a Control-Cache header to each static file served by Mojolicious.

# OPTIONS

[Mojolicious::Plugin::StaticCache](https://metacpan.org/pod/Mojolicious::Plugin::StaticCache) supports the following options.

## even\_in\_dev

    # Mojolicious
    $self->plugin('StaticCache' => { even_in_dev => 1 });

Add the Cache-Control header even if Mojolicious mode is not 'production'.

Default is to not add the Cache-Control header if the mode is not 'production'.

## max\_age

    # Mojolicious
    $self->plugin('StaticCache' => { max_age => 2592000 });

Specify the maximum cache time for the Cache-Control header.

Default is 2592000.

## cache\_control

    # Mojolicious
    $self->plugin('StaticCache' => { cache_control => 'max-age=2592000, must-revalidate' });

Specify the content of the Cache-Control header.

Default is "max-age=$max\_age, must-revalidate".

# METHODS

[Mojolicious::Plugin::StaticCache](https://metacpan.org/pod/Mojolicious::Plugin::StaticCache) inherits all methods from
[Mojolicious::Plugin](https://metacpan.org/pod/Mojolicious::Plugin) and implements the following new ones.

## register

    $plugin->register(Mojolicious->new);

Register plugin in [Mojolicious](https://metacpan.org/pod/Mojolicious) application.

# BUGS and SUPPORT

The latest source code can be browsed and fetched at:

    https://framagit.org/luc/mojolicious-plugin-staticcache
    git clone https://framagit.org/luc/mojolicious-plugin-staticcache.git

Bugs and feature requests will be tracked at:

    https://framagit.org/luc/mojolicious-plugin-staticcache/issues

# AUTHOR

    Luc DIDRY
    CPAN ID: LDIDRY
    ldidry@cpan.org
    https://fiat-tux.fr/

# COPYRIGHT

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

# SEE ALSO

[Mojolicious](https://metacpan.org/pod/Mojolicious), [Mojolicious::Guides](https://metacpan.org/pod/Mojolicious::Guides), [http://mojolicious.org](http://mojolicious.org).
