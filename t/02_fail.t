use strict;
use warnings;
use Test::Builder::Tester tests => 1;
use Test::Snippet;

my $test = <<'...';
$ 3+2
5
$ [2,5,5,{foo => 'bar'}]
$ARRA1 = [
            2,
            ( 5 ) x 2,
            { foo => 'bar' }
          ];
$ substr("YATTA!", 3,2);
TM
...

my $err = <<'...';
#   Failed test at t/02_fail.t line 38.
# @@ -1,9 +1,9 @@
#  $VAR1 = [
#            '5',
# -          '$ARRAY1 = [
# +          '$ARRA1 = [
#              2,
#              ( 5 ) x 2,
#              { foo => \'bar\' }
#            ];',
# -          'TA'
# +          'TM'
#          ];
...
$err =~ s/\n$//;

test_err($err);
test_out('not ok 1');
test_snippet($test);
test_test("fail works");
