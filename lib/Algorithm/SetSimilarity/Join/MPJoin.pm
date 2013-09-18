package Algorithm::SetSimilarity::Join::MPJoin;

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

sub check_joinable {
    my ($self, $sets) = @_;
    my $is_joinable = 0;
    $is_joinable = 1 if (ref $sets eq "Algorithm::SetSimilarity::Join::Datum");
    return $is_joinable;
}

sub join {
    my ($self, $sets, $threshold) = @_;
    my @result = ();
    if ($self->check_joinable($sets)) {
        $sets->sort() unless ((exists $self->{"is_sorted"}) && ($self->{"is_sorted"}));
        for (my $p = 0; $p <= $#$sets; $p++) {
            my $s1 = $#{$sets->[$p]} + 1;
            my $maxpref = int ($s1 / $threshold);
            for (my $c = $p + 1; $c <= $#$sets; $c++) {
                my $s2 = $#{$sets->[$c]} + 1;
                next if (($s1 * $threshold) > $s2); # minsize filtering
                my $max_att = $maxpref; # adopt maxpref size
                $max_att = $s2 if ($s2 < $max_att);
                my $min_overlap = ($threshold / (1 + $threshold)) * ($s1 + $s2);
                my $alpha = int($s1 - $min_overlap) + 1;

                my $match_num = 0;
                my ($att1, $att2) = (0, 0);
                while (($att1 < $alpha) && ($att2 < $alpha)) {
                    if (($sets->[$p] cmp $sets->[$c]) == -1) {
                        $att1++;
                    } elsif (($sets->[$p] cmp $sets->[$c]) == 1) {
                        $att2++;
                    } else {
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
                    if ($match_num + ($s2 - $att2) < $min_overlap) {
                        last;
                    }
                }
                last unless ($match_num >= 1);
                my @pair = ($p, $c);
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
