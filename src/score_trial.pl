#!/usr/bin/perl
use strict;
use warnings;

use Getopt::Long;

my $permutations = 1;

GetOptions("permutations" => \$permutations);

our $valid_row_regex = qr/
   (?<chan1>-?[0-9]+(?:\.[0-9]*)),\s*
   (?<chan2>-?[0-9]+(?:\.[0-9]*)),\s*
   (?<_x>[0-9]*),\s*(?<x_target>[0-9]*),\s*
   (?<_y>[0-9]*),\s*(?<y_target>[0-9]*),\s*
   (?<time>-?[0-9]*).*
/x;

our $default_targets = {
    '75_475'  => { x => 75,  y => 475 },
    '475_475' => { x => 475, y => 475 },
    '75_75'   => { x => 75,  y => 75 },
    '475_75'  => { x => 475, y => 75 },
    '275_275' => { x => 275, y => 275 },
    '275_475' => { x => 275, y => 475 },
    '75_275'  => { x => 75,  y => 275 },
    '275_75'  => { x => 275, y => 75 },
    '475_275' => { x => 475, y => 275 },
};

my $distances = [];

my $permutation = $default_targets;

while (<STDIN>) {
    if ( $_ =~ m/$valid_row_regex/ ) {
        my $time = $+{time};
        if ($time <= 0) {
            next;
        }

        my $x = $+{_x};
        my $x_target = $+{x_target};
        my $y = $+{_y};
        my $y_target = $+{y_target};

        my $key = $x_target . '_' . $y_target;

        my $compare_targets = $permutation->{$key};
        my $x_compare = $compare_targets->{x};
        my $y_compare = $compare_targets->{y};

        push @$distances, abs($x_compare - $x), abs($y_compare - $y);
    }
}

my $num_samples = scalar @$distances;
my $mean_pos = int((scalar @$distances) / 2);
print "Samples: $num_samples (using sorted position $mean_pos)\n";
my @sorted = sort {$a <=> $b} @$distances;
my $mean = $sorted[$mean_pos];

print "Mean:    $mean\n";
