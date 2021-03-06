# This file was automatically generated by Dist::Zilla::Plugin::MakeMaker v5.036.
use strict;
use warnings;

use 5.010001;

use ExtUtils::MakeMaker;

my %WriteMakefileArgs = (
  "ABSTRACT" => "UV backend for Mojo::Reactor",
  "AUTHOR" => "Dan Book <dbook\@cpan.org>",
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => 0
  },
  "DISTNAME" => "Mojo-Reactor-UV",
  "EXE_FILES" => [],
  "LICENSE" => "artistic_2",
  "MIN_PERL_VERSION" => "5.010001",
  "NAME" => "Mojo::Reactor::UV",
  "PREREQ_PM" => {
    "Carp" => 0,
    "Mojolicious" => "6.0",
    "Scalar::Util" => 0,
    "UV" => "0.23"
  },
  "TEST_REQUIRES" => {
    "IO::Socket::INET" => 0,
    "Test::More" => "0.88"
  },
  "VERSION" => "0.001",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


my %FallbackPrereqs = (
  "Carp" => 0,
  "ExtUtils::MakeMaker" => 0,
  "IO::Socket::INET" => 0,
  "Mojolicious" => "6.0",
  "Scalar::Util" => 0,
  "Test::More" => "0.88",
  "UV" => "0.23"
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  delete $WriteMakefileArgs{TEST_REQUIRES};
  delete $WriteMakefileArgs{BUILD_REQUIRES};
  $WriteMakefileArgs{PREREQ_PM} = \%FallbackPrereqs;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);
