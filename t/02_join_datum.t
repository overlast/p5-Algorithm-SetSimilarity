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

done_testing;
