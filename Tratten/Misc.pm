package Tratten::Misc;

use strict;
use warnings;
use Digest::SHA;
use base 'Exporter';
our @EXPORT = qw(get_version_string);

sub get_version_string {
  my %versions = %{ &read_versions }; 
  my $sha = Digest::SHA->new("sha1");
  $sha->addfile($0);
  my $digest = $sha->hexdigest;
  return $versions{$digest} if $versions{$digest};
  return "$0 unknown version";
}

sub read_versions {
  my %ret;
  if (open my $F, "< versions") {
    while (<$F>) {
      if (/^\s*([0-9a-f]{40})\s+(.*)$/) { $ret{$1} = $2 }
      else { print STDERR "Warning: Malformed line in 'versions' file.\n" }
    }
  }
  else {  print STDERR "Warning: Could not find a 'versions' file.\n" }
  return \%ret;
}

1;
