package TestApp::Controller::Root;

use Moose;
use namespace::autoclean;

BEGIN {
  extends 'Catalyst::Controller::ActionRole';
}

__PACKAGE__->config(
  namespace    => '',
  action_roles => ['QueryParameter'],
);

sub no_query : Path('foo') {
  my ($self, $ctx) = @_;
  $ctx->response->body('no_query');
}

sub page : Path('foo') QueryParam('page') {
  my ($self, $ctx) = @_;
  $ctx->response->body('page');
}

sub row : Path('foo') QueryParam('row') {
  my ($self, $ctx) = @_;
  $ctx->response->body('row');
}

sub page_and_row : Path('foo') QueryParam('page') QueryParam('row') {
  my ($self, $ctx) = @_;
  $ctx->response->body('page_and_row');
}




__PACKAGE__->meta->make_immutable;

1;
