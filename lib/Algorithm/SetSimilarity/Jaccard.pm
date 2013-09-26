package Algorithm::SetSimilarity::Jaccard;

use 5.008005;
use strict;
use warnings;

our $VERSION = "0.0.0_03";

use Scalar::Util;

sub new {
    my ($class, $param) = @_;
    my %hash = ();
    $hash{"is_sorted"} = $param->{is_sorted} if (exists $param->{is_sorted});
    $hash{"data_type"} = $param->{data_type} if (exists $param->{data_type});
    bless \%hash, $class;
}

sub estimate_data_type {
    my ($self, $set1, $set2) = @_;
    my $is_estimate = 0;
    my ($type1, $type2) = ("string","string");

    if (Scalar::Util::looks_like_number($set1->[0])) {
        $type1 = "number";
    }
    if (Scalar::Util::looks_like_number($set2->[0])) {
        $type2 = "number";
    }

    if ($type1 eq $type2) {
        $self->{data_type} = $type1;
        $is_estimate = 1;
    }
    return $is_estimate;
}

sub get_similarity {
    my ($self, $set1, $set2, $threshold) = @_;
    my $score = -1.0;
    if ((ref $set1 eq "ARRAY") && (ref $set2 eq "ARRAY") && (@$set1) && (@$set2)) {
        if ((defined $threshold) && ($threshold > 0.0)) {
            $score = $self->filt_by_threshold($set1, $set2, $threshold);
        } else{
            ($set1, $set2) = $self->_swap_set_descending_order($set1, $set2);
            my $s1 = $#$set1 + 1;
            my $s2 = $#$set2 + 1;
            my $is_estimate = $self->estimate_data_type($set1, $set2) unless (exists $self->{data_type});
            if (($is_estimate) || (exists $self->{data_type})) {
                unless ( $self->{is_sorted} ) {
                    if ($self->{data_type} eq "number") {
                        @{$set1} = sort {$a <=> $b} @$set1;
                        @{$set2} = sort {$a <=> $b} @$set2;
                    } else {
                        @{$set1} = sort {$a cmp $b} @$set1;
                        @{$set2} = sort {$a cmp $b} @$set2;
                    }
                }
                my $match_num = 0;
                for (my ($att1, $att2) = (0, 0); ($att1 < $s2) && ($att2 < $s2);) {
                    my $judge = -1;
                    if ($self->{data_type} eq "number") {
                        $judge = ($set1->[$att1] <=> $set2->[$att2]);
                    } else {
                        $judge = ($set1->[$att1] cmp $set2->[$att2]);
                    }

                    if ($judge == -1) {
                        $att1++;
                    } elsif ($judge == 1) {
                        $att2++;
                    } else {
                        $match_num++;
                        $att1++;
                        $att2++;
                    }
                }
                my $diff_num = ($s1 - $match_num) + ($s2 - $match_num);
                $score = $match_num / ($match_num + $diff_num);
            }
        }
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

 sub _swap_set_descending_order {
     my ($self, $set1, $set2) = @_;
     if ($#$set1 < $#$set2) {
         my $tmp_ref = $set1;
         $set1 = $set2;
         $set2 = $tmp_ref;
     }
     return wantarray ? ($set1, $set2) : [$set1, $set2];
 }

sub filt_by_threshold {
    my ($self, $set1, $set2, $threshold) = @_;
    my $score = -1.0;
    if ((ref $set1 eq "ARRAY") && (ref $set2 eq "ARRAY") &&
            (@$set1) && (@$set2) &&
                ($threshold > 0.0) && ($threshold <= 1.0)) {

        for(my $r = 0; $r <= 0; $r++) {
            ($set1, $set2) = $self->_swap_set_descending_order($set1, $set2);
            my $s1 = $#$set1 + 1;
            my $s2 = $#$set2 + 1;

            last unless (($s1 * $threshold) <= $s2); #size filtering

            my $is_estimate = $self->estimate_data_type($set1, $set2) unless (exists $self->{data_type});
            if (($is_estimate) || (exists $self->{data_type})) {
                unless ( $self->{is_sorted} ) {
                    if ($self->{data_type} eq "number") {
                        @{$set1} = sort { $a <=> $b } @$set1;
                        @{$set2} = sort { $a <=> $b } @$set2;
                    } else {
                        @{$set1} = sort { $a cmp $b} @$set1;
                        @{$set2} = sort { $a cmp $b} @$set2;
                    }
                }

                my $min_overlap = int(($threshold / (1 + $threshold)) * ($s1 + $s2));
                my $alpha = $s2 - ($min_overlap + 1) + 1;
                my $match_num = 0;
                my ($att1, $att2) = (0, 0);

                while (($att2 < $alpha) && ($att1 < $s1)) {
                    my $judge = -1;
                    if ($self->{data_type} eq "number") {
                        $judge = ($set1->[$att1] <=> $set2->[$att2]);
                    } else {
                        $judge = ($set1->[$att1] cmp $set2->[$att2]);
                    }

                    if ($judge == -1) {
                        $att1++;
                    } elsif ($judge == 1) {
                        $att2++;
                    } else {
                        $match_num++;
                        $att1++;
                        $att2++;
                    }
                }
                my $min = ($s2 - $att2);
                $min = ($s1 - $att1) if ($min > ($s1 - $att1));
                if (($match_num) + $min < $min_overlap) {
                    $match_num = 0;
                    last;
                }

                last unless ($match_num >= 1);
                while (($att1 < $s1) && ($att2 < $s2)) {
                    my $judge = -1;
                    if ($self->{data_type} eq "number") {
                        $judge = ($set1->[$att1] <=> $set2->[$att2]);
                    } else {
                        $judge = ($set1->[$att1] cmp $set2->[$att2]);
                    }

                    if ($judge == -1) {
                        last if ($match_num + ($s1 - $att1) < $min_overlap);
                        $att1++;
                    } elsif ($judge == 1) {
                        last if ($match_num + ($s2 - $att2) < $min_overlap);
                        $att2++;
                    } else {
                        $match_num++;
                        $att1++;
                        $att2++;
                    }
                }
                last unless ($match_num >= $min_overlap + 1);
                my $diff_num = ($s1 - $match_num) + ($s2 - $match_num);
                $score = $match_num / ($match_num + $diff_num);
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
