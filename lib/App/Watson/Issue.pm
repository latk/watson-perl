use strict;
use warnings;
use feature qw< say state >;
use autodie;
use utf8;

use Carp qw<>;

package App::Watson::Issue;

my @required_fields = qw< path line tag comment >;
my @private_fields  = qw< md5 >;

sub new {
    my ($class, %args) = @_;
    my $self = {};

    for my $field (@required_fields) {
        if (not exists $args{$field}) {
            Carp::croak qq/Constructor argument "$field" is mandatory/;
        }
        $self->{__PACKAGE__ . q(/) . $field} = delete $args{$field};
    }

    if (keys %args) {
        my $keys = join ", ", sort keys %args;
        Carp::croak "Unknown constructor arguments [$keys]";
    }

    bless $self => $class;

    $self->{__PACKAGE__ . '/md5'} =
        Digest::MD5::md5_hex($self->tag, $self->file, $self->comment);

    return $self;
}

for my $field (@required_fields, @private_fields) {
    no strict 'refs';  ## no critic (TestingAndDebugging::ProhibitNoStrict)
    *{ __PACKAGE__ . q(::) . $field } = sub {
        my $self = shift;
        return $self->{__PACKAGE__ . q(/) . $field};
    }
}

sub file {
    my $self = shift;

    (my $file = $self->path) =~ s{\A.*/}{};
    return $file;
}

sub post {
    my $self = shift;

    $_->post_issue($self) for grep { $_->valid } values %App::Watson::REPOSITORIES;

    return;
}

sub formatted_data {
    my $self = shift;

    return join q(), map { "$_\n" }
        "__filename__ : " . $self->path,
        "__line #__ : "   . $self->line,
        "__tag__ : "      . $self->tag,
        "__md5__ : "      . $self->md5;
}

sub title {
    my $self = shift;

    return sprintf "%s [%s]", $self->comment, $self->file;
}

sub as_hash {
    my ($self) = @_;
    return +{
        linenumber => $self->line,
        comment    => $self->comment,
        tag        => $self->tag,
        file       => $self->file,
        md5        => $self->md5,
    };
}

sub reconstruct {
    my ($class, $title, $formatted_data) = @_;
    $title =~ /\A\s* (.+) \s* \[([^\]]+)\] \s*\z/x or return;
    my $comment= $1;
    my $file   = $2;
    $formatted_data =~ /^\s*__filename__\s:\s+(.+           ) \s*$/mx or return;
    my $path   = $1;
    $formatted_data =~ /^\s*__line \#__ \s:\s+([0-9]+       ) \s*$/mx or return;
    my $line   = $1;
    $formatted_data =~ /^\s*__tag__     \s:\s+(\w+          ) \s*$/mx or return;
    my $tag    = $1;
    $formatted_data =~ /^\s*__md5__     \s:\s+([[:xdigit:]]+) \s*$/mx or return;
    my $digest = $1;

    my $instance = (ref $class || $class)->new(
        path => $path,
        line => $line,
        comment => $comment,
        tag => $tag,
    );

    $instance->{'App::Watson::Issue/md5'} = $digest;

    return $instance;
}

1;