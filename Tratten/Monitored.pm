package Tratten::Monitored;

use strict;
use warnings;
use base 'Exporter';
our @EXPORT = qw(get_monitored);

sub get_monitored {
  open my $F, "changedetection.account" or die;

  chomp(my $email = <$F>);
  chomp(my $password = <$F>);
  die("Need email & password each on its own line, in the changedetection.account file. Quitting.") unless $email and $password;

  my $args = "-# --sslv3 --cookie-jar cookies";
  my $form = "-F 'email=$email' -F 'frompage=http://www.changedetection.com/monitors.html' -F 'login=log in' -F 'op=login' -F 'pw=$password'";

  `curl $args --url https://www.changedetection.com/index.html`;
  $_ = `curl $args --cookie cookies $form -L --url https://www.changedetection.com/login.html`;

  my %ret;

  do {
    my @matches = /<a href="\/log\/[^"]+" title="[^"]+"/g;
    for (@matches) {
      /href="([^"]+)" title="([^ ]+)\s+([^"]+)/ or die;
      print STDERR "Warning: Reference number $2 is not unique!\n" if $ret{$2};
      $ret{$2} = ["http://www.changedetection.com$1", $3];
    }
  } while (/<a href='(\/monitors\.html\?rclstart=\d+)'>next<\/a>/
           and ($_ = `curl $args --cookie cookies --url https://www.changedetection.com$1`, 1));

  return \%ret;
}

1;
