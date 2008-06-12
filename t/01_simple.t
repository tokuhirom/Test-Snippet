use strict;
use warnings;
use Test::More tests => 1;
use Test::Snippet;

my $test = <<'...';
$ 3+2
5
$ [2,5,5,{foo => 'bar'}]
$ARRAY1 = [
            2,
            ( 5 ) x 2,
            { foo => 'bar' }
          ];
...

test_snippet($test);

