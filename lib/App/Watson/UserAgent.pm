use strict;
use warnings;
use feature qw< say state >;
use autodie;
use utf8;

use Carp qw<>;

package App::Watson::UserAgent;

my $instance;

sub _instance {
    my ($self, @other_args) = @_;
    return $instance = shift @other_args if @other_args;
    require LWP::UserAgent;
    return $instance //= LWP::UserAgent->new;
}

sub post {
    my ($self, %headers) = @_;

    if (delete $headers{JSON} and my $data = delete $headers{Content}) {
        $headers{Content} = JSON::PP::encode_json($data);
    }

    my $response = $self->_instance->post(%headers);
    return bless $response => 'App::Watson::HTTP::Response';
}

sub get {
    my ($self, %headers) = @_;

    my $response = $self->_instance->get(%headers);
    return bless $response => 'App::Watson::HTTP::Response';
}

use constant {
    HTTP_CREATED => 201,
};

package App::Watson::HTTP::Response;
use parent 'HTTP::Response';

sub json {
    my $self = shift;
    my $utf8_encoded_content = Encode::encode('utf8', $self->decoded_content);
    return JSON::PP::decode_json($utf8_encoded_content);
}

1;