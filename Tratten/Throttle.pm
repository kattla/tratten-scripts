package Tratten::Throttle;

use strict;
use warnings;
use URI;

our $SHIFT_INTERVAL = 30; # seconds
our $BUCKETS = 2;

sub seconds_to_sleep {
  $_ = shift; # Total number of requests for host in buckets.
  if ($_ > 8) { return 3; }
  if ($_ > 3) { return 1; }
  return 0;
}

our @bucket;
our $last_shift = time;

sub update {
  my $diff = time - $last_shift;
  while ($diff > $SHIFT_INTERVAL) {
    unshift @bucket, {}; $diff -= $SHIFT_INTERVAL; $last_shift = time;
  }
  while (scalar @bucket > $BUCKETS) { pop @bucket; }
  unless ($bucket[0]) { $bucket[0] = {}; }
}

sub sync {
  my ($uri) = @_;
  my $host = URI->new($uri)->host;
  &update;
  my $count = 0; for (@bucket) { $count += $_->{$host} || 0; }
  $bucket[0]->{$host}++;
  sleep &seconds_to_sleep($count);
}

1;
