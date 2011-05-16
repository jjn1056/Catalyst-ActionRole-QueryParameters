use strict;
use warnings FATAL =>'all';

use FindBin;
use Test::More;
use HTTP::Request::Common qw/GET/;

use lib "$FindBin::Bin/lib";
use Catalyst::Test 'TestApp';

is request(GET '/foo?page=100')->content, 'page';
is request(GET '/foo?row=100')->content, 'row';
is request(GET '/foo?page=100&row=100')->content, 'page_and_row';
is request(GET '/foo')->content, 'no_query';

is request(GET '/chained?page=100')->content, 'page';
is request(GET '/chained?row=100')->content, 'row';
is request(GET '/chained?page=100&row=100')->content, 'page_and_row';
is request(GET '/chained')->content, 'no_query';

done_testing;
