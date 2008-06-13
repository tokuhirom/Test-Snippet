use inc::Module::Install;
name 'Test-Snippet';
all_from 'lib/Test/Snippet.pm';

requires 'Exporter' => '5.58';
requires 'Test::Builder' => '0.80';
requires 'Pod::POM' => 0.17;
requires 'Devel::REPL' => '1.002001';

tests 't/*.t t/*/*.t t/*/*/*.t t/*/*/*/*.t';
test_requires 'Test::More';
test_requires 'YAML';
author_tests 'xt';
use_test_base;
auto_include;
WriteAll;
