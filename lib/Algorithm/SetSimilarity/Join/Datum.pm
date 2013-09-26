 package Algorithm::SetSimilarity::Join::Datum;

 use 5.008005;
 use strict;
 use warnings;

 our $VERSION = "0.0.0_03";

 use Scalar::Util;

 sub new {
     my ($class, $param) = @_;
     my @array = ();
     my %hash = (
         "datum" => \@array,
     );
     $hash{"data_type"} = $param->{"data_type"} if (exists $param->{"data_type"});
     bless \%hash, $class;
 }

 sub get_num {
     my ($self) = @_;
     my $num = 0;
     if (exists $self->{datum}) {
         if ((defined $self->{datum}->[0]) && (ref $self->{datum}->[0] eq "ARRAY")) {
             if (ref $self->{datum}->[0]->[0] eq "ARRAY") {
                 $num = ($#{$self->{datum}} + 1) if ($self->check_pushability($self->{datum}->[0]->[0]));
             } else {
                 $num = ($#{$self->{datum}} + 1) if ($self->check_pushability($self->{datum}->[0]));
             }
         }
     }
     return $num;
 }

 sub check_pushability {
     my ($self, $set) = @_;
     my $is_pushable = 0;
     $is_pushable = 1 if ((defined $set) && (ref $set eq "ARRAY") && (defined $set->[0]) && (ref $set->[0] eq ''));
     $is_pushable = 1 if ((defined $set) && (ref $set eq "HASH") && ((scalar(keys %$set)) > 0));
     return $is_pushable;
 }

 sub update_multi {
     my ($self, $sets) = @_;
     my $is_update = 0;
     if ((defined $sets) && (ref $sets eq "HASH")) {
         foreach my $key (keys %{$sets}) {
             if ($key >= 0) {
                 $is_update += $self->update($key, $sets->{$key});
             }
         }
     }
     return $is_update;
 }

 sub estimate_data_type {
     my ($self, $set) = @_;
     my $is_estimate = -1;
     my $type = "";
     my $max_check_elements = 5;
     if (ref $set eq "ARRAY") {
         for (my $i = 0; ($i <= $#$set) && ($i < $max_check_elements); $i++) {
             my $tmp_type = "";
             if (Scalar::Util::looks_like_number($set->[$i])) {
                 $tmp_type = "number";
             } else {
                 $tmp_type = "string";
             }
             if ($type eq "") {
                 $type = $tmp_type;
                 $is_estimate = 1;
             } elsif ($type ne $tmp_type) {
                 $is_estimate = 0;
                 last;
             }
         }
     } elsif (ref $set eq "HASH") {
         my $i = 0;
         foreach my $key (keys %$set) {
            $i++;
             my $tmp_type = "";
             if (Scalar::Util::looks_like_number($key)) {
                 $tmp_type = "number";
             } else {
                 $tmp_type = "string";
             }
             if ($type eq "") {
                 $type = $tmp_type;
                 $is_estimate = 1;
             } elsif ($type ne $tmp_type) {
                 $is_estimate = 0;
                 last;
             }
             last if ($i >= $max_check_elements);
         }
     }
     $self->{data_type} = $type if ($is_estimate);
     return $is_estimate;
 }

 sub sort_set {
     my ($self, $set) = @_;
     my @array = ();
     if ((defined $set) && (ref $set eq "ARRAY")) {
         @array = @{$set};
         if ($#$set > 0) {
             $self->estimate_data_type($set) unless (exists $self->{data_type});
             if ($self->{data_type} eq "number") {
                 @array = sort { $a <=> $b } @{$set};
             }
             else {
                 @array = sort { $a cmp $b } @{$set};
             }
         }
     }
     return \@array;
 }

 sub update {
     my ($self, $id, $set) = @_;
     my $is_update = 0;
     if (($self->check_pushability($set)) && ($id < ($self->get_num()))) {
         if (ref $set eq "ARRAY") {
             $set = $self->sort_set($set);
         } elsif (ref $set eq "HASH") {
             $set = $self->make_pair_from_hash($set);
         }
         $self->{datum}->[$id] = $set;
         $is_update = 1;
     }
     return $is_update;
 }

 sub push_multi {
     my ($self, $sets) = @_;
     my $is_push = 0;
     if ((defined $sets) && (ref $sets eq "ARRAY")) {
         foreach my $set (@{$sets}) {
             $is_push += $self->push($set);
         }
     }
     return $is_push;
 }

sub make_pair_from_hash {
    my ($self, $set) = @_;
    my @pair = ();
    foreach my $key (keys %$set) {
        my $entry = [$key, $set->{$key}];
        push @pair, $entry;
    }
    $self->estimate_data_type($set) unless (exists $self->{data_type});
    if ($self->{data_type} eq "number") {
        @pair = sort { $a->[0] <=> $b->[0] } @pair;
    } else {
        @pair = sort { $a->[0] cmp $b->[0] } @pair;
    }
    return \@pair;
}

 sub push {
     my ($self, $set) = @_;
     my $is_push = 0;
     if ($self->check_pushability($set)) {
         if (ref $set eq "ARRAY") {
             $set = $self->sort_set($set);
         } elsif (ref $set eq "HASH") {
             $set = $self->make_pair_from_hash($set);
         }
         push @{$self->{datum}}, $set;
         $is_push = 1;
     }
     return $is_push;
 }

 sub get {
     my ($self, $id) = @_;
     my $set = [];
     $set = $self->{datum}->[$id] if (defined $self->{datum}->[$id]);
     return $set;
 }

sub sort {
    my ($self) = @_;
    my $is_sort = 0;
    if ($self->get_num() > 1) {
        my @array = sort { $#$b <=> $#$a } @{$self->{datum}};
        $self->{datum} = \@array;
        $is_sort = 1;
    }
    return $is_sort;
}

 1;

 __END__

 =encoding utf-8

 =head1 NAME

 Algorithm::SetSimilarity::Join::Datum - It's new $module

 =head1 SYNOPSIS

    use Algorithm::SetSimilarity::Join::Datum;

=head1 DESCRIPTION

Algorithm::SetSimilarity::Join::Datum is ...

=head1 LICENSE

Copyright (C) Toshinori Sato (@overlast).

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Toshinori Sato (@overlast) E<lt>overlasting@gmail.comE<gt>

=cut
