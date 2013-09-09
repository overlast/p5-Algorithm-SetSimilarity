package Algorithm::SetSimilarity::Jaccard;

use 5.008005;
use strict;
use warnings;

our $VERSION = "0.01";

sub new {
    my ($class, $param) = @_;
    my %hash = ();
    bless \%hash, $class;
}

sub get_similarity {
    my ($self, $set1, $set2) = @_;
    my $score = -1.0;
    if ((@$set1) && (@$set2)) {
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
