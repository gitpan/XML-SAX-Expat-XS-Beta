# $Id: Expat.pm,v 1.6 2002/02/15 17:46:51 matt Exp $

package XML::SAX::Expat;
use strict;
use vars qw($VERSION @ISA);

use XML::SAX::Base;
use DynaLoader ();

$VERSION = '0.01';
@ISA = qw(DynaLoader XML::SAX::Base);

XML::SAX::Expat->bootstrap($VERSION);

use Carp;

sub _parse_characterstream {
    my ($self, $fh) = @_;
    $self->{ParserOptions}{ParseFunc} = \&ParseStream;
    $self->{ParserOptions}{ParseFuncParam} = $fh;
    $self->_parse;
}

sub _parse_bytestream {
    my ($self, $fh) = @_;
    $self->{ParserOptions}{ParseFunc} = \&ParseStream;
    $self->{ParserOptions}{ParseFuncParam} = $fh;
    $self->_parse;
}

sub _parse_string {
    my $self = shift;
    $self->{ParserOptions}{ParseFunc} = \&ParseString;
    $self->{ParserOptions}{ParseFuncParam} = $_[0];
    $self->_parse;
}

use IO::File;

sub _parse_systemid {
    my $self = shift;
    my $fh = IO::File->new(shift);
    $self->{ParserOptions}{ParseFunc} = \&ParseStream;
    $self->{ParserOptions}{ParseFuncParam} = $fh;
    $self->_parse;
}

sub _parse {
    my $self = shift;

    my $args = bless $self->{ParserOptions}, ref($self);

    # copy handlers over
    $args->{Handler} = $self->{Handler};
    $args->{DocumentHandler} = $self->{DocumentHandler};
    $args->{ContentHandler} = $self->{ContentHandler};
    $args->{DTDHandler} = $self->{DTDHandler};
    $args->{LexicalHandler} = $self->{LexicalHandler};
    $args->{DeclHandler} = $self->{DeclHandler};
    $args->{ErrorHandler} = $self->{ErrorHandler};
    $args->{EntityResolver} = $self->{EntityResolver};

    $args->{_State_} = 0;
    $args->{Context} = [];
    $args->{ErrorMessage} ||= '';
    $args->{Namespace_Stack} = [[ xml => 'http://www.w3.org/XML/1998/namespace' ]];
    $args->{Parser} = ParserCreate($args, $args->{ProtocolEncoding}, 1);

    $args->start_document({});
    my $result = $args->{ParseFunc}->($args->{Parser}, $args->{ParseFuncParam});

    ParserFree($args->{Parser});

    croak($args->{ErrorMessage}) unless $result;

    return $args->end_document({});
}

1;

