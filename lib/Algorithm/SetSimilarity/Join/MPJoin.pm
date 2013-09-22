package Algorithm::SetSimilarity::Join::MPJoin;

use 5.008005;
use strict;
use warnings;

our $VERSION = "0.0.0_02";

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

# only Jaccard coefficient yet.
sub join {
    my ($self, $datum, $threshold) = @_;
    my @result = ();
    if ($self->check_joinable($datum)) {
        $datum->sort() unless ((exists $self->{"is_sorted"}) && ($self->{"is_sorted"}));
        my $set_num = $datum->get_num();
        for (my $p = 0; $p < $set_num; $p++) {
            my $p_set = $datum->get($p);
            my $s1 = $#$p_set + 1;

            # $datum is sorted. Therefore $max_att is needless.
            #my $maxpref = int ($s1 / $threshold);
            for (my $c = $p + 1; $c < $set_num; $c++) {
                my $c_set = $datum->get($c);
                my $s2 = $#$c_set + 1;
                next if (($s1 * $threshold) > $s2); # minsize filtering

                # $datum is sorted. Therefore $max_att is needless.
                # my $max_att = $maxpref; # adopt maxpref size
                # $max_att = $s2 if ($s2 < $max_att);

                my $min_overlap = int(($threshold / (1 + $threshold)) * ($s1 + $s2));
                my $alpha = $s2 - ($min_overlap + 1) + 1;
                my $match_num = 0;
                my ($att1, $att2) = (0, 0);

                while (($att2 < $alpha) && ($att1 < $s1)) {
                    my $judge = -1;
                    if ($datum->{data_type} eq "number") {
                        $judge = ($p_set->[$att1] <=> $c_set->[$att2]);
                    }
                    else {
                        $judge = ($p_set->[$att1] cmp $c_set->[$att2]);
                    }

                    if ($judge == -1) {
                        $att1++;
                    } elsif ($judge == 1) {
                        $att2++;
                    }  else {
                        $match_num++;
                        $att1++;
                        $att2++;
                    }

                    my $min = ($s2 - $att2);
                    $min = ($s1 - $att1) if ($min > ($s1 - $att1));
                    if (($match_num) + $min < $min_overlap) {
                        $match_num = 0;
                        last;
                    }
                }
                next unless ($match_num >= 1);
                while (($att1 < $s1) && ($att2 < $s2)) {
                    my $judge = -1;
                    if ($datum->{data_type} eq "number") {
                        $judge = ($p_set->[$att1] <=> $c_set->[$att2]);
                    }
                    else {
                        $judge = ($p_set->[$att1] cmp $c_set->[$att2]);
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
                my $score = $match_num / ($match_num + $diff_num);
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

Algorithm::SetSimilarity::Join::MPJoin - It's new $module

=head1 SYNOPSIS

    use Algorithm::SetSimilarity::Join::MPJoin;

=head1 DESCRIPTION

Algorithm::SetSimilarity::Join::MPJoin is ...

=head1 LICENSE

Copyright (C) Toshinori Sato (@overlast).

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Toshinori Sato (@overlast) E<lt>overlasting@gmail.comE<gt>

=cut
