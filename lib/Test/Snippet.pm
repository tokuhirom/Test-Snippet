package Test::Snippet;
use strict;
use warnings;
use 5.00800;
our $VERSION = '0.01';
use base qw/Test::Builder::Module/;
use Text::Diff qw(diff);
use Data::Dumper;

our @EXPORT = qw/test_snippet test_snippet_in_pod/;

my $CLASS = __PACKAGE__;

our $Dumper = \&Data::Dumper::Dumper;
our $Driver;

sub test_snippet {
    my $test = shift;

    unless ($Driver) {
        eval "use Test::Snippet::Driver::DevelREPL;";
        die $@ if $@;
        $Driver = Test::Snippet::Driver::DevelREPL->new();
    }

    my ($got, $expected) = $Driver->run($test);

    my $got_dumped = $Dumper->($got);
    my $expected_dumped = $Dumper->($expected);
    my $diff = diff(\$got_dumped, \$expected_dumped);
    $CLASS->builder->ok($got_dumped eq $expected_dumped);
    if ($diff) {
        $CLASS->builder->diag($diff);
    }
}

sub test_snippet_in_pod {
    my $pod = shift;
    require Pod::POM;

    my $parser = Pod::POM->new();
    my $pom = $parser->parse($pod) || die $parser->error;

    my $traverse;
    $traverse = sub {
        my $c = shift;
        for my $c ($c->content) {
            next if $c->type eq 'text';
            if ($c->type eq 'text') {
                # nop.
            } elsif ($c->type eq 'begin' && $c->format eq 'test') {
                # do it
                test_snippet( $c->content );
            } else {
                $traverse->($c); # recurse.
            }
        }
    };

    $traverse->($pom);
}

1;
__END__

=encoding utf8

=head1 NAME

Test::Snippet -

=head1 SYNOPSIS

    use Test::Snippet tests => 1;

    # simple repl:
    test_snippet(<<'...');
    $ 3+2
    5
    ...

    # tests in pod:
    test_snippet_in_pod(<<'...');
    =head1 DESCRIPTION

    ...

    =begin test

    $ 4*5
    20

    =end
    ...

=head1 DESCRIPTION

Test::Snippet is

=head1 AUTHOR

Tokuhiro Matsuno E<lt>tokuhirom@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
