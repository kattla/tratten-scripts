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
      for (@row) {
        my @col = $_->content_list;
        $_ = $col[0]->as_trimmed_text;
        if ($_ eq "Reference") { $data{reference} = $col[1]->as_trimmed_text; }
        elsif ($_ eq "Title") { $data{title} = $col[1]->as_trimmed_text; }
        elsif ($_ eq "Legal Basis") { $data{legal_basis} = $col[1]->as_trimmed_text; }
        elsif ($_ eq "Dossier of the committee") { $data{committee_dossier} = $col[1]->as_trimmed_text; }
        elsif ($_ eq "Stage reached") { $data{stage_reached} = $col[1]->as_trimmed_text;}
      }
    } elsif (/Agents/) {
      $_ = shift @row; $_ = $_->as_trimmed_text; unless (/European Parliament/) { warn; next; }
      if (/Committee/) {
        my @x = $row[0]->content_list;
        my @agents = map { +{ committee => $_->as_trimmed_text } } $x[0]->content_list;
        $data{agents} = \@agents;
      } else {
        shift @row;
        my @agents = map {
          my @col = $_->content_list;
          +{ committee => $col[0]->as_trimmed_text, MEP => $col[1]->as_trimmed_text };
        } @row;
        $data{agents} = \@agents;
      }
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
