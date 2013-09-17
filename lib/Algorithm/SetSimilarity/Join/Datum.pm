 package Algorithm::SetSimilarity::Join::Datum;

 use 5.008005;
 use strict;
 use warnings;

 use YAML;

 our $VERSION = "0.01";

 sub new {
     my ($class) = @_;
     my @array = ();
     my %hash = (
         "datum" => \@array,
     );
     bless \%hash, $class;
 }

 sub get_num {
     my ($self) = @_;
     my $num = 0;
     $num = ($#{$self->{datum}} + 1) if (exists $self->{datum});
     return $num;
 }

 sub chack_pushability {
     my ($self, $set) = @_;
     my $is_pushable = 0;
     $is_pushable = 1 if ((ref $set eq "ARRAY") && (defined $set->[0]) && (ref $set->[0] eq "SCALAR"));
     return $is_pushable;
 }

 sub update_multi {
     my ($self, $sets) = @_;
     my $is_update = 0;
     if (ref $sets eq "HASH") {
         foreach my $key (keys $sets) {
             if ($key >= 0) {
                 $is_update += $self->update($sets->{$key}, $key);
             }
         }
     }
     return $is_update;
 }

 sub update {
     my ($self, $set, $id) = @_;
     my $is_update = 0;
     if (($self-->chack_pushability($set)) && ($id < $self->get_num())) {
         $self->{datum}->[$id] = $set;
     }
     return $is_update;
 }

 sub push_multi {
     my ($self, $sets) = @_;
     my $is_push = 0;
     if (ref $sets eq "ARRAY") {
         foreach my $set (@{$sets}) {
             $is_push += $self->push($set);
         }
     }
     return $is_push;
 }

 sub push {
     my ($self, $set) = @_;
     my $is_push = 0;
     if ($self->chack_pushability($set)) {
         push @{$self->{datum}}, $set;
         $is_push = 1;
     }
     return $is_push;
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
