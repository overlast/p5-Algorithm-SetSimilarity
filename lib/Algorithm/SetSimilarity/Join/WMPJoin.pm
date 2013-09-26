package Algorithm::SetSimilarity::Join::WMPJoin;

use 5.008005;
use strict;
use warnings;

our $VERSION = "0.0.0_03";

sub new {
    my ($class, $param) = @_;
    my %hash = ();
    $hash{"is_sorted"} = $param->{is_sorted} if (exists $param->{is_sorted});
    bless \%hash, $class;
}

sub check_joinable {
    my ($self, $datum) = @_;
    my $is_joinable = 0;
    $is_joinable = 1 if (ref $datum eq "Algorithm::SetSimilarity::Join::Datum");
    return $is_joinable;
}

sub get_cumulative_weight {
    my ($self, $set) = @_;
    my $cum_weight = 0;
    for (my $i = 0; $i <= $#$set; $i++) {
        $cum_weight += $set->[$i]->[1];
    }
    return $cum_weight;
}

sub get_squared_norm {
    my ($self, $set) = @_;
    my $squared_norm = 0;
    for (my $i = 0; $i <= $#$set; $i++) {
        $squared_norm += $set->[$i]->[1] * $set->[$i]->[1];
    }
    return $squared_norm;
}

# only Jaccard coefficient yet.
sub join {
    my ($self, $datum, $threshold) = @_;
    my @result = ();
    if ($self->check_joinable($datum)) {
        $datum->sort() unless ((exists $self->{"is_sorted"}) && ($self->{"is_sorted"}));
        my $set_num = $datum->get_num();
        my @cum_weight = ();
        my @squared_norm = ();

        for (my $p = 0; $p < $set_num; $p++) {
            my $p_set = $datum->get($p);
            my $s1 = $#$p_set + 1;
            $cum_weight[$p] = $self->get_cumulative_weight($p_set) unless ($cum_weight[$p]);
            $squared_norm[$p] = $self->get_squared_norm($p_set) unless ($squared_norm[$p]);

            # $datum is sorted. Therefore $max_att is needless.
            #my $maxpref = int ($s1 / $threshold);
            for (my $c = $p + 1; $c < $set_num; $c++) {
                my $c_set = $datum->get($c);
                my $s2 = $#$c_set + 1;
                $cum_weight[$c] = $self->get_cumulative_weight($c_set) unless ($cum_weight[$c]);
                $squared_norm[$c] = $self->get_squared_norm($c_set) unless ($squared_norm[$c]);

                next if (($s1 * $threshold) > $cum_weight[$c]); # minsize filtering

                # $datum is sorted. Therefore $max_att is needless.
                # my $max_att = $maxpref; # adopt maxpref size
                # $max_att = $s2 if ($s2 < $max_att);

                my $min_overlap = int(($threshold / (1 + $threshold)) * ($cum_weight[$p] + $cum_weight[$c]));
                my $alpha = $cum_weight[$c] - ($min_overlap + 1) + 1;
                my $match_num = 0;
                my ($att1, $att2) = (0, 0);
                my ($w1, $w2) = ($p_set->[$att1]->[1], $c_set->[$att2]->[1]);
                my ($c1, $c2) = ($w1, $w2);

                while (($att2 < $alpha) && ($att1 < $s1)) {
                    my $judge = -1;
                    if ($datum->{data_type} eq "number") {
                        $judge = ($p_set->[$att1]->[0] <=> $c_set->[$att2]->[0]);
                    }
                    else {
                        $judge = ($p_set->[$att1]->[0] cmp $c_set->[$att2]->[0]);
                    }
                    if ($judge == -1) {
                        $att1++;
                        if ($att1 < $s1) {
                            $w1 = $p_set->[$att1]->[1];
                            $c1 += $w1;
                        }
                    } elsif ($judge == 1) {
                        $att2++;
                        if ($att2 < $s2) {
                            $w2 = $c_set->[$att2]->[1];
                            $c2 += $w2;
                        }
                    } else {
                        $match_num += $w1 * $w2;
                        $att1++;
                        $att2++;
                        if (($att1 < $s1) && ($att2 < $s2)) {
                            ($w1, $w2) = ($p_set->[$att1]->[1], $c_set->[$att2]->[1]);
                            $c1 += $w1;
                            $c2 += $w2;
                        }
                    }

                    my $min = ($cum_weight[$c] - $c2);
                    $min = ($cum_weight[$p] - $c1) if ($min > ($cum_weight[$p] - $c1));
                    if (($match_num) + $min < $min_overlap) {
                        $match_num = 0;
                        last;
                    }
                }
                next unless ($match_num >= 1);

                while (($att1 < $s1) && ($att2 < $s2)) {
                    my $judge = -1;
                    if ($datum->{data_type} eq "number") {
                        $judge = ($p_set->[$att1]->[0] <=> $c_set->[$att2]->[0]);
                    }
                    else {
                        $judge = ($p_set->[$att1]->[0] cmp $c_set->[$att2]->[0]);
                    }

                    if ($judge == -1) {
                        last if ($match_num + ($cum_weight[$p] - $c1) < $min_overlap);
                        $att1++;
                        if ($att1 < $s1) {
                            $w1 = $p_set->[$att1]->[1];
                            $c1 += $w1;
                        }
                    } elsif ($judge == 1) {
                        last if ($match_num + ($cum_weight[$c] - $c2) < $min_overlap);
                        $att2++;
                        if ($att2 < $s2) {
                            $w2 = $c_set->[$att2]->[1];
                            $c2 += $w2;
                        }
                    } else {
                        $match_num += $w1 * $w2;
                        $att1++;
                        $att2++;
                        if (($att1 < $s1) && ($att2 < $s2)) {
                            ($w1, $w2) = ($p_set->[$att1]->[1], $c_set->[$att2]->[1]);
                            $c1 += $w1;
                            $c2 += $w2;
                        }
                    }
                }
                last unless ($match_num >= $min_overlap + 1);
                my $score = $match_num / ($squared_norm[$p] + $squared_norm[$c] - $match_num );
                my @pair = ($p, $c, $score);
                push @result, \@pair;
            }
        }
    }
    return \@result;
}

1;

__END__

=encoding utf-8

=head1 NAME

Algorithm::SetSimilarity::Join::WMPJoin - It's new $module

=head1 SYNOPSIS

    use Algorithm::SetSimilarity::Join::WMPJoin;

=head1 DESCRIPTION

Algorithm::SetSimilarity::Join::WMPJoin is ...

=head1 LICENSE

Copyright (C) Toshinori Sato (@overlast).

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Toshinori Sato (@overlast) E<lt>overlasting@gmail.comE<gt>

=cut
