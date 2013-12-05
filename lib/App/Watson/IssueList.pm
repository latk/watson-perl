use strict;
use warnings;
use feature qw< say state >;
use autodie;
use utf8;

package App::Watson::IssueList;

sub new {
    my ($class) = @_;
    return bless {
        __PACKAGE__ . '/contains' => {},
        __PACKAGE__ . '/all' => [],
    } => $class;
}

sub add {
    my ($self, $issue) = @_;
    push @{ $self->{__PACKAGE__ . '/all'} }, $issue;
    $self->{__PACKAGE__ . '/contains'}->{$issue->md5} = $issue;
    return $self;
}

sub all {
    my $self = shift;
    return @{ $self->{__PACKAGE__ . '/all'} };
}

sub contains {
    my ($self, $digest) = @_;
    return $self->{__PACKAGE__ . '/contains'}->{$digest};
}

1;