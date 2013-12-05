requires "perl"     => "v5.10.0";
requires "strict"   => "0";
requires "version"  => "0";
requires "warnings" => "0";
requires "feature"  => "0";
requires "utf8"     => "0";

requires "Term::ANSIColor"  => "0";
requires "Data::Dumper"     => "0";
requires "Digest::MD5"      => "0";
requires "File::Copy"       => "0";
requires "MIME::Base64"     => "0";
requires "Carp"             => "0";
requires "Encode"           => "0";
requires "IO::Handle"       => "0";
requires "Cwd"              => "0";
requires "English"          => "0";
requires "Hash::Util"       => "0";
requires "JSON::PP"         => "0";
requires "LWP::UserAgent"   => "0";

on 'test' => sub {
  requires "Test::More" => "0";
};

on 'develop' => sub {
  requires "Perl::Critic" => "0";
};
