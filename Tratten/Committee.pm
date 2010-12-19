package Tratten::Committee;

use strict;
use warnings;
use utf8;

my %name = (
  'CODE' => 'Conciliation Committee',
  'AFET' => 'Foreign Affairs',
  'DROI' => 'Human Rights',
  'SEDE' => 'Security and Defence',
  'DEVE' => 'Development',
  'INTA' => 'International Trade',
  'BUDG' => 'Budgets',
  'CONT' => 'Budgetary Control',
  'ECON' => 'Economic and Monetary Affairs',
  'EMPL' => 'Employment and Social Affairs',
  'ENVI' => 'Environment, Public Health and Food Safety',
  'ITRE' => 'Industry, Research and Energy',
  'IMCO' => 'Internal Market and Consumer Protection',
  'TRAN' => 'Transport and Tourism',
  'REGI' => 'Regional Development',
  'AGRI' => 'Agriculture and Rural Development',
  'PECH' => 'Fisheries',
  'CULT' => 'Culture and Education',
  'JURI' => 'Legal Affairs',
  'LIBE' => 'Civil Liberties, Justice and Home Affairs',
  'AFCO' => 'Constitutional Affairs',
  'FEMM' => 'Women\'s Rights and Gender Equality',
  'PETI' => 'Petitions',
  'CRIS' => 'Financial, Economic and Social Crisis',
);

our @abbr = sort keys %name;

my %abbr;
$abbr{$name{$_}} = $_ for keys %name;

$abbr{'Women’s Rights and Gender Equality'} = 'FEMM';
$abbr{'Human Rights, subcommittee'} = 'DROI';
$abbr{'Environment, Public Health, Consumer Policy'} = 'ENVI';
$abbr{'Citizens\' Freedoms and Rights, Justice and Home Affairs'} = 'LIBE';
$abbr{'Legal Affairs and Internal Market'} = 'JURI';
$abbr{'Industry, External Trade, Research, Energy'} = 'ITRE';
$abbr{'Parliament delegation to Conciliation Committee'} = 'CODE';

sub abbreviate {
  return undef unless $_[0];
  return $abbr{$_[0]} if $abbr{$_[0]};
  print STDERR "WARNING: Can't abbreviate \"$_[0]\"\n";
  return undef;
}

sub expand {
  return undef unless $_[0];
  return $name{$_[0]} if $name{$_[0]};
  print STDERR "WARNING: Can't expand abbreviation \"$_[0]\"\n";
  return undef;
}

1;
