#===============================================================================
#
#         FILE: ISPconfigSOAP.pm
#
#  DESCRIPTION: 
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Matthias Bethke (mbethke), matthias@towiski.de
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 08/29/2012 01:43:32 PM
#     REVISION: ---
#===============================================================================

use Moose; 
use MooseX::Declare;

class P2I::ISPconfigSOAP {
    use MooseX::ClassAttribute;
    use SOAP::Lite;

    class_has [qw/ user pass uri proxy /] => (is => 'rw', isa => 'Str');
    class_has soap      => (is => 'ro', isa => 'SOAP::Lite', lazy => 1, builder => '_init_soap');
    class_has session   => (is => 'ro', isa => 'Str',         lazy => 1, builder => '_init_session');

    method soap_call {
        my $method = shift;
        $self->soap->$method($self->session, @_);
    }

    sub _init_soap {
        return SOAP::Lite
        -> uri(__PACKAGE__->uri)
        -> proxy(__PACKAGE__->proxy);
    }
   
    method _init_session {
        return $self->soap->login($self->user, $self->pass);
    }
}

