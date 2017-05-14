#!/usr/bin/perl

package eBay::API::XML::DataType::GetRecommendationsRequestContainerType;

use strict;
use warnings;  

##########################################################################
#
# Module: ............... <user defined location>eBay/API/XML
# File: ................. GetRecommendationsRequestContainerType.pm
# Generated by: ......... genEBayApiDataTypes.pl
# Last Generated: ....... 08/24/2008 16:44
# API Release Number: ... 579
#
##########################################################################  

=head1 NAME

eBay::API::XML::DataType::GetRecommendationsRequestContainerType

=head1 DESCRIPTION

Specifies the data for a single item and configures the recommendation engines to use
when processing the item with GetItemRecommendations.



=head1 SYNOPSIS

=cut


=head1 INHERITANCE

eBay::API::XML::DataType::GetRecommendationsRequestContainerType inherits from the L<eBay::API::XML::BaseDataType> class

=cut

use eBay::API::XML::BaseDataType;
our @ISA = ("eBay::API::XML::BaseDataType");

use eBay::API::XML::DataType::ItemType;
use eBay::API::XML::DataType::Enum::ListingFlowCodeType;
use eBay::API::XML::DataType::Enum::RecommendationEngineCodeType;


my @gaProperties = ( [ 'CorrelationID', 'xs:string', '', '', '' ]
	, [ 'DeletedField', 'xs:string', '1', '', '' ]
	, [ 'Item', 'ns:ItemType', ''
	     ,'eBay::API::XML::DataType::ItemType', '1' ]
	, [ 'ListingFlow', 'ns:ListingFlowCodeType', ''
	     ,'eBay::API::XML::DataType::Enum::ListingFlowCodeType', '' ]
	, [ 'Query', 'xs:string', '', '', '' ]
	, [ 'RecommendationEngine', 'ns:RecommendationEngineCodeType', '1'
	     ,'eBay::API::XML::DataType::Enum::RecommendationEngineCodeType', '' ]
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



=head2 setCorrelationID()

Unique key to identify the response that matches this recommendation request container.
Use this key to distinguish between responses when multiple
recommendation containers are specified (i.e., for batch requests).
You define the key. To be useful, each correlation ID should be unique within
the same call. That is, define a different correlation ID for each recommendation
request container. (eBay does not validate the uniqueness of these IDs.)
If specified, the same correlation ID will be returned in the corresponding
recommendation response (or error response).
We recommend that you use this when retrieving recommendations for multiple items at once.

  Calls: GetItemRecommendations
  RequiredInput: No

#    Argument: 'xs:string'

=cut

sub setCorrelationID {
  my $self = shift;
  $self->{'CorrelationID'} = shift
}

=head2 getCorrelationID()

#    Returns: 'xs:string'

=cut

sub getCorrelationID {
  my $self = shift;
  return $self->{'CorrelationID'};
}


=head2 setDeletedField()

Specifies the name of the field to remove from a listing.
Applicable when the ListingFlow is ReviseItem or RelistItem.
See ReviseItem and RelistItem for applicable values.

SeeLink: URL: io_RelistItem.html#Request.DeletedField
Title: (RelistItem) DeletedField
, URL: io_ReviseItem.html#Request.DeletedField
Title: (ReviseItem) DeletedField


  Calls: GetItemRecommendations
  RequiredInput: Conditionally

#    Argument: reference to an array  
                      of 'xs:string'

=cut

sub setDeletedField {
  my $self = shift;
  $self->{'DeletedField'} = 
		$self->convertArray_To_RefToArrayIfNeeded(@_);
}

=head2 getDeletedField()

#    Returns: reference to an array  
                      of 'xs:string'

=cut

sub getDeletedField {
  my $self = shift;
  return $self->_getDataTypeArray('DeletedField');
}


=head2 setItem()

Contains fields that describe the item for which you are seeking recommendations. <br>
<br>
If the Listing Analyzer recommendation engine is run, the applicable fields are
the same as the fields for AddItem, ReviseItem, or RelistItem
requests, as determined by the value specified in ListingFlow.
The item ID (Item.ItemID) is required when the ListingFlow is ReviseItem or RelistItem,
and it is not applicable when the ListingFlow is AddItem.
All other item fields are optional, even if listed as required for other calls.
However, as some tips are dependent on the properties of the item, and as some properties
have dependencies on other properties, we strongly recommend that you include all the item properties
that will be included in the AddItem, ReviseItem, or RelistItem request.
When the Listing Analyzer engine is run, tips will only be returned for fields that are specfied on the item.<br>
<br>
When the Product Pricing engine is run, pricing data will be based on the catalog product you specify.

  Calls: GetItemRecommendations
  RequiredInput: Yes

#    Argument: 'ns:ItemType'

=cut

sub setItem {
  my $self = shift;
  $self->{'Item'} = shift
}

=head2 getItem()

#    Returns: 'ns:ItemType'

=cut

sub getItem {
  my $self = shift;
  return $self->_getDataTypeInstance( 'Item'
		,'eBay::API::XML::DataType::ItemType');
}


=head2 setListingFlow()

The listing flow for which the seller is seeking Listing Analyzer recommendations.
Not applicable to results from other recommendation engines
(i.e., the Suggested Attributes engine or the Product Pricing engine).
The default flow is AddItem.

  Calls: GetItemRecommendations
  RequiredInput: No
  Default: AddItem

#    Argument: 'ns:ListingFlowCodeType'

=cut

sub setListingFlow {
  my $self = shift;
  $self->{'ListingFlow'} = shift
}

=head2 getListingFlow()

#    Returns: 'ns:ListingFlowCodeType'

=cut

sub getListingFlow {
  my $self = shift;
  return $self->{'ListingFlow'};
}


=head2 setQuery()

One or more keywords to search for when using the Suggested Attributes engine.
Required when SuggestedAttributes is specified as the recommendation engine
(including when no recommendation engines are specified). Only the listing title
is searched. The words "and" and "or" are treated like any other word.
Blank searches are not allowed (and result in a warning).

MaxLength: 350 (characters)

  Calls: GetItemRecommendations
  RequiredInput: Conditionally

#    Argument: 'xs:string'

=cut

sub setQuery {
  my $self = shift;
  $self->{'Query'} = shift
}

=head2 getQuery()

#    Returns: 'xs:string'

=cut

sub getQuery {
  my $self = shift;
  return $self->{'Query'};
}


=head2 setRecommendationEngine()

A recommendation engine to run. If no engines are specified, all available
recommendation engines will run. Some engines require additional fields,
such as Item.PrimaryCategory.CategoryID, to be specified.
If the ProductPricing engine is specified but Item.ProductListingDetails is not specified,
no Product Pricing engine results are returned.

  Calls: GetItemRecommendations
  RequiredInput: No

#    Argument: reference to an array  
                      of 'ns:RecommendationEngineCodeType'

=cut

sub setRecommendationEngine {
  my $self = shift;
  $self->{'RecommendationEngine'} = 
		$self->convertArray_To_RefToArrayIfNeeded(@_);
}

=head2 getRecommendationEngine()

#    Returns: reference to an array  
                      of 'ns:RecommendationEngineCodeType'

=cut

sub getRecommendationEngine {
  my $self = shift;
  return $self->_getDataTypeArray('RecommendationEngine');
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