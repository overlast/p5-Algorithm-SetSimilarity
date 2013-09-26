package Algorithm::SetSimilarity::WeightedJaccard;

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

sub _swap_set_ascending_order {
    my ($self, $set1, $set2) = @_;
    if (scalar(keys(%$set1)) > scalar(keys(%$set2))) {
        my $tmp_ref = $set1;
        $set1 = $set2;
        $set2 = $tmp_ref;
    }
    return wantarray ? ($set1, $set2) : [$set1, $set2];
}

sub _swap_set_descending_order {
    my ($self, $set1, $set2) = @_;
    if (scalar(keys(%$set1)) < scalar(keys(%$set2))) {
        my $tmp_ref = $set1;
        $set1 = $set2;
        $set2 = $tmp_ref;
    }
    return wantarray ? ($set1, $set2) : [$set1, $set2];
}

sub estimate_data_type {
    my ($self, $set1, $set2) = @_;
    my $is_estimate = 0;
    my ($type1, $type2) = ("string","string");

    foreach my $key1 (keys %$set1) {
        if (Scalar::Util::looks_like_number($key1)) {
            $type1 = "number";
        }
        last;
    }
    foreach my $key2 (keys %$set2) {
        if (Scalar::Util::looks_like_number($key2)) {
            $type2 = "number";
        }
        last;
    }

    if ($type1 eq $type2) {
        $self->{data_type} = $type1;
        $is_estimate = 1;
    }
    return $is_estimate;
}

sub get_key_list_from_hash {
    my ($self, $set) = @_;
    my $s = scalar(keys(%$set));
    my $list;
    if ($self->{data_type} eq "number") {
        if ($s > 1) {
            @{$list} = sort {$set->{$a} <=> $set->{$b}} (keys %$set);
        } else {
            @{$list} = keys %$list;
        }
    } else {
        if ($s > 1) {
            @{$list} = sort {$set->{$a} cmp $set->{$b}} (keys %$set);
        } else {
            @{$list} = keys %$set;
        }
    }
    return $list;
}

sub get_squared_norm {
    my ($self, $vec) = @_;
    my $squared_norm = 0;
    foreach my $key (keys %$vec) {
        $squared_norm += $vec->{$key} * $vec->{$key};
    }
    return $squared_norm;
}

sub get_similarity {
    my ($self, $set1, $set2, $threshold) = @_;
    my $score = -1.0;
    if ((ref $set1 eq "HASH") && (ref $set2 eq "HASH") && (%$set1) && (%$set2)) {
        if ((defined $threshold) && ($threshold > 0.0)) {
            $score = $self->filt_by_threshold($set1, $set2, $threshold);
        } else{
            ($set1, $set2) = $self->_swap_set_descending_order($set1, $set2);
            my $s1 = scalar(keys(%$set1));
            my $s2 = scalar(keys(%$set2));
            my $is_estimate = $self->estimate_data_type($set1, $set2) unless (exists $self->{data_type});
            if (($is_estimate) || (exists $self->{data_type})) {
                my $s_norm1 = $self->get_squared_norm($set1);
                my $s_norm2 = $self->get_squared_norm($set2);
                my $cum_score = 0;
                foreach my $key1 (keys %$set1) {
                    $cum_score += ($set1->{$key1} * $set2->{$key1}) if (exists $set2->{$key1});
                }
                $score = $cum_score / ($s_norm1 + $s_norm2 - $cum_score);
            }
        }
    }
    return $score;
}

sub get_cumulative_weight {
    my ($self, $set) = @_;
    my $cum_weight = 0;
    foreach my $val (values %$set) {
        $cum_weight += $val;
    }
    return $cum_weight;
}

sub make_pair_from_hash {
    my ($self, $set) = @_;
    my @pair = ();
    foreach my $key (keys %$set) {
        my $entry = [$key, $set->{$key}];
        push @pair, $entry;
    }
    $self->estimate_data_type($set) unless (exists $self->{data_type});
    if ($self->{data_type} eq "number") {
        @pair = sort { $a->[0] <=> $b->[0] } @pair;
    } else {
        @pair = sort { $a->[0] cmp $b->[0] } @pair;
    }
    return \@pair;
}

sub filt_by_threshold {
    my ($self, $set1, $set2, $threshold) = @_;
    my $score = -1.0;
    if ((ref $set1 eq "HASH") && (ref $set2 eq "HASH") &&
            (%$set1) && (%$set2) &&
                ($threshold > 0.0) && ($threshold <= 1.0)) {

        for(my $r = 0; $r <= 0; $r++) {
            ($set1, $set2) = $self->_swap_set_descending_order($set1, $set2);
            my $s1 = scalar(keys(%$set1));
            my $s2 = scalar(keys(%$set2));
            my $cum_w1 = $self->get_cumulative_weight($set1);
            my $cum_w2 = $self->get_cumulative_weight($set2);

            last unless (($s1 * $threshold) <= $cum_w2); #size filtering

            my $is_estimate = $self->estimate_data_type($set1, $set2) unless (exists $self->{data_type});
            if (($is_estimate) || (exists $self->{data_type})) {
                my $s_norm1 = $self->get_squared_norm($set1);
                my $s_norm2 = $self->get_squared_norm($set2);
                my $datum1 = $self->make_pair_from_hash($set1);
                my $datum2 = $self->make_pair_from_hash($set2);

                my $cum_score = 0;

                my $min_overlap = int(($threshold / (1 + $threshold)) * ($cum_w1 + $cum_w2));
                my $alpha = $cum_w2 - ($min_overlap + 1) + 1;
                my $match_num = 0;
                my ($att1, $att2) = (0, 0);
                my ($w1, $w2) = ($datum1->[$att1]->[1], $datum2->[$att2]->[1]);
                my ($c1, $c2) = ($w1, $w2);

                while (($c2 < $w2 + $alpha) && ($att1 < $s1) && ($att2 < $s2)) {
                    my $judge = -1;
                    if ($self->{data_type} eq "number") {
                        $judge = ($datum1->[$att1]->[0] <=> $datum2->[$att2]->[0]);
                    } else {
                        $judge = ($datum1->[$att1]->[0] cmp $datum2->[$att2]->[0]);
                    }

                    if ($judge == -1) {
                        $att1++;
                        if ($att1 < $s1) {
                            $w1 = $datum1->[$att1]->[1];
                            $c1 += $w1;
                        }
                    } elsif ($judge == 1) {
                        $att2++;
                        if ($att2 < $s2) {
                            $w2 = $datum2->[$att2]->[1];
                        $c2 += $w2;
                        }
                    } else {
                        $match_num += $w1 * $w2;
                        $att1++;
                        $att2++;
                        if (($att1 < $s1) && ($att2 < $s2)) {
                            ($w1, $w2) = ($datum1->[$att1]->[1], $datum2->[$att2]->[1]);
                            $c1 += $w1;
                            $c2 += $w2;
                        }
                    }
                }
                my $min = ($cum_w2 - $c2);
                $min = ($cum_w1 - $c1) if ($min > ($cum_w1 - $c1));

                if (($match_num) + $min < $min_overlap) {
                    $match_num = 0;
                    last;
                }

                last unless ($match_num >= 1);

                while (($att1 < $s1) && ($att2 < $s2)) {
                    my $judge = -1;
                    if ($self->{data_type} eq "number") {
                        $judge = ($datum1->[$att1]->[0] <=> $datum2->[$att2]->[0]);
                    } else {
                        $judge = ($datum1->[$att1]->[0] cmp $datum2->[$att2]->[0]);
                    }

                    if ($judge == -1) {
                        last if ($match_num + ($cum_w1 - $c1) < $min_overlap);
                        $att1++;
                        if ($att1 < $s1) {
                            $w1 = $datum1->[$att1]->[1];
                            $c1 += $w1;
                        }
                    } elsif ($judge == 1) {
                        last if ($match_num + ($cum_w2 - $c2) < $min_overlap);
                        $att2++;
                        if ($att2 < $s2) {
                            $w2 = $datum2->[$att2]->[1];
                            $c2 += $w2;
                        }
                    } else {
                        $match_num += $w1 * $w2;
                        $att1++;
                        $att2++;
                        if (($att1 < $s1) && ($att2 < $s2)) {
                            ($w1, $w2) = ($datum1->[$att1]->[1], $datum2->[$att2]->[1]);
                            $c1 += $w1;
                            $c2 += $w2;
                        }
                    }
                }
                last unless ($match_num >= $min_overlap + 1);

                $score = $match_num / ($s_norm1 + $s_norm2 - $match_num );
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
