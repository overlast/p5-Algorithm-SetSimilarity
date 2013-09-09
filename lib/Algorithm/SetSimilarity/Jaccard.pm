package Algorithm::SetSimilarity::Jaccard;

use 5.008005;
use strict;
use warnings;

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
        unless ($self->{is_sorted} ) {
            @{$set1} = sort {$a cmp $b} @$set1;
            @{$set2} = sort {$a cmp $b} @$set2;
        }
        my $min_att = $#$set1;
        $min_att = $#$set2 if ($min_att > $#$set2);
        my ($att1, $att2) = (0, 0);
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
        my $diff_num = abs(($#$set1 + 1) - ($#$set2 + 1));
        $score = $match_num / ($match_num + $diff_num);
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
