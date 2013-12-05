use strict;
use warnings;
use feature qw< say state >;
use autodie;
use utf8;

package App::Watson::UI;

use Term::ANSIColor qw< :constants >;
use Carp qw<>;

sub new {
    die "Sorry, this is a singleton class";
}

sub prompt {
    my ($self, $prompt, %kw_args) = @_;

    # printflush prints the data, then flushes immediately
    STDOUT->printflush(BOLD, _flatten($prompt), q( ), RESET);

    system 'stty', '-echo' if $kw_args{silent};
    chomp(my $answer = <STDIN>);
    system 'stty', 'echo'  if $kw_args{silent};

    if (exists $kw_args{default} and not length $answer) {
        my $default = $kw_args{default};
        return $default->() if ref $default eq 'CODE';
        return $default;
    }

    return $answer;
}

sub prompt_yn {
    my ($self, %kw_args) = @_;
    my $result = uc $self->prompt('(Y)es/(N)o:', %kw_args);
    return !scalar($result =~ /\A [N][O]? \z/x);
}

sub tag {
    my ($self, @args) = @_;
    Carp::croak "\@args is empty" if not @args;
    Carp::croak "\$args[0] is undef" if not defined $args[0];
    return join q(), BOLD, "[ ", RESET, @args, RESET, BOLD, " ] ", RESET;
}

sub generic_message {
    my ($self, $tag, $message, @details) = @_;
    my $box = $self->tag(_flatten($tag));
    my $headline = join q() => BOLD, _flatten($message), RESET;
    return $box . join qq(\n) => $headline, _flatten(@details);
}

sub success {
    my ($self, $message, @details) = @_;
    return $self->generic_message([BOLD GREEN, 'o'],   $message, @details);
}

sub info {
    my ($self, $message, @details) = @_;
    return $self->generic_message([BOLD GREEN, 'i'],   $message, @details);
}

sub warning {
    my ($self, $message, @details) = @_;
    return $self->generic_message([BOLD MAGENTA, '!'], $message, @details);
}

sub error {
    my ($self, $message, @details) = @_;
    return $self->generic_message([BOLD RED, 'x'],     $message, @details);
}

sub header {
    my ($self, @info) = @_;
    unshift @info, q() if @info;  # adds an empty line before further info
    # Each line is a string or an arrayref of strings
    # Here, we flatten them (if applicable), add a newline,
    # and return a single string.
    return join qq(\n),
        map { _flatten($_) }
        [BOLD "------------------------------"],
        [BOLD "watson", RESET, " - ", BOLD YELLOW "inline issue manager", RESET],
        @info,
        [BOLD "------------------------------"],
        q();
}

sub details {
    my ($self, @kv_pairs) = @_;
    for (@kv_pairs) {
        my ($k, @v) = _flatten(@$_);
        $_ = [qq($k:) => @v];
    }
    return $self->display_kv(@kv_pairs);
}

sub display_kv {
    my ($self, @kv_pairs) = @_;

    my $max_key_length = 0;
    for my $pair (@kv_pairs) {
        my ($key) = @$pair;
        if ($max_key_length < length $key) {
            $max_key_length = length $key;
        }
    }

    # cap the key length to 80/3 = 26
    $max_key_length = int(80/3) if $max_key_length > int(80/3);

    my $str = q();
    for my $pair (@kv_pairs) {
        my ($key, @values) = @$pair;
        my $aligned_key = sprintf q(%-*s), $max_key_length, $key;
        $str .= join(q() => BOLD, $aligned_key, RESET, q( ), @values, qq(\n));
    }
    return $str;
}

sub _flatten {
    return map { ref $_ ? (join q() => @$_) : $_ } @_;
}

1;