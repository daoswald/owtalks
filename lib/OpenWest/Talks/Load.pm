# Load talk JSON from file.  If the file doesn't exist, invoke
# OpenWest::Talks::Scraper to pull it from the joindin website.
# After scraping from the site's API, saves it to a file so that
# it may be used again on future calls.

# Returns a data structure from the decoded JSON.

package OpenWest::Talks::Load;

use strict;
use warnings;

use Try::Tiny;
use JSON::Tiny 'decode_json';

use FindBin '$Bin';
use lib "$Bin/../lib";
use OpenWest::Talks::Scraper;

use namespace::clean;
use Moo;

has uri            => ( is => 'ro', required => 1 );
has path           => ( is => 'ro', required => 1 );
has filename       => ( is => 'ro', required => 1 );
has debug          => ( is => 'ro', default => sub { 0 } );
has data           => ( is => 'lazy' );
has _full_filename => ( is => 'lazy' );

sub BUILD {
  my $self = shift;
  if( $self->debug ) {
    warn "# " . __PACKAGE__ . ":\n";
    warn "#\turi:     \t" . $self->uri            . "\n";
    warn "#\tpath:    \t" . $self->path           . "\n";
    warn "#\tfilename:\t" . $self->filename       . "\n";
    warn "#\tfullname:\t" . $self->_full_filename . "\n#\n";
  }
}

sub _build__full_filename {
  my $self = shift;
  return $self->path . '/' . $self->filename;
}

sub _build_data {
  my $self = shift;
  my $json;
  try {
    $json = $self->_read_json_file;
  }
  catch {
    $json = $self->_fetch_json;
    $self->_write_json_file( $json );
  };
  return decode_json($json);
}


sub _fetch_json {
  my $self = shift;
  my $json = do {
    my $scraper = OpenWest::Talks::Scraper->new(
      debug => $self->debug,
      uri   => $self->uri,
    );
    $scraper->content;
  };
  die "Unable to fetch JSON\n" unless length $json;
  return $json;
}

sub _read_json_file {
  my $self = shift;
  my $filename = $self->_full_filename;
  open my $fh, '<', $filename or die "Couldn't open JSON resource file: $!";
  local $/ = undef;
  my $json = <$fh>;
  die "JSON file is empty!\n" unless length $json;
  return $json;
}

sub _write_json_file {
  my( $self, $json ) = @_;
  my $filename = $self->_full_filename;
  die "Cannot write an empty JSON file!\n" unless length $json;
  open my $fh, '>', $filename or die "Unable to open $filename for output: $!";
  print $fh $json;
  close $fh or die "Unable to close output file $filename: $!";
}

1;
