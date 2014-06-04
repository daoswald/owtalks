package OpenWest::Talks::Config;

use strict;
use warnings;

use JSON::Tiny 'decode_json';
use FindBin '$Bin';
use Data::Dump 'ddx';

use namespace::clean;
use Moo;

has filename => ( is => 'ro', default => "$Bin/../resources/config.json" );
has data     => ( is => 'lazy' );
has debug    => ( is => 'ro', default => sub { 0 } );

sub BUILD {
  my $self = shift;
  if( $self->debug ) {
    warn "# " . __PACKAGE__ . ":\n";
    ddx $self->data;
    warn "#\n";
  }
}

sub _build_data {
  my $self = shift;
  my $fh;
  if( $self->debug or not open $fh, '<', $self->filename ) {
    $fh = \*DATA;
  }
  local $/ = undef;
  return decode_json(<$fh>);
}

1;

__DATA__
{
  "configuration_name":"embedded",
  "resource_path":"resources",
  "resource_filename":"ow14talks.json",
  "talks_uri":"http://api.joind.in/v2.1/events/1793/talks?resultsperpage=200&format=json"
}
