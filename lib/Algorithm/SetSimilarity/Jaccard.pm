package Algorithm::SetSimilarity::Jaccard;

use 5.008005;
use strict;
use warnings;

use YAML;

our $VERSION = "0.01";

sub new {
    my ($class, $param) = @_;
    my %hash = ();
    $hash{"is_sorted"} = $param->{is_sorted} if (exists $param->{is_sorted});
    bless \%hash, $class;
}

sub get_similarity {
    my ($self, $set1, $set2) = @_;
    my $score = -1.0;
    if ((ref $set1 eq "ARRAY") && (ref $set2 eq "ARRAY") && (@$set1) && (@$set2)) {
        unless ( $self->{is_sorted} ) {
            @{$set1} = sort {$a cmp $b} @$set1;
            @{$set2} = sort {$a cmp $b} @$set2;
        }
        my ($min_att, $max_att) = ($#$set1, $#$set2);
        ($min_att, $max_att) = ($#$set2, $#$set1) if ($min_att > $max_att);

        my $match_num = 0;

        for (my ($att1, $att2) = (0, 0); ($att1 <= $min_att) && ($att2 <= $min_att);) {
            if (($set1->[$att1] cmp $set2->[$att2]) == -1) {
                $att1++;
            } elsif (($set1->[$att1] cmp $set2->[$att2]) == 1) {
                $att2++;
            } else {
                $match_num++;
                $att1++;
                $att2++;
            }
        }

        my $diff_num = ($max_att + 1 - $match_num) + ($min_att + 1 - $match_num);
        $score = $match_num / ($match_num + $diff_num);
    }
    return $score;
}

sub _swap_set_ascending_order {
    my ($self, $set1, $set2) = @_;
    if ($#$set1 > $#$set2) {
        my $tmp_ref = $set1;
        $set1 = $set2;
        $set2 = $tmp_ref;
    }
    return wantarray ? ($set1, $set2) : [$set1, $set2];
}

sub filt {
    my ($self, $set1, $set2, $threshold) = @_;
    my $score = -1.0;
    if ((ref $set1 eq "ARRAY") && (ref $set2 eq "ARRAY") &&
            (@$set1) && (@$set2) &&
                ($threshold >= 0.0) && ($threshold <= 1.0)) {
        for(my $r = 0; $r <= 0; $r++) {
            last unless (((($#$set1 + 1) * $threshold) < $#$set2) && ((($#$set2 + 1) * $threshold) < $#$set1));

            my $alpha = 0;
            for (my $i = 0; $i <= $alpha; $i++) {
            }
        }
    }
    return $score;
}

1;

__END__

=encoding utf-8

=head1 NAME

Algorithm::SetSimilarity::Jaccard - It's new $module

=head1 SYNOPSIS

    use Algorithm::SetSimilarity::Jaccard;

=head1 DESCRIPTION

Algorithm::SetSimilarity::Jaccard is ...

=head1 LICENSE

Copyright (C) Toshinori Sato (@overlast).

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Toshinori Sato (@overlast) E<lt>overlasting@gmail.comE<gt>

=cut
