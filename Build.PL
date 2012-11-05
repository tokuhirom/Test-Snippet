use strict;
use warnings FATAL => 'all';
use Module::Build;

my $build = Module::Build->new(
    license              => 'perl',
    recursive_test_files => 1,
    dynamic_config       => 0,
    build_requires       => { 'Test::More' => '0.98' },
    configure_requires   => { 'Module::Build' => '0.38' },
    requires             => {
        'perl'               => '5.00800',
        'Text::Diff'         => '0.35',
        'Filter::Util::Call' => '0',
        'Test::Builder'      => '0.80',
        'Pod::POM'           => '0.17',
        'Devel::REPL'        => '1.002001',
        'Exporter'           => '5.58'
    },
    no_index    => { 'directory' => [ 'inc', 't', 'xt' ] },
    name        => 'Test-Snippet',
    module_name => 'Test::Snippet',

    test_files => ( -d '.git' || $ENV{RELEASE_TESTING} ) ? 't/ xt/' : 't/',

    create_readme  => 1,
    create_license => 1,
);
$build->create_build_script();
