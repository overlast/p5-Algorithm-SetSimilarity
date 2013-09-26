use strict;

use Test::More;

use Algorithm::SetSimilarity::Join::WMPJoin;
use Algorithm::SetSimilarity::Join::Datum;

subtest "Test of initializing" => sub {
    my $wmpj =  Algorithm::SetSimilarity::Join::WMPJoin->new();
    subtest "with the default parameters" => sub {
        is ("Algorithm::SetSimilarity::Join::WMPJoin", ref $wmpj, "Get Algorithm::SetSimilarity::Join::WMPJoin object");
    };
};

subtest "Test of check_joinable()" => sub {
    my $wmpj = Algorithm::SetSimilarity::Join::WMPJoin->new();
    subtest "with a Datum instance" => sub {
        my @sets = (
            {1 => 1,2 => 1,3 => 1,4 => 1,5 => 1,6 => 1,7 => 1,8 => 1,9 => 1,10 => 1},
            {1 => 1,3 => 1,5 => 1,7 => 1,9 => 1,11 => 1,13 => 1,15 => 1,17 => 1,19 => 1},
        );
        my $datum = Algorithm::SetSimilarity::Join::Datum->new();
        my $is_pushed = $datum->push_multi(\@sets);
        my $is_joinable = $wmpj->check_joinable($datum);
        is ($is_joinable, 1, "Algorithm::SetSimilarity::Join::Datum object is joinable");
    };
    subtest "with a hash structure" => sub {
        my $hash = {
            "data_type" => "number",
            "datum" => [
                [[1,1],[2,1],[3,1],[4,1],[5,1],[6,1],[7,1],[8,1],[9,1],[10,1]],
                [[1,1],[3,1],[5,1],[7,1],[9,1],[11,1],[13,1],[15,1],[17,1],[19,1]],
            ],
        };
        my $is_joinable = $wmpj->check_joinable($hash);
        is ($is_joinable, 0, "Unverified hash value is not joinable");
    };
};

subtest "Test of join() with two sets which have 5 common number elements" => sub {
    my $wmpj =  Algorithm::SetSimilarity::Join::WMPJoin->new();
    {
        my @sets = (
            {1 => 1, 2 => 1, 3 => 1, 4 => 1, 5 => 1, 6 => 1, 7 => 1, 8 => 1, 9 => 1, 10 => 1},
            {1 => 1, 3 => 1, 5 => 1, 7 => 1, 9 => 1, 11 => 1, 13 => 1, 15 => 1, 17 => 1, 19 => 1},
        );
        my $datum = Algorithm::SetSimilarity::Join::Datum->new();
        my $is_pushed = $datum->push_multi(\@sets);
        is($is_pushed, 2, "push two sets");

        subtest "using 0.33 as a threshold value" => sub {
            my $threshold = 0.33;
            my $result = $wmpj->join($datum, $threshold);
            my $res = [[0, 1, 0.333333333333333]];
            is_deeply ($result, $res, "Make check of join() which return one pair")
        };

        subtest "using 0.34 as a threshold value" => sub {
            my $threshold = 0.34;
            my $result = $wmpj->join($datum, $threshold);
            my $res = [];
            is_deeply ($result, $res, "Make check of join() which return no pair")
        };
    }
    {
        my @sets = (
            {2 => 1,4 => 1,6 => 1,8 => 1,10 => 1,11 => 1,13 => 1,15 => 1,17 => 1,19 => 1},
            {1 => 1,3 => 1,5 => 1,7 => 1,9 => 1,11 => 1,13 => 1,15 => 1,17 => 1,19 => 1},
        );
        my $datum = Algorithm::SetSimilarity::Join::Datum->new();
        $datum->push_multi(\@sets);

        subtest "using 0.33 as a threshold value" => sub {
            my $threshold = 0.33;
            my $result = $wmpj->join($datum, $threshold);
            my $res = [[0, 1, 0.333333333333333]];
            is_deeply ($result, $res, "Make check of join() which return one pair")
        };

        subtest "using 0.34 as a threshold value" => sub {
            my $threshold = 0.34;
            my $result = $wmpj->join($datum, $threshold);
            my $res = [];
            is_deeply ($result, $res, "Make check of join() which return no pair")
        };
    }
};

subtest "Test of join() with two sets which have 5 common alphabet elements" => sub {
    my $wmpj =  Algorithm::SetSimilarity::Join::WMPJoin->new();
    {
        my @sets = (
            {"a" => 1,"b" => 1,"c" => 1,"d" => 1,"e" => 1,"f" => 1,"g" => 1,"h" => 1,"i" => 1,"j" => 1},
            {"a" => 1,"b" => 1,"c" => 1,"d" => 1,"e" => 1,"k" => 1,"l" => 1,"m" => 1,"n" => 1,"o" => 1},
        );
        my $datum = Algorithm::SetSimilarity::Join::Datum->new();
        $datum->push_multi(\@sets);

        subtest "using 0.33 as a threshold value" => sub {
            my $threshold = 0.33;
            my $result = $wmpj->join($datum, $threshold);
            my $res = [[0, 1, 0.333333333333333]];
            is_deeply ($result, $res, "Make check of join() which return one pair")
        };

        subtest "using 0.34 as a threshold value" => sub {
            my $threshold = 0.34;
            my $result = $wmpj->join($datum, $threshold);
            my $res = [];
            is_deeply ($result, $res, "Make check of join() which return no pair")
        };
    }

    {
        my @sets = (
            {"a" => 1,"b" => 1,"c" => 1,"d" => 1,"e" => 1,"k" => 1,"l" => 1,"m" => 1,"n" => 1,"o" => 1},
            {"f" => 1,"g" => 1,"h" => 1,"i" => 1,"j" => 1,"k" => 1,"l" => 1,"m" => 1,"n" => 1,"o" => 1},
        );
        my $datum = Algorithm::SetSimilarity::Join::Datum->new();
        $datum->push_multi(\@sets);

        subtest "using 0.33 as a threshold value" => sub {
            my $threshold = 0.33;
            my $result = $wmpj->join($datum, $threshold);
            my $res = [[0, 1, 0.333333333333333]];
            is_deeply ($result, $res, "Make check of join() which return one pair")
        };

        subtest "using 0.34 as a threshold value" => sub {
            my $threshold = 0.34;
            my $result = $wmpj->join($datum, $threshold);
            my $res = [];
            is_deeply ($result, $res, "Make check of join() which return no pair")
        };
    }
};

subtest "Test of join() with four sets which have 5 common alphabet elements" => sub {
    my $wmpj =  Algorithm::SetSimilarity::Join::WMPJoin->new();
    {
        my @sets = (
            {"a" => 1,"b" => 1,"c" => 1,"d" => 1,"e" => 1,"f" => 1,"g" => 1,"h" => 1,"i" => 1,"j" => 1},
            {"a" => 1,"b" => 1,"c" => 1,"d" => 1,"e" => 1,"k" => 1,"l" => 1,"m" => 1,"n" => 1,"o" => 1},
            {"k" => 1,"l" => 1,"m" => 1,"n" => 1,"o" => 1,"p" => 1,"q" => 1,"r" => 1,"s" => 1,"t" => 1},
            {"p" => 1,"q" => 1,"r" => 1,"s" => 1,"t" => 1,"u" => 1,"v" => 1,"w" => 1,"x" => 1,"y" => 1},
            {"u" => 1,"v" => 1,"w" => 1,"x" => 1,"y" => 1,"z" => 1,"A" => 1,"B" => 1,"C" => 1,"D" => 1},
        );
        my $datum = Algorithm::SetSimilarity::Join::Datum->new();
        $datum->push_multi(\@sets);

        subtest "using 0.33 as a threshold value" => sub {
            my $threshold = 0.33;
            my $result = $wmpj->join($datum, $threshold);
            my $res = [
                [0, 1, 0.333333333333333],
                [1, 2, 0.333333333333333],
                [2, 3, 0.333333333333333],
                [3, 4, 0.333333333333333],
            ];
            is_deeply ($result, $res, "Make check of join() which return four pairs")
        };
    }
    {
        my @sets = (
            {"a" => 1,"b" => 1,"c" => 1,"d" => 1,"e" => 1,"f" => 1,"g" => 1,"h" => 1,"i" => 1,"j" => 1},
            {"a" => 1,"b" => 1,"c" => 1,"d" => 1,"e" => 1,"k" => 1,"l" => 1,"m" => 1,"n" => 1,"o" => 1},
            {"k" => 1,"l" => 1,"m" => 1,"n" => 1,"o" => 1,"p" => 1,"q" => 1,"r" => 1,"s" => 1,"t" => 1},
            {"p" => 1,"q" => 1,"r" => 1,"s" => 1,"t" => 1,"u" => 1,"v" => 1,"w" => 1,"x" => 1,"y" => 1},
            {"u" => 1,"v" => 1,"w" => 1,"x" => 1,"y" => 1,"z" => 1,"A" => 1,"B" => 1,"C" => 1,"D" => 1},
            {"f" => 1,"g" => 1,"h" => 1,"i" => 1,"j" => 1,"k" => 1,"l" => 1,"m" => 1,"n" => 1,"o" => 1},
        );
        my $datum = Algorithm::SetSimilarity::Join::Datum->new();
        $datum->push_multi(\@sets);
        subtest "using 0.33 as a threshold value" => sub {
            my $threshold = 0.33;
            my $result = $wmpj->join($datum, $threshold);
            my $res = [
                [0, 1, 0.333333333333333],
                [0, 5, 0.333333333333333],
                [1, 2, 0.333333333333333],
                [1, 5, 0.333333333333333],
                [2, 3, 0.333333333333333],
                [2, 5, 0.333333333333333],
                [3, 4, 0.333333333333333],
            ];
            is_deeply ($result, $res, "Make check of join() which return seven pairs")
        };
    }
};

subtest "Test of join() with four sets which have 2 common alphabet elements" => sub {
    my $wmpj =  Algorithm::SetSimilarity::Join::WMPJoin->new();
    {
        my @sets = (
            {"a" => 1,"b" => 1,"c" => 1,"d" => 1},
            {"a" => 1,"b" => 1,"e" => 1,"f" => 1},
            {"e" => 1,"f" => 1,"g" => 1},
            {"c" => 1,"d" => 1,},
        );
        my $datum = Algorithm::SetSimilarity::Join::Datum->new();
        $datum->push_multi(\@sets);
        subtest "using the different size sets" => sub {
            my $threshold = 0.33;
            my $result = $wmpj->join($datum, $threshold);
            my $res = [
                [0, 1, 0.333333333333333],
                [0, 3, 0.5],
                [1, 2, 0.4],
            ];
            is_deeply ($result, $res, "Make check of join() which return three pairs")
        };
    }
};

done_testing;
