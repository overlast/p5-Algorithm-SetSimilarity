use strict;

use Test::More;

use Algorithm::SetSimilarity::Join::MPJoin;
use Algorithm::SetSimilarity::Join::Datum;

use YAML;

subtest "Test of initializing" => sub {
    my $mpj =  Algorithm::SetSimilarity::Join::MPJoin->new();
    subtest "with the default parameters" => sub {
        is ("Algorithm::SetSimilarity::Join::MPJoin", ref $mpj, "Get Algorithm::SetSimilarity::Join::MPJoin object");
    };
};

subtest "Test of join() with two sets which have 5 common number elements" => sub {
    my $mpj =  Algorithm::SetSimilarity::Join::MPJoin->new();
    {
        my @sets = (
            [1,2,3,4,5,6,7,8,9,10],
            [1,3,5,7,9,11,13,15,17,19],
        );
        my $datum = Algorithm::SetSimilarity::Join::Datum->new();
        $datum->push_multi(\@sets);

        subtest "using 0.33 as a threshold value" => sub {
            my $threshold = 0.33;
            my $result = $mpj->join($datum, $threshold);
            my $res = [[0, 1, 0.333333333333333]];
            is_deeply ($result, $res, "Make check of join() which return one pair")
        };

        subtest "using 0.34 as a threshold value" => sub {
            my $threshold = 0.34;
            my $result = $mpj->join($datum, $threshold);
            my $res = [];
            is_deeply ($result, $res, "Make check of join() which return no pair")
        };
    }

    {
        my @sets = (
            [2,4,6,8,10,11,13,15,17,19],
            [1,3,5,7,9,11,13,15,17,19],
        );
        my $datum = Algorithm::SetSimilarity::Join::Datum->new();
        $datum->push_multi(\@sets);

        subtest "using 0.33 as a threshold value" => sub {
            my $threshold = 0.33;
            my $result = $mpj->join($datum, $threshold);
            my $res = [[0, 1, 0.333333333333333]];
            is_deeply ($result, $res, "Make check of join() which return one pair")
        };

        subtest "using 0.34 as a threshold value" => sub {
            my $threshold = 0.34;
            my $result = $mpj->join($datum, $threshold);
            my $res = [];
            is_deeply ($result, $res, "Make check of join() which return no pair")
        };
    }
};

subtest "Test of join() with two sets which have 5 common alphabet elements" => sub {
    my $mpj =  Algorithm::SetSimilarity::Join::MPJoin->new();
    {
        my @sets = (
            ["a","b","c","d","e","f","g","h","i","j"],
            ["a","b","c","d","e","k","l","m","n","o"],
        );
        my $datum = Algorithm::SetSimilarity::Join::Datum->new();
        $datum->push_multi(\@sets);

        subtest "using 0.33 as a threshold value" => sub {
            my $threshold = 0.33;
            my $result = $mpj->join($datum, $threshold);
            my $res = [[0, 1, 0.333333333333333]];
            is_deeply ($result, $res, "Make check of join() which return one pair")
        };

        subtest "using 0.34 as a threshold value" => sub {
            my $threshold = 0.34;
            my $result = $mpj->join($datum, $threshold);
            my $res = [];
            is_deeply ($result, $res, "Make check of join() which return no pair")
        };
    }

    {
        my @sets = (
            ["a","b","c","d","e","k","l","m","n","o"],
            ["f","g","h","i","j","k","l","m","n","o"],
        );
        my $datum = Algorithm::SetSimilarity::Join::Datum->new();
        $datum->push_multi(\@sets);

        subtest "using 0.33 as a threshold value" => sub {
            my $threshold = 0.33;
            my $result = $mpj->join($datum, $threshold);
            my $res = [[0, 1, 0.333333333333333]];
            is_deeply ($result, $res, "Make check of join() which return one pair")
        };

        subtest "using 0.34 as a threshold value" => sub {
            my $threshold = 0.34;
            my $result = $mpj->join($datum, $threshold);
            my $res = [];
            is_deeply ($result, $res, "Make check of join() which return no pair")
        };
    }

};







=pod

subtest "Test of join() with the null sets" => sub {
    my $mpj =  Algorithm::SetSimilarity::Join::MPJoin->new();
    {
        my @sets = (
            [1,2,3,4,5,6,7,8,9,10],
            [1,3,5,7,9,11,13,15,17,19],
#            [2,4,6,8,10,12,14,16,18,20],
#            [1,2,3,5,7,11,13,17,19,23],
#            [1,2,4,8,16,32,64,128,256,512],
#            [1,2,3,4,5,6,7,8,9,9],
##            [1,2,3,4,5,6,7,8,8,8],
#            [1,2,3,4,5,6,7,7,7,7],
#            [1,2,3,4,5,6,6,6,6,6],
#            [1,2,3,4,5,5,5,5,5,5],
#            [1,2,3,4,4,4,4,4,4,4],
#            [1,2,3,3,3,3,3,3,3,3],
#            [1,2,2,2,2,2,2,2,2,2],
#            [1,2,3,4,5,6,7,8,9,],
#            [1,2,3,4,5,6,7,8,],
#            [1,2,3,4,5,6,7,],
#            [1,2,3,4,5,6,],
#            [1,2,3,4,5,],
#            [1,2,3,4,],
#            [1,2,3,],
#            [1,2,],
#            [1,],
        );
        my $datum = Algorithm::SetSimilarity::Join::Datum->new();
        $datum->push_multi(\@sets);

        my $threshold = 0.33;
        my $result = $mpj->join($datum, $threshold);
        print Dump $result;
        is_deeply ($result, [], "Make check of join() with two null sets")
    }
};

=cut

done_testing;
