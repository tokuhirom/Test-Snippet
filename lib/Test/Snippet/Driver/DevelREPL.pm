package Test::Snippet::Driver::DevelREPL;
use Moose;
use Devel::REPL;
use Devel::REPL::Profile::Default;
use IO::Scalar;

my $term_mock = Moose::Meta::Class->create_anon_class(
    methods => {
        ReadLine => sub { 0 },
    },
)->new_object;

has repl => (
    is => 'ro',
    isa => 'Devel::REPL',
    default => sub {
        my $repl = Devel::REPL->new( term => $term_mock );
        Devel::REPL::Profile::Default->new->apply_profile($repl);
        $repl;
    },
);

sub run {
    my ($self, $snippet) = @_;

    my $state = 'init';
    my @gots;
    my @expecteds;
    my @rets;
    for my $line ( split /\n/, $snippet ) {
        if ( $line =~ /^\$ (.+)$/ ) {
            my $snippet = $1;
            if ( $state eq 'ret' ) {
                push @expecteds, join( "\n", @rets );
                @rets = ();
            }
            my $fh = IO::Scalar->new( \my $out );
            $self->repl->out_fh($fh);
            my @err = $self->repl->eval($snippet);
            $self->repl->print(@err);
            $out =~ s/\n$//;
            push @gots, $out;
            $state = 'query';
        }
        else {
            push @rets, $line;
            $state = 'ret';
        }
    }
    if ( $state eq 'ret' ) {
        push @expecteds, join( "\n", @rets );
    }

    return \@gots, \@expecteds;
}

__PACKAGE__->meta->make_immutable;
1;
