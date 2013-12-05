use strict;
use warnings;
use feature qw< say state >;
use autodie;
use utf8;

use Carp qw<>;

package App::Watson::Repository;

my %prototype = (
    valid         => 0,
    username      => undef,
    password      => undef,
    repo          => undef,
    open_issues   => undef,
    closed_issues => undef,
);
my @other_fields = qw< access_token >;

my %lazy_init = (
    open_issues   => sub { App::Watson::IssueList->new },
    closed_issues => sub { App::Watson::IssueList->new },
);

sub new {
    my ($class, %args) = @_;

    if ($class eq __PACKAGE__) {
        Carp::croak "This class is abstract and should not be instantiated";
    }

    my $self = {%prototype};
    for my $field (grep { exists $args{$_} } @other_fields, keys %prototype) {
        $self->{__PACKAGE__ . q(/) . $field} = delete $args{$field};
    }

    if (keys %args) {
        Carp::croak "Unknown constructor arguments [@{[join ', ', keys %args]}]";
    }

    return bless $self => $class;
}

# a bit of meta-programming: writing the accessors
for my $field (keys %prototype, @other_fields) {
    my $init = $lazy_init{$field};
    my $full_field_name = __PACKAGE__ . q(/) . $field;

    no strict 'refs';  ## no critic (TestingAndDebugging::ProhibitNoStrict)

    *{ $field } = sub {
        my $self = shift;
        return $self->{$full_field_name}   = shift          if @_;
        return $self->{$full_field_name} //= $self->$init() if $init;
        return $self->{$full_field_name};
    }
}

sub name { ... }

sub authorization { ... }

sub api {
    return shift->access_token(@_);
}

sub user {
    return shift->username(@_);
}

sub pw {
    return shift->password(@_);
}

1;