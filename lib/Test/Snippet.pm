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
        eval "use Test::Snippet::Driver::DevelREPL;"; ## no critic
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
            if ($c->type eq 'text') {
                # nop.
            } elsif (($c->type eq 'begin' || $c->type eq 'for') && $c->format eq 'test') {
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

=for stopwords doctest API

=encoding utf8

=head1 NAME

Test::Snippet - doctest for perl

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

Test::Snippet is doctest for perl.

THIS MODULE IS IN ITS BETA QUALITY. API MAY CHANGE IN THE FUTURE.

=head1 FAQ

=over 4

=item How does this compare to Test::Inline, or Test::Pod::Snippets?

Very similar.

But, Test::Snippet way is based on REPL(read eval print loop).
This is very readable and users can run in own console!

=back

=head1 AUTHOR

Tokuhiro Matsuno E<lt>tokuhirom@gmail.comE<gt>

=head1 SEE ALSO

L<Test::Pod::Snippets>, L<Test::Inline>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
