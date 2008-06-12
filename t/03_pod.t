use strict;
use warnings;
use Test::Snippet tests => 1;

test_snippet_in_pod(<<'...');

your code here.

=head1 NAME

Acme::Test - testing acme

=head1 DESCRIPTION

blah blah blah

=begin snippet

$ 3+2
5
$ [2,5,5,{foo => 'bar'}]
$ARRAY1 = [
            2,
            ( 5 ) x 2,
            { foo => 'bar' }
          ];

=end test

=cut

something.. something..

=head1 SEE ALSO

ME!

...

