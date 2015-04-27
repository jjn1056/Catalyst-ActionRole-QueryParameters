#!/usr/bin/env perl

use strict;
use warnings FATAL =>'all';
use inc::Module::Install 1.00;
all_from 'lib/Catalyst/ActionRole/QueryParameter.pm';

requires 'Moose';
requires 'namespace::autoclean';

test_requires 'Test::More' => '0.96';
test_requires 'Moose';
test_requires 'Catalyst';
test_requires 'Catalyst::Test';
test_requires 'HTTP::Request::Common';

require 'maint/Makefile.PL.include'
  unless -e 'META.yml';

WriteAll;
