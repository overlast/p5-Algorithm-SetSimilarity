use strict;

use Test::More;

use Algorithm::SetSimilarity::WeightedJaccard;

subtest "Test of initializing" => sub {
    my $jacc =  Algorithm::SetSimilarity::WeightedJaccard->new();
    subtest "with the default parameters" => sub {
        is ("Algorithm::SetSimilarity::WeightedJaccard", ref $jacc, "Get Algorithm::SetSimilarity::WeightedJaccard object");
    };
};


subtest "Test of get_similarity() with the null sets" => sub {
    my $jacc =  Algorithm::SetSimilarity::WeightedJaccard->new();
    {
        my %set1 = ();
        my %set2 = ();
        my $score = $jacc->get_similarity(\%set1, \%set2);
        is ($score, -1.0, "Make check of get_similarity() with two null sets")
    }

    {
        my %set1 = ("there" => 1);
        my %set2 = ();
        my $score = $jacc->get_similarity(\%set1, \%set2);
        is ($score, -1.0, "Make check of get_similarity() with one null set")
    }

    {
        my %set1 = ();
        my %set2 = ("there" => 1);
        my $score = $jacc->get_similarity(\%set1, \%set2);
        is ($score, -1.0, "Make check of get_similarity() with one null set")
    }
};

subtest "Test of make_pair_from_hash()" => sub {
    my $jacc =  Algorithm::SetSimilarity::WeightedJaccard->new();
    {
        my %set = ("this" => 1, "is" => 1);
        my $res = [["is", 1], ["this", 1],];
        my $pair = $jacc->make_pair_from_hash(\%set);
        is_deeply ($pair, $res, "Make check of a process to make a pair from a hash");
    }
};

subtest "Test of estimate_data_type() with the null sets" => sub {
    my $jacc =  Algorithm::SetSimilarity::WeightedJaccard->new();
    {
        my %set1 = ("this" => 1, "is" => 1);
        my %set2 = ("that" => 1, "is" => 1);
        my $is_estimate = $jacc->estimate_data_type(\%set1, \%set2);
        is ($is_estimate, 1, "Make check of estimating the data type of two sets");
        is (($jacc->{data_type} eq "string"), 1, "Make check of matching the data type between two sets");
    }
    {
        my %set1 = (1 => 1, 2 => 1);
        my %set2 = (3 => 1, 4 => 1);
        my $is_estimate = $jacc->estimate_data_type(\%set1, \%set2);
        is ($is_estimate, 1, "Make check of estimating the data type of two sets");
        is (($jacc->{data_type} eq "number"), 1, "Make check of matching the data type between two sets");
    }
    {
        my %set1 = ("this" => 1, "is" => 1);
        my %set2 = (3 => 1, 4 => 1);
        my $is_estimate = $jacc->estimate_data_type(\%set1, \%set2);
        is ($is_estimate, 0, "Make check of estimating the data type of two sets");
    }
    {
        my %set1 = (2 => 1, 1 => 1);
        my %set2 = ("that" => 1, "is" => 1);
        my $is_estimate = $jacc->estimate_data_type(\%set1, \%set2);
        is ($is_estimate, 0, "Make check of estimating the data type of two sets");
    }
};

subtest "Test of _swap_set_ascending_order()" => sub {
    my $jacc =  Algorithm::SetSimilarity::WeightedJaccard->new();
    {
        my $set1 = {"there" => 1, "is" => 1, "a" => 1, "element" => 1};
        my $set2 = {"there" => 1};
        my $ans = {"there" => 1, "is" => 1, "a" => 1, "element" => 1};
        ($set1, $set2) = $jacc->_swap_set_ascending_order($set1, $set2);
        is_deeply ($set2, $ans, "Make check of _swap_set_ascending_order()")
    }
    {
        my $set1 = {"there" => 1};
        my $set2 = {"there" => 1, "is" => 1, "a" => 1, "element" => 1};
        my $ans = {"there" => 1, "is" => 1, "a" => 1, "element" => 1};
        ($set1, $set2) = $jacc->_swap_set_ascending_order($set1, $set2);
        is_deeply ($set2, $ans, "Make check of _swap_set_ascending_order()")
    }
};

subtest "Test of _swap_set_descending_order()" => sub {
    my $jacc =  Algorithm::SetSimilarity::WeightedJaccard->new();
    {
        my $set1 = {"there" => 1, "is" => 1, "a" => 1, "element" => 1};
        my $set2 = {"there" => 1};
        my $ans = {"there" => 1};
        ($set1, $set2) = $jacc->_swap_set_descending_order($set1, $set2);
        is_deeply ($set2, $ans, "Make check of _swap_set_descending_order()")
    }
    {
        my $set1 = {"there" => 1};
        my $set2 = {"there" => 1, "is" => 1, "a" => 1, "element" => 1};
        my $ans = {"there" => 1};
        ($set1, $set2) = $jacc->_swap_set_descending_order($set1, $set2);
        is_deeply ($set2, $ans, "Make check of _swap_set_descending_order()")
    }
};

subtest "Test of get_squared_norm()" => sub {
    my $jacc =  Algorithm::SetSimilarity::WeightedJaccard->new();
    {
        my %set = ("elem1" => 1);
        my $score = $jacc->get_squared_norm(\%set);
        is ($score, 1, "Make check of get_similarity() with one element");
    }
    {
        my %set = ("elem1" => 1, "elem2" => 2,);
        my $score = $jacc->get_squared_norm(\%set);
        is ($score, 5, "Make check of get_similarity() with one element");
    }
};

subtest "Test of get_similarity() using the string elements" => sub {
    my $jacc =  Algorithm::SetSimilarity::WeightedJaccard->new();
    {
        my %set1 = ("there" => 1);
        my %set2 = ("there" => 1);
        my $score = $jacc->get_similarity(\%set1, \%set2);
        is ($score, 1, "Make check of get_similarity() with one element")
    }
    {
        my %set1 = ("there" => 1, "is" => 1);
        my %set2 = ("there" => 1, "is" => 1);
        my $score = $jacc->get_similarity(\%set1, \%set2);
        is ($score, 1, "Make check of get_similarity() with sorted two elements")
    }
    {
        my %set1 = ("is" => 1, "there" => 1);
        my %set2 = ("there" => 1, "is" => 1);
        my $score = $jacc->get_similarity(\%set1, \%set2);
        is ($score, 1, "Make check of get_similarity() with unsorted two elements")
    }
    {
        my %set1 = ("Orange" => 1, "Strowberry" => 1, "Pear" => 1, "Grape" => 1);
        my %set2 = ("Orange" => 1, "Strowberry" => 1, "Pear" => 1, "Peach" => 1);
        my $score = $jacc->get_similarity(\%set1, \%set2);
        is ($score, 0.6, "Make check of get_similarity() with unsorted two elements")
    }
    {
        my %set1 = ("Orange" => 1, "Strowberry" => 1, "Pear" => 1, "Peach" => 1);
        my %set2 = ("Orange" => 1, "Strowberry" => 1, "Pear" => 1, "Grape" => 1);
        my $score = $jacc->get_similarity(\%set1, \%set2);
        is ($score, 0.6, "Make check of get_similarity() with unsorted two elements")
    }
    {
        my %set1 = ("Pear" => 1, "Peach" => 1, "Orange" => 1, "Strowberry" => 1);
        my %set2 = ("Orange" => 1, "Strowberry" => 1, "Pear" => 1, "Grape" => 1);
        my $score = $jacc->get_similarity(\%set1, \%set2);
        is ($score, 0.6, "Make check of get_similarity() with unsorted two elements")
    }
    {
        my %set1 = ("Orange" => 1, "Strowberry" => 1, "Apple" => 1, "Peach" => 1);
        my %set2 = ("Orange" => 1, "Strowberry" => 1, "Kiwifruit" => 1, "Grape" => 1);
        my $score = $jacc->get_similarity(\%set1, \%set2);
        is ($score, 0.333333333333333, "Make check of get_similarity() with unsorted two elements")
    }
    {
        my %set1 = ("Orange" => 2, "Strowberry" => 1, "Apple" => 1, "Peach" => 1);
        my %set2 = ("Orange" => 1, "Strowberry" => 2, "Kiwifruit" => 1, "Grape" => 1);
        my $score = $jacc->get_similarity(\%set1, \%set2);
        is ($score, 0.4, "Make check of get_similarity() with unsorted two elements")
    }
    {
        my %set1 = ("Orange" => 1, "Strowberry" => 1, "Pear" => 1, "Grape" => 1);
        my %set2 = ("Orange" => 1, "Strowberry" => 1, "Pear" => 1, "Peach" => 1);
        for (my $i = 0.1; $i <= 0.6; $i += 0.1) {
            my $score = $jacc->filt_by_threshold(\%set1, \%set2, $i);
            is ($score, 0.6, "Make check of get_similarity() using $i as a threshold with unsorted four elements");
        }
        for (my $i = 0.7; $i <= 1.0; $i += 0.1) {
            my $score = $jacc->filt_by_threshold(\%set1, \%set2, $i);
            is ($score, -1.0, "Make check of get_similarity() using $i as a threshold with unsorted four elements");
        }
    }
};

subtest "Test of get_similarity() using the number elements" => sub {
    my $jacc =  Algorithm::SetSimilarity::WeightedJaccard->new({"data_type" => "number"});
    {
        my %set1 = (1 => 1, 2 => 1, 3 => 1, 4 => 1, 5 => 1, 6 => 1, 7 => 1, 8 => 1, 9 => 1, 10 => 1,);
        my %set2 = (1 => 1, 2 => 1, 3 => 1, 4 => 1, 5 => 1, 11 => 1, 12 => 1, 13 => 1, 14 => 1, 15 => 1,);
        my $score = $jacc->get_similarity(\%set1, \%set2);
        is ($score, 0.333333333333333, "Make check of get_similarity() which return the 0.33 as a value of score")
    }
    {

        my %set1 = (6 => 1, 7 => 1, 8 => 1, 9 => 1, 10 => 1, 11 => 1, 12 => 1, 13 => 1, 14 => 1, 15 => 1,);
        my %set2 = (1 => 1, 2 => 1, 3 => 1, 4 => 1, 5 => 1, 11 => 1, 12 => 1, 13 => 1, 14 => 1, 15 => 1,);
        my $score = $jacc->get_similarity(\%set1, \%set2);
        is ($score, 0.333333333333333, "Make check of get_similarity() which return the 0.33 as a value of score")
    }
};

subtest "Test of filt_by_threshold() using the string elements" => sub {
    my $jacc =  Algorithm::SetSimilarity::WeightedJaccard->new();
        {
        my %set1 = ("there" => 1);
        my %set2 = ("there" => 1);
        my $i = 0.0;
        my $score = $jacc->filt_by_threshold(\%set1, \%set2, $i);
        is ($score, -1.0, "Make check of filt_by_threshold() using $i as a threshold with one element");
    }
    {
        my %set1 = ("there" => 1);
        my %set2 = ("there" => 1);
        for (my $i = 0.1; $i <= 1.0; $i += 0.1) {
            my $score = $jacc->filt_by_threshold(\%set1, \%set2, $i);
            is ($score, 1.0, "Make check of filt_by_threshold() using $i as a threshold with one element");
        }
    }
    {
        my %set1 = ("there" => 1, "is" => 1);
        my %set2 = ("there" => 1, "is" => 1);
        for (my $i = 0.1; $i <= 1.0; $i += 0.1) {
            my $score = $jacc->filt_by_threshold(\%set1, \%set2, $i);
            is ($score, 1.0, "Make check of filt_by_threshold() using $i as a threshold with sorted two elements");
        }
    }
    {
        my %set1 = ("there" => 1, "is" => 1);
        my %set2 = ("is" => 1, "there" => 1);
        for (my $i = 0.1; $i <= 1.0; $i += 0.1) {
            my $score = $jacc->filt_by_threshold(\%set1, \%set2, $i);
            is ($score, 1.0, "Make check of filt_by_threshold() using $i as a threshold with sorted two elements");
        }
    }
    {
        my %set1 = ("Orange" => 1, "Strowberry" => 1, "Pear" => 1, "Grape" => 1);
        my %set2 = ("Orange" => 1, "Strowberry" => 1, "Pear" => 1, "Peach" => 1);
        for (my $i = 0.1; $i <= 0.6; $i += 0.1) {
            my $score = $jacc->filt_by_threshold(\%set1, \%set2, $i);
            is ($score, 0.6, "Make check of filt_by_threshold() using $i as a threshold with unsorted four elements");
        }
        for (my $i = 0.7; $i <= 1.0; $i += 0.1) {
            my $score = $jacc->filt_by_threshold(\%set1, \%set2, $i);
            is ($score, -1.0, "Make check of filt_by_threshold() using $i as a threshold with unsorted four elements");
        }
    }
    {
        my %set1 = ("Orange" => 2, "Strowberry" => 1, "Apple" => 1, "Peach" => 1);
        my %set2 = ("Orange" => 1, "Strowberry" => 2, "Kiwifruit" => 1, "Grape" => 1);
        for (my $i = 0.1; $i <= 0.4; $i += 0.1) {
            my $score = $jacc->filt_by_threshold(\%set1, \%set2, $i);
            is ($score, 0.4, "Make check of filt_by_threshold() using $i as a threshold with unsorted four elements")
        }
        for (my $i = 0.5; $i <= 1.0; $i += 0.1) {
            my $score = $jacc->filt_by_threshold(\%set1, \%set2, $i);
            is ($score, -1.0, "Make check of filt_by_threshold() using $i as a threshold with unsorted four elements")
        }
    }
};

subtest "Test of filt_by_threshold() using the number elements" => sub {
    my $jacc =  Algorithm::SetSimilarity::WeightedJaccard->new({"data_type" => "number"});
    {
        my %set1 = (1 => 1, 2 => 1, 3 => 1, 4 => 1, 5 => 1, 6 => 1, 7 => 1, 8 => 1, 9 => 1, 10 => 1);
        my %set2 = (1 => 1, 2 => 1, 3 => 1, 4 => 1, 5 => 1, 11 => 1, 12 => 1, 13 => 1, 14 => 1, 15 => 1);
        my $threshold = 0.33;
        my $score = $jacc->filt_by_threshold(\%set1, \%set2, $threshold);
        is ($score, 0.333333333333333, "Make check of filt_by_threshold() which return the 0.33 as a value of score")
    }
    {
        my %set1 = (1 => 1, 2 => 1, 3 => 1, 4 => 1, 5 => 1, 6 => 1, 7 => 1, 8 => 1, 9 => 1, 10 => 1);
        my %set2 = (1 => 1, 2 => 1, 3 => 1, 4 => 1, 5 => 1, 11 => 1, 12 => 1, 13 => 1, 14 => 1, 15 => 1);
        my $threshold = 0.34;
        my $score = $jacc->filt_by_threshold(\%set1, \%set2, $threshold);
        is ($score, -1, "Make check of filt_by_threshold() which return the -1 as a message of filter")
    }
    {
        my %set1 = (6 => 1, 7 => 1, 8 => 1, 9 => 1, 10 => 1, 11 => 1, 12 => 1, 13 => 1, 14 => 1, 15 => 1);
        my %set2 = (1 => 1, 2 => 1, 3 => 1, 4 => 1, 5 => 1, 11 => 1, 12 => 1, 13 => 1, 14 => 1, 15 => 1);
        my $threshold = 0.33;
        my $score = $jacc->filt_by_threshold(\%set1, \%set2, $threshold);
        is ($score, 0.333333333333333, "Make check of filt_by_threshold() which return the 0.33 as a value of score")
    }
    {
        my %set1 = (6 => 1, 7 => 1, 8 => 1, 9 => 1, 10 => 1, 11 => 1, 12 => 1, 13 => 1, 14 => 1, 15 => 1);
        my %set2 = (1 => 1, 2 => 1, 3 => 1, 4 => 1, 5 => 1, 11 => 1, 12 => 1, 13 => 1, 14 => 1, 15 => 1);
        my $threshold = 0.34;
        my $score = $jacc->filt_by_threshold(\%set1, \%set2, $threshold);
        is ($score, -1, "Make check of filt_by_threshold() which return the -1 as a message of filter")
    }
};

done_testing;
