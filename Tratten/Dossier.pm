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
        my $k = $col[0]->as_trimmed_text;
        my $v = $col[1]->as_trimmed_text; s/^\s+//, s/\s+$// for ($v);
        if ($k eq "Reference") { $data{reference} = $v; }
        elsif ($k eq "Title") { $data{title} = $v; }
        elsif ($k eq "Legal Basis") { $data{legal_basis} = $v; }
        elsif ($k eq "Dossier of the committee") { $data{committee_dossier} = $v; }
        elsif ($k eq "Stage reached") { $data{stage_reached} = $v;}
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
