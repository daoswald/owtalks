#!/usr/bin/env perl

use strict;
use warnings;
use FindBin '$Bin';
use lib "$Bin/../lib";
use OpenWest::Talks::Config;
use OpenWest::Talks::Load;
use Data::Dump 'dd';

use constant DEBUG => 1;

our $config;
BEGIN{ $config = OpenWest::Talks::Config->new( debug => DEBUG )->data }

use constant RESOURCE_PATH   => "$Bin/../" . $config->{resource_path};
use constant JSON_TALKS_FILE => $config->{resource_filename};
if( DEBUG ) {
  warn "# " .__PACKAGE__ . ": DEBUG mode. " .
       "\n#\tConfiguration:  \t$config->{configuration_name}" .
       "\n#\tRESOURCE_PATH:  \t" . RESOURCE_PATH .
       "\n#\tJSON_TALKS_FILE:\t" . JSON_TALKS_FILE . "\n#\n";
}


my $data = OpenWest::Talks::Load->new(
  uri      => $config->{talks_uri},
  path     => RESOURCE_PATH,
  filename => JSON_TALKS_FILE,
  debug    => DEBUG,
)->data;

warn "# " . __PACKAGE__ . ": Retrieved " . @{$data->{talks}} . " records.\n"
  if DEBUG;

# @{$json->{talks}[n]}{ qw/
#    duration       # Minutes.
#    slides_link    # "link..." (Joindin or otherwise)
#    speakers       # aref of hashrefs of speaker_name, speaker_uri(opt)
#    talk_description # "synopsis...."
#    talk_title       # "title...."
#    tracks         # aref of hashrefs of track_name, track_uri.
#    type           # "Event Related", "Talk", "Workshop", "Keynote"...?
#       Event related entries have empty speaker and track arefs.
#       Keynotes have SB 134 - Keynote track_name.
#    talk_url       # joindin link: "link...."
#    start_date     # "2014-05-08T10:30:00-06:00"
#    uri            # API
#    website_uri    # joindin only? view

=cut
for( 0 .. $#{$data->{talks}} ) {
  dd $data->{talks}[$_];
  <STDIN>
}
=cut
