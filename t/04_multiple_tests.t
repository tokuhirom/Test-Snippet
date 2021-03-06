use strict;
use warnings;
use Test::Snippet tests => 2;

my $pod = join '', <DATA>;

test_snippet_in_pod( $pod );

__DATA__
=head1 NAME

Acme::Test - testing acme

=head1 SYNOPSIS

=begin snippet label1

$ 3+2
5

=end snippet

=begin snippet label2

$ [2,5,5,{foo => 'bar'}]
$ARRAY1 = [
            2,
            ( 5 ) x 2,
            { foo => 'bar' }
          ];

=end snippet
