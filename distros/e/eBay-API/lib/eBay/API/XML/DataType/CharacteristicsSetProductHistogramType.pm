#!/usr/bin/perl

package eBay::API::XML::DataType::CharacteristicsSetProductHistogramType;

use strict;
use warnings;  

##########################################################################
#
# Module: ............... <user defined location>eBay/API/XML
# File: ................. CharacteristicsSetProductHistogramType.pm
# Generated by: ......... genEBayApiDataTypes.pl
# Last Generated: ....... 08/24/2008 16:44
# API Release Number: ... 579
#
##########################################################################  

=head1 NAME

eBay::API::XML::DataType::CharacteristicsSetProductHistogramType

=head1 DESCRIPTION

A generic type used for histograms.



=head1 SYNOPSIS

=cut


=head1 INHERITANCE

eBay::API::XML::DataType::CharacteristicsSetProductHistogramType inherits from the L<eBay::API::XML::BaseDataType> class

=cut

use eBay::API::XML::BaseDataType;
our @ISA = ("eBay::API::XML::BaseDataType");

use eBay::API::XML::DataType::HistogramEntryType;


my @gaProperties = ( [ 'HistogramEntry', 'ns:HistogramEntryType', '1'
	     ,'eBay::API::XML::DataType::HistogramEntryType', '1' ]
                    );
push @gaProperties, @{eBay::API::XML::BaseDataType::getPropertiesList()};

my @gaAttributes = ( 
                    );
push @gaAttributes, @{eBay::API::XML::BaseDataType::getAttributesList()};

=head1 Subroutines:

=cut

sub new {
  my $classname = shift;
  my %args = @_;
  my $self = $classname->SUPER::new(%args);
  return $self;
}

sub isScalar {
   return 0; 
}



=head2 setHistogramEntry()

In GetProducts, each histogram entry shows how many matching products
were found in each matching domain. A domain is like a high-level
category. (A domain is also called an attribute set or a
characteristic set.)

#    Argument: reference to an array  
                      of 'ns:HistogramEntryType'

=cut

sub setHistogramEntry {
  my $self = shift;
  $self->{'HistogramEntry'} = 
		$self->convertArray_To_RefToArrayIfNeeded(@_);
}

=head2 getHistogramEntry()

  Calls: GetProducts
  Returned: Conditionally

#    Returns: reference to an array  
                      of 'ns:HistogramEntryType'

=cut

sub getHistogramEntry {
  my $self = shift;
  return $self->_getDataTypeArray('HistogramEntry');
}





##  Attribute and Property lists
sub getPropertiesList {
   my $self = shift;
   return \@gaProperties;
}

sub getAttributesList {
   my $self = shift;
   return \@gaAttributes;
}



1;   