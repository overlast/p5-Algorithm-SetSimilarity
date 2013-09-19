 package Algorithm::SetSimilarity::Join::Datum;

 use 5.008005;
 use strict;
 use warnings;

 our $VERSION = "0.0.0_01";

 sub new {
     my ($class, $param) = @_;
     my @array = ();
     my %hash = (
         "datum" => \@array,
         "data_type" => "string",
     );
     $hash{"data_type"} = $param->{"data_type"} if (exists $param->{"data_type"});
     bless \%hash, $class;
 }

 sub get_num {
     my ($self) = @_;
     my $num = 0;
     $num = ($#{$self->{datum}} + 1) if ((exists $self->{datum}) && ($self->check_pushability($self->{datum}->[0])));
     return $num;
 }

 sub check_pushability {
     my ($self, $set) = @_;
     my $is_pushable = 0;
     $is_pushable = 1 if ((defined $set) && (ref $set eq "ARRAY") && (defined $set->[0]) && (ref $set->[0] eq ''));
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

 sub sort_set {
     my ($self, $set) = @_;
     my @array = ();
     if ((defined $set) && (ref $set eq "ARRAY")) {
         @array = @{$set};
         if ($#$set > 0) {
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
         $set = $self->sort_set($set);
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

 sub push {
     my ($self, $set) = @_;
     my $is_push = 0;
     if ($self->check_pushability($set)) {
         $set = $self->sort_set($set);
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
