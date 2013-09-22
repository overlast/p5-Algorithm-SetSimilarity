use strict;

use Test::More;

use Algorithm::SetSimilarity::Join::Datum;

subtest "Test of initializing" => sub {
    my $datum = Algorithm::SetSimilarity::Join::Datum->new();
    subtest "with the default parameters" => sub {
        is (ref $datum, "Algorithm::SetSimilarity::Join::Datum", "Get Algorithm::SetSimilarity::Join::Datum object");
    };
};

subtest "Test of check_pushability()" => sub {
    my $datum =  Algorithm::SetSimilarity::Join::Datum->new();
    subtest "with a valid set" => sub {
        my @set = ("This", "is", "a", "set");
        my $is_pushable = $datum->check_pushability(\@set);
        is($is_pushable, 1, "this is a pushable set");
    };
    subtest "with a invalid set whih have no data" => sub {
        my @set = ();
        my $is_pushable = $datum->check_pushability(\@set);
        is($is_pushable, 0, "this is a unpushable set");
    };
    subtest "with a invalid set witch have a reference to a one set" => sub {
        my @set = (["This", "is", "a", "set"]);
        my $is_pushable = $datum->check_pushability(\@set);
        is($is_pushable, 0, "this is a unpushable set");
    };
};

subtest "Test of estimate_data_type() with the null sets" => sub {
    my $datum =  Algorithm::SetSimilarity::Join::Datum->new();
    {
        my @set = ("this", "is");
        my $is_estimate = $datum->estimate_data_type(\@set);
        is ($is_estimate, 1, "Make check of estimating the data type of a set");
        is (($datum->{data_type} eq "string"), 1, "Make check of matching the data type of the elements in a set");
    }
    {
        my @set = (1, 2);
        my $is_estimate = $datum->estimate_data_type(\@set);
        is ($is_estimate, 1, "Make check of estimating the data type of two sets");
        is (($datum->{data_type} eq "number"), 1, "Make check of matching the data type of the elements in a set");
    }
    {
        my @set = ("this", 1);
        my $is_estimate = $datum->estimate_data_type(\@set);
        is ($is_estimate, 0, "Make check of failing to estimate the data type of a set");
    }
    {
        my @set = ("this","is", 1);
        my $is_estimate = $datum->estimate_data_type(\@set);
        is ($is_estimate, 0, "Make check of failing to estimate the data type of a set");
    }
    {
        my @set = ("this","is", "a", 1);
        my $is_estimate = $datum->estimate_data_type(\@set);
        is ($is_estimate, 0, "Make check of failing to estimate the data type of a set");
    }
    {
        my @set = ("this","is", "a", "test", 1);
        my $is_estimate = $datum->estimate_data_type(\@set);
        is ($is_estimate, 0, "Make check of failing to estimate the data type of a set");
    }
};

subtest "Test of push()" => sub {
    my $datum =  Algorithm::SetSimilarity::Join::Datum->new();
    subtest "with one set" => sub {
        my @set = ("This", "is", "a", "set");
        my $is_pushed = $datum->push(\@set);
        is($is_pushed, 1, "push one set");
    };
    subtest "with a null set" => sub {
        my @set = ();
        my $is_pushed = $datum->push(\@set);
        is($is_pushed, 0, "push a null set");
    };
    subtest "with a reference to one set" => sub {
        my @set = (["This", "is", "a", "set"]);
        my $is_pushed = $datum->push(\@set);
        is($is_pushed, 0, "push a reference to one set");
    };
};

subtest "Test of get_num()" => sub {
    my $datum =  Algorithm::SetSimilarity::Join::Datum->new();
    subtest "with a just initialized object" => sub {
        is($datum->get_num(), 0, "heve not pushed yet");
    };
    subtest "with a object which have one set" => sub {
        my @set = ("This", "is", "a", "set");
        my $is_pushed = $datum->push(\@set);
        is($datum->get_num(), 1, "heve one set");
    };
    subtest "with a object which have two sets" => sub {
        my @set = ("This", "is", "a", "set");
        my $is_pushed = $datum->push(\@set);
        is($datum->get_num(), 2, "heve two sets");
    }
};

subtest "Test of push_multi()" => sub {
    my $datum =  Algorithm::SetSimilarity::Join::Datum->new();
    subtest "with two sets" => sub {
        my @set = (
            ["This", "is", "a", "set1"],
            ["This", "is", "a", "set2"],
        );
        my $is_pushed = $datum->push_multi(\@set);
        is($is_pushed, 2, "push one set");
    };
        subtest "with two sets" => sub {
        my @set = (
            ["This", "is", "a", "set1"],
            ["This", "is", "a", "set2"],
            ["This", "is", "a", "set3"],
            ["This", "is", "a", "set4"],
            ["This", "is", "a", "set5"],
            ["This", "is", "a", "set6"],
            ["This", "is", "a", "set7"],
            ["This", "is", "a", "set8"],
            ["This", "is", "a", "set9"],
            ["This", "is", "a", "set10"],
        );
        my $is_pushed = $datum->push_multi(\@set);
        is($is_pushed, 10, "push one set");
    };
};

subtest "Test of get()" => sub {
    my $datum =  Algorithm::SetSimilarity::Join::Datum->new();
    subtest "with one set" => sub {
        my @set = ("This", "is", "a", "set");
        my $is_pushed = $datum->push(\@set);
        my $get_result = $datum->get(0);
        my @res = ("This", "a", "is", "set");
        is_deeply($get_result, \@res, "get the pushed set and compare with original set");
    };
};

subtest "Test of update()" => sub {
    my $datum =  Algorithm::SetSimilarity::Join::Datum->new();
    my $id = 0;

    subtest "with a initial set" => sub {
        my @set1 = ("This", "is", "a", "set1");
        my $is_pushed = $datum->push(\@set1);
        my $get_result1 = $datum->get($id);
        my @res1 = ("This", "a", "is", "set1");
        is_deeply($get_result1, \@res1, "get the pushed set and compare with original set1");
    };

    subtest "with a unpushable set" => sub {
        my @set_null = ();
        my $is_updated = $datum->update($id, \@set_null);
        is($is_updated, 0, "cannot update using a null set");
    };

    subtest "with two different set" => sub {

        my @set2 = ("This", "is", "a", "set2");
        my $is_updated = $datum->update($id, \@set2);
        is($is_updated, 1, "update a row using new set");
        my @res2 = ("This", "a", "is", "set2");
        my $get_result2 = $datum->get($id);
        is_deeply($get_result2, \@res2, "update the pushed set and compare with original set2");
    };
};

subtest "Test of update_multi()" => sub {
    my $datum =  Algorithm::SetSimilarity::Join::Datum->new();
    subtest "with two different sets" => sub {
        my @sets1 = (
            ["This", "is", "a", "set1"],
            ["This", "is", "a", "set2"],
            ["This", "is", "a", "set3"],
        );
        my $is_pushed = $datum->push_multi(\@sets1);
        is($is_pushed, 3, "push a set of three sets");

        my $id = 1;

        my @set = ("This", "is", "a", "set4");
        my $is_update_row = $datum->update($id, \@set);
        is($is_update_row, 1, "update a row using a set");
        my @res = ("This", "a", "is", "set4");
        my $get_result_row = $datum->get($id);
        is_deeply($get_result_row, \@res, "update the pushed sets and compare with new set");


        my %sets2 = (
            2 => ["This", "is", "a", "set1"],
            1 => ["This", "is", "a", "set2"],
            0 => ["This", "is", "a", "set3"],
        );
        my $is_updated = $datum->update_multi(\%sets2);
        is($is_updated, 3, "update a set of three sets");

        my @res2 = ("This", "a", "is", "set2");
        my $get_result = $datum->get($id);
        is_deeply($get_result, \@res2, "update the pushed sets and compare with original set");
    };
};

subtest "Test of sort()" => sub {
    my $datum =  Algorithm::SetSimilarity::Join::Datum->new();
    subtest "with two sets" => sub {
        my @set1 = (
            ["This",],
            ["This", "is",],
            ["This", "is", "a",],
            ["This", "is", "a", "set",],
        );

        my @set2 = (
            ["This", "a", "is", "set",],
            ["This", "a", "is",],
            ["This", "is",],
            ["This",],
        );

        my $is_pushed = $datum->push_multi(\@set1);
        is($is_pushed, 4, "push four sets");

        my $is_sorted = $datum->sort();
        is($is_sorted, 1, "execute the sorting process");

        is_deeply(\@{$datum->{datum}}, \@set2, "sort the sets by the elements number of the each sets");
    };
};

done_testing;
