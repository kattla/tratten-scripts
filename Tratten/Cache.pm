package Tratten::Cache;

use strict;
use warnings;
use Tratten::Throttle;
use CHI;
use Digest::SHA;
use LWP::UserAgent;

system "mkdir -p _cache";

our $cache = CHI->new( driver => 'File', root_dir => '_cache' );

sub get { $cache->get(@_) }
sub set { $cache->set(@_) }

sub URI {
  my $uri = shift;
  my %arg = @_;
  my $data = $cache->get($uri);
  return $data->{content} if $data && not ($arg{expire_if} && $arg{expire_if}($data));
  my $ua = LWP::UserAgent->new;
  print STDERR "Fetching $uri\n";
  Tratten::Throttle::sync($uri);
  my $r = $ua->get($uri);
  die $r->status_line unless $r->is_success;
  $data = {
    uri => $uri,
    headers => $r->headers_as_string,
    timestamp => time,
    sha256 => Digest::SHA::sha256_hex($r->decoded_content),
    content => $r->decoded_content,
  };
  if ($arg{meta}) { $data->{$_} = $arg{meta}->{$_} for keys %{$arg{meta}} }
  $cache->set($uri, $data);
  return $data->{content};
}

1;
