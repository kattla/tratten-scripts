package Tratten::Dossier;
use strict;
use warnings;
use HTML::TreeBuilder;

sub parse {
  my %data;
  my $tree = HTML::TreeBuilder->new_from_content($_[0]);
  my @header = $tree->look_down("_tag","h2");
  for my $x (@header) {
    $_ = $x->left;
    $x = $x->look_up("_tag","table")->right;
    my @row = $x->content_list;
    if (/Identification/) {
      my @col = $row[0]->content_list;
      die unless $col[0]->as_trimmed_text eq "Reference";
      $data{reference} = $col[1]->as_trimmed_text;
    } elsif (/Agents/) {
      shift @row; shift @row; # skip headers
      my @agents = map {
        my @col = $_->content_list;
        +{ committee => $col[0]->as_trimmed_text, MEP => $col[1]->as_trimmed_text };
      } @row;
      $data{agents} = \@agents;
    } elsif (/Forecasts/) {
      my @forecasts = map {
        my @col = $_->content_list;
        +{ date => $col[0]->as_trimmed_text, activity => $col[2]->as_trimmed_text };
      } @row;
      $data{forecasts} = \@forecasts;
    }
  }
  return \%data;
}

1;
