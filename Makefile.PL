use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
  'NAME'         => 'Relations::Display',
  'VERSION_FROM' => 'Display.pm', 
  ($] ge '5.005') ? 
  (
    'AUTHOR'   => 'George A. Fitch III (aka Gaffer), gaf3@gaf3.com',
    'ABSTRACT' => 'Generate GD::Graphs from DBI/DBD::mysql queries',
  ) : (),
  'PREREQ_PM' => 
  { 
    'DBI'                 => 1.13,
    'DBD::mysql'          => 1.18,
    'GD::Graph'           => 1.30,
    'Relations'           => 0.93,
    'Relations::Query'    => 0.92,
    'Relations::Abstract' => 0.93,
  },
  'PM' => {
     'Display.pm'       => '$(INST_LIBDIR)/Display.pm',
     'Display/Table.pm' => '$(INST_LIBDIR)/Display/Table.pm',
  }
);

