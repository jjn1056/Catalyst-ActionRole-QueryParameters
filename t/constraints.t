BEGIN {
  use Test::Most;
  eval "use Catalyst 5.90093; 1" || do {
    plan skip_all => "Need a newer version of Catalyst => $@";
  };
}

{
  package MyApp::Controller::Root;
  $INC{'MyApp/Controller/Root.pm'} = __FILE__;

  use base 'Catalyst::Controller';

  MyApp::Controller::Root->config(
    namespace    => '',
    action_roles => ['QueryParameter'],
  );

  sub page : Path('foo') QueryParam('page:>1') QueryParam('order') Args(0) {
    my ($self, $ctx) = @_;
    $ctx->response->body('page');
  }
  
  package MyApp::Controller::Example;
  $INC{'MyApp/Controller/Example.pm'} = __FILE__;

  use base 'Catalyst::Controller';


  package MyApp;
  use Catalyst;
  
  MyApp->setup;
}

use HTTP::Request::Common;
use Catalyst::Test 'MyApp';

{
  my ($res, $c) = ctx_request( '/foo?page=2&order=2' );

use Devel::Dwarn;
#dDwarn $c->action->query_constraints;

}

ok 1;

done_testing;

