# $Id$
#
# BioPerl module for Bio::Tools::ApplicationFactoryI
#
# Cared for by Heikki Lehvaslaiho <heikki@ebi.ac.uk>
#
# Copyright Heikki Lehvaslaiho
#
# You may distribute this module under the same terms as perl itself

# POD documentation - main docs before the code

=head1 NAME

Bio::Tools::ApplicationFactoryI - Base object for Application Factories

=head1 SYNOPSIS

You wont be using this as an object, but using a dervied class

=head1 DESCRIPTION

Holds common Application Factory attributes in place

=head1 FEEDBACK

=head2 Mailing Lists

User feedback is an integral part of the evolution of this and other
Bioperl modules. Send your comments and suggestions preferably to the
Bioperl mailing lists  Your participation is much appreciated.

  bioperl-l@bioperl.org                         - General discussion
  http://bio.perl.org/MailList.html             - About the mailing lists

=head2 Reporting Bugs

report bugs to the Bioperl bug tracking system to help us keep track
 the bugs and their resolution.  Bug reports can be submitted via
 email or the web:

  bioperl-bugs@bio.perl.org
  http://bio.perl.org/bioperl-bugs/

=head1 AUTHOR - Heikki Lehvaslaiho

Email:  heikki@ebi.ac.uk
Address:

     EMBL Outstation, European Bioinformatics Institute
     Wellcome Trust Genome Campus, Hinxton
     Cambs. CB10 1SD, United Kingdom

=head1 APPENDIX

The rest of the documentation details each of the object
methods. Internal methods are usually preceded with a _

=cut

# Let the code begin...

package Bio::Tools::ApplicationFactoryI;
use vars qw(@ISA);
use strict;

use Bio::Root::RootI;
@ISA = qw(Bio::Root::RootI);


sub new {
  my($class,@args) = @_;
  my $self = $class->SUPER::new(@args);
  $self->_initialize(@args);
  # set up defaults
  
  return $self;
}


=head2 report

 Title     : report()
 Usage     : set/gets the report boolean to issue reports or not
 Function  : 
           : $factory->report(1); # reporting goes on
           :
 Returns   : n/a
 Argument  : 1 or 0

=cut

sub report {
    my ($self,$value) = @_;
    

    if( defined $value ) {
	if( $value != 1 && $value != 0 ) {
	    $self->throw("Attempting to modify AlignFactory Report with no boolean value!");
	}
	$self->{'report'} = $value;
    } 

    return $self->{'report'};
}

1;
