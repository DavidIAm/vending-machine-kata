use Module::Build;
my $build = Module::Build->new(
    module_name   => 'VMachine',
    license       => 'perl',
    dist_author   => 'DAVIDIAM <davidihnen@gmail.com>',
    dist_abstract => 'lib/VMachine.pm',
    requires      => {
        'List::Util'     => 0,
        'Cwd'            => 0,
        'File::Basename' => 0,
        'File::Spec'     => 0,
        'Moose'          => 0,
        'Moose::Role'    => 0,
    },
    build_requires =>
        { 'Test::Class' => 0, 'Test::Most' => 0, 'Test::Output' => 0, },
);
$build->create_build_script;
