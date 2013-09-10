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
        is ($score, -1.0, "Make check of get_similarity() with one null set")
    }

    {
        my @set1 = ();
        my @set2 = ("there");
        my $score = $jacc->get_similarity(\@set1, \@set2);
        is ($score, -1.0, "Make check of get_similarity() with one null set")
    }
};

subtest "Test to get_similarity()" => sub {
    my $jacc =  Algorithm::SetSimilarity::Jaccard->new();
    {
        my @set1 = ("there");
        my @set2 = ("there");
        my $score = $jacc->get_similarity(\@set1, \@set2);
        is ($score, 1, "Make check of get_similarity() with one element")
    }
    {
        my @set1 = ("there", "is");
        my @set2 = ("there", "is");
        my $score = $jacc->get_similarity(\@set1, \@set2);
        is ($score, 1, "Make check of get_similarity() with sorted two elements")
    }
    {
        my @set1 = ("is", "there");
        my @set2 = ("there", "is");
        my $score = $jacc->get_similarity(\@set1, \@set2);
        is ($score, 1, "Make check of get_similarity() with unsorted two elements")
    }
    {
        my @set1 = ("Orange", "Strowberry", "Pear", "Grape");
        my @set2 = ("Orange", "Strowberry", "Pear", "Peach");
        my $score = $jacc->get_similarity(\@set1, \@set2);
        is ($score, 0.6, "Make check of get_similarity() with unsorted two elements")
    }
    {
        my @set1 = ("Orange", "Strowberry", "Pear", "Peach");
        my @set2 = ("Orange", "Strowberry", "Pear", "Grape");
        my $score = $jacc->get_similarity(\@set1, \@set2);
        is ($score, 0.6, "Make check of get_similarity() with unsorted two elements")
    }
    {
        my @set1 = ("Pear", "Peach", "Orange", "Strowberry");
        my @set2 = ("Orange", "Strowberry", "Pear", "Grape");
        my $score = $jacc->get_similarity(\@set1, \@set2);
        is ($score, 0.6, "Make check of get_similarity() with unsorted two elements")
    }
};

done_testing;
