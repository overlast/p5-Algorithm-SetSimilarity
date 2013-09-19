use strict;

use Test::More;

use Algorithm::SetSimilarity::Jaccard;

subtest "Test of initializing" => sub {
    my $jacc =  Algorithm::SetSimilarity::Jaccard->new();
    subtest "with the default parameters" => sub {
        is ("Algorithm::SetSimilarity::Jaccard", ref $jacc, "Get Algorithm::SetSimilarity::Jaccard object");
    };
};

subtest "Test of get_similarity() with the null sets" => sub {
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

subtest "Test of get_similarity() using the string elements" => sub {
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
    {
        my @set1 = ("Orange", "Strowberry", "Pear", "Grape");
        my @set2 = ("Orange", "Strowberry", "Pear", "Peach");
        for (my $i = 0.1; $i <= 0.6; $i += 0.1) {
            my $score = $jacc->get_similarity(\@set1, \@set2, $i);
            is ($score, 0.6, "Make check of get_similarity() using $i as a threshold with unsorted four elements");
        }
        for (my $i = 0.7; $i <= 1.0; $i += 0.1) {
            my $score = $jacc->get_similarity(\@set1, \@set2, $i);
            is ($score, -1.0, "Make check of get_similarity() using $i as a threshold with unsorted four elements");
        }
    }
};

subtest "Test of get_similarity() using the number elements" => sub {
    my $jacc =  Algorithm::SetSimilarity::Jaccard->new({"data_type" => "number"});
    {
        my @set1 = (1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
        my @set2 = (1, 2, 3, 4, 5, 11, 12, 13, 14, 15);
        my $score = $jacc->get_similarity(\@set1, \@set2);
        is ($score, 0.333333333333333, "Make check of get_similarity() which return the 0.33 as a value of score")
    }
    {
        my @set1 = (6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
        my @set2 = (1, 2, 3, 4, 5, 11, 12, 13, 14, 15);
        my $score = $jacc->get_similarity(\@set1, \@set2);
        is ($score, 0.333333333333333, "Make check of get_similarity() which return the 0.33 as a value of score")
    }
};

subtest "Test of _swap_set_ascending_order()" => sub {
    my $jacc =  Algorithm::SetSimilarity::Jaccard->new();
    {
        my $set1 = ["there", "is", "a", "element"];
        my $set2 = ["there"];
        my $ans = ["there", "is", "a", "element"];
        ($set1, $set2) = $jacc->_swap_set_ascending_order($set1, $set2);
        is_deeply ($set2, $ans, "Make check of _swap_set_ascending_order()")
    }
    {
        my $set1 = ["there"];
        my $set2 = ["there", "is", "a", "element"];
        my $ans = ["there", "is", "a", "element"];
        ($set1, $set2) = $jacc->_swap_set_ascending_order($set1, $set2);
        is_deeply ($set2, $ans, "Make check of _swap_set_ascending_order()")
    }
};

subtest "Test of _swap_set_descending_order()" => sub {
    my $jacc =  Algorithm::SetSimilarity::Jaccard->new();
    {
        my $set1 = ["there", "is", "a", "element"];
        my $set2 = ["there"];
        my $ans = ["there"];
        ($set1, $set2) = $jacc->_swap_set_descending_order($set1, $set2);
        is_deeply ($set2, $ans, "Make check of _swap_set_descending_order()")
    }
    {
        my $set1 = ["there"];
        my $set2 = ["there", "is", "a", "element"];
        my $ans = ["there"];
        ($set1, $set2) = $jacc->_swap_set_descending_order($set1, $set2);
        is_deeply ($set2, $ans, "Make check of _swap_set_descending_order()")
    }
};

subtest "Test of filt_by_threshold() using the string elements" => sub {
    my $jacc =  Algorithm::SetSimilarity::Jaccard->new();
        {
        my @set1 = ("there");
        my @set2 = ("there");
        my $i = 0.0;
        my $score = $jacc->filt_by_threshold(\@set1, \@set2, $i);
        is ($score, -1.0, "Make check of filt_by_threshold() using $i as a threshold with one element");
    }
    {
        my @set1 = ("there");
        my @set2 = ("there");
        for (my $i = 0.1; $i <= 1.0; $i += 0.1) {
            my $score = $jacc->filt_by_threshold(\@set1, \@set2, $i);
            is ($score, 1.0, "Make check of filt_by_threshold() using $i as a threshold with one element");
        }
    }
    {
        my @set1 = ("there", "is");
        my @set2 = ("there", "is");
        for (my $i = 0.1; $i <= 1.0; $i += 0.1) {
            my $score = $jacc->filt_by_threshold(\@set1, \@set2, $i);
            is ($score, 1.0, "Make check of filt_by_threshold() using $i as a threshold with sorted two elements");
        }
    }
    {
        my @set1 = ("there", "is");
        my @set2 = ("is", "there");
        for (my $i = 0.1; $i <= 1.0; $i += 0.1) {
            my $score = $jacc->filt_by_threshold(\@set1, \@set2, $i);
            is ($score, 1.0, "Make check of filt_by_threshold() using $i as a threshold with sorted two elements");
        }
    }
    {
        my @set1 = ("Orange", "Strowberry", "Pear", "Grape");
        my @set2 = ("Orange", "Strowberry", "Pear", "Peach");
        for (my $i = 0.1; $i <= 0.6; $i += 0.1) {
            my $score = $jacc->filt_by_threshold(\@set1, \@set2, $i);
            is ($score, 0.6, "Make check of filt_by_threshold() using $i as a threshold with unsorted four elements");
        }
        for (my $i = 0.7; $i <= 1.0; $i += 0.1) {
            my $score = $jacc->filt_by_threshold(\@set1, \@set2, $i);
            is ($score, -1.0, "Make check of filt_by_threshold() using $i as a threshold with unsorted four elements");
        }
    }
};

subtest "Test of filt_by_threshold() using the number elements" => sub {
    my $jacc =  Algorithm::SetSimilarity::Jaccard->new({"data_type" => "number"});
    {
        my @set1 = (1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
        my @set2 = (1, 2, 3, 4, 5, 11, 12, 13, 14, 15);
        my $threshold = 0.33;
        my $score = $jacc->filt_by_threshold(\@set1, \@set2, $threshold);
        is ($score, 0.333333333333333, "Make check of filt_by_threshold() which return the 0.33 as a value of score")
    }
{
        my @set1 = (1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
        my @set2 = (1, 2, 3, 4, 5, 11, 12, 13, 14, 15);
        my $threshold = 0.34;
        my $score = $jacc->filt_by_threshold(\@set1, \@set2, $threshold);
        is ($score, -1, "Make check of filt_by_threshold() which return the -1 as a message of filter")
    }
    {
        my @set1 = (6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
        my @set2 = (1, 2, 3, 4, 5, 11, 12, 13, 14, 15);
        my $threshold = 0.33;
        my $score = $jacc->filt_by_threshold(\@set1, \@set2, $threshold);
        is ($score, 0.333333333333333, "Make check of filt_by_threshold() which return the 0.33 as a value of score")
    }
    {
        my @set1 = (6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
        my @set2 = (1, 2, 3, 4, 5, 11, 12, 13, 14, 15);
        my $threshold = 0.34;
        my $score = $jacc->filt_by_threshold(\@set1, \@set2, $threshold);
        is ($score, -1, "Make check of filt_by_threshold() which return the -1 as a message of filter")
    }

};

done_testing;
