use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME' => 'XML::SAX::Expat',
    'VERSION_FROM' => 'lib/XML/SAX/Expat.pm',
    'PREREQ_PM' => {},
    'ABSTRACT_FROM' => 'lib/XML/SAX/Expat.pm',
    'AUTHOR' => 'Matt Sergeant <matt@sergeant.org>',
    LIBS => '-lexpat',
);
