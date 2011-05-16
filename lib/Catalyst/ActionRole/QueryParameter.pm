package Catalyst::ActionRole::QueryParameter;

our $VERSION = '0.01';

use 5.008008;
use Moose::Role;
use namespace::autoclean;

requires 'attributes';

sub _resolve_query_attrs {
  @{shift->attributes->{QueryParam} || []};
}

around 'match', sub {
  my ($orig, $self, $ctx) = @_;
  if(my @attrs = $self->_resolve_query_attrs) {

    my @matched = grep { $_ } map {
      my ($not, $attr_param) = ($_=~m/^(\!?)(.+)$/);
      my $req_param = $ctx->req->query_parameters->{$attr_param};
      $not ?!$req_param : $req_param;
    } @attrs;

    if( scalar(@matched) == scalar(@attrs) ) {
      return $self->$orig($ctx);
    } else {
      return 0;
    }
  } else {
    return $self->$orig($ctx);
  }
};

1;

=head1 NAME

Catalyst::ActionRole::QueryParameter - Dispatch rules using query parameters

=head1 SYNOPSIS

    package MyApp::Controller::Foo;

    use Moose;
    use namespace::autoclean;

    BEGIN {
      extends 'Catalyst::Controller::ActionRole';
    }

    ## Add the ActionRole to all the Controller's actions.  You can also
    ## selectively add the ActionRole with the :Does action attribute or in
    ## controller configuration.  See Catalyst::Controller::ActionRole for
    ## more information.

    __PACKAGE__->config(
      action_roles => ['QueryParameter'],
    );

    ## Match an incoming request matching "http://myhost/path?page"
    sub paged_results : Path('foo') QueryParam('page') { ... }

    ## Match an incoming request matching "http://myhost/path"
    sub no_paging : Path('foo') QueryParam('!page') { ... }

=head1 DESCRIPTION

Let's you require conditions on request query parameters (as you would access
via C<< $ctx->request->query_parameters >>) as part of your dispatch matching.
This ActionRole is not intended to be used for general HTML form and parameter
processing or validation, for that purpose there are many other options (such
as L<HTML::FormHandler, L<Data::Manager> or <HTML::FormFu>.)  What it can be
useful for is when you want to delegate work to various Actions inside your
Controller based on what the incoming query parameters say.

Generally speaking, its not great form to abuse query parameters this way,
howver I find there is a limited and controlled subset of use cases where this
feature is be valuable.  As a result, the features of this ActionRole are
also currently limited to simple defined or undefined checking.

There's a functioning L<Catalyst> example application in the test directory for
your review as well.

=head1 NOTE REGARDING CATALYST DISPATCH RESOLUTION

When several actions match the path of an incoming request, such as in the
following example:

    sub no_query : Path('foo') {
      my ($self, $ctx) = @_;
      $ctx->response->body('no_query');
    }

    sub page : Path('foo') QueryParam('page') {
      my ($self, $ctx) = @_;
      $ctx->response->body('page');
    }

L<Catayst> will call the C<match> method on each in turn until it finds one
that returns a successful match.  This matching process starts from the
bottom up (or last to first), which means that you should place your most
specific matches at the bottom and your least specific or 'catch all' actions
at the top.

HOWEVER, if you are using Chained actions L<Catalyst::DispatchType::Chained>
then the order resolution is REVERSED from the above example.  In other words
we start with the first action and proceed downwards.  This means that when you
are Chaining, you should place you most specific matches FIRST (nearest the top
of the Controller file) and least specific or default actions LAST.

For example:

sub root : Chained('/') PathPrefix CaptureArgs(0) {}

  sub page_and_row
  : Chained('root') PathPart('') QueryParam('page') QueryParam('row') Args(0)
  {
    my ($self, $ctx) = @_;
    $ctx->response->body('page_and_row');
  }

  sub page : Chained('root') PathPart('')  QueryParam('page') Args(0)  {
    my ($self, $ctx) = @_;
    $ctx->response->body('page');
  }

  sub no_query : Chained('root') PathPart('') Args(0)  {
    my ($self, $ctx) = @_;
    $ctx->response->body('no_query');
  }


The test suite has a working example of this for your review.

=head1 AUTHOR

John Napiorkowski L<email:jjnapiork@cpan.org>

=head1 SEE ALSO

L<Catalyst>, L<Catalyst::Controller::ActionRole>, L<Moose>.

=head1 COPYRIGHT & LICENSE

Copyright 2011, John Napiorkowski L<email:jjnapiork@cpan.org>

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut
