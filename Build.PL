#!/usr/bin/env perl

use strict;
use warnings;

use Module::Build;

Module::Build->new(
  module_name => 'WordComposer',

  share_dir => 'share',

  requires => {
    'File::ShareDir' => undef,
    'List::MoreUtils' => undef,
    'Math::Combinatorics' => undef,
    'Mojolicious' => undef,
  }

)->create_build_script();
