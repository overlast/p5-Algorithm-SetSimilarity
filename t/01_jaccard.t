use strict;

use Test::More;

use Algorithm::SetSimilarity::Jaccard;

subtest "Test to initialize" => sub {
    my $jacc =  Algorithm::SetSimilarity::Jaccard->new();
    subtest "with the default parameters" => sub {
        is ("Algorithm::SetSimilarity::Jaccard", ref $jacc, "Get Algorithm::SetSimilarity::Jaccard object");
    };
};

subtest "Test to get_similarity() with the null sets" => sub {
    my $jacc =  Algorithm::SetSimilarity::Jaccard->new();
    {
        my @set1 = ();
        my @set2 = ();
        my $score = $jacc->get_similarity(\@set1, \@set2);
        is ($score, -1.0, "Make check of get_similarity() with two null sets")
    }

    {
        my @set1 = ("there");
        my @set2 = ();
        my $score = $jacc->get_similarity(\@set1, \@set2);
        is ($score, -1.0, "Make check of get_similarity() with two null sets")
    }

    {
        my @set1 = ();
        my @set2 = ("there");
        my $score = $jacc->get_similarity(\@set1, \@set2);
        is ($score, -1.0, "Make check of get_similarity() with two null sets")
    }
};

done_testing;
