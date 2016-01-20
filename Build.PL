use Module::Build;
my $build = Module::Build->new
(
  module_name => 'VMachine',
  license => 'perl',
  dist_author => 'DAVIDIAM <davidihnen@gmail.com>',
  dist_abstract => 'lib/VMAchine.pm',
  requires => {
  },
  build_requires => {
    'Test::Class' => 0,
  },
);
$build->create_build_script;
