# This is a submodule of the Relations Display module. It's
# used to store info used to generate a Display object.

package Relations::Display::Table;
require Exporter;
require DBI;
require 5.004;

use Relations;

# Copyright 2001 GAF-3 Industries, Inc. All rights reserved.
# Written by George A. Fitch III (aka Gaffer), gaf3@gaf3.com

# This program is free software, you can redistribute it and/or modify it under
# the same terms as Perl istelf

$Relations::Display::Table::VERSION = '0.90';

@ISA = qw(Exporter);

@EXPORT    = ();		

@EXPORT_OK = qw(
                new
               );

%EXPORT_TAGS = ();

# From here on out, be strict and clean.

use strict;

# Create a Relations::Family::Table object. This
# object is a list of values to select from.

sub new {

  # Get the type we were sent

  my ($type) = shift;

  # Get all the arguments passed

  my ($main_label,
      $x_axis_label,
      $legend_label,
      $x_axis_values,
      $legend_values,
      $x_axis_titles,
      $legend_titles,
      $data) = rearrange(['MAIN_LABEL',
                          'X_AXIS_LABEL',
                          'LEGEND_LABEL',
                          'X_AXIS_VALUES',
                          'LEGEND_VALUES',
                          'X_AXIS_TITLES',
                          'LEGEND_TITLES',
                          'DATA'],@_);

  # $x_axis_values - Array ref of the actual x axis values,
  #                   what they're stored as.
  # $legend_values - Array ref of the actual legend values
  #                   what they're stored as.
  # $x_axis_titles - Hash ref of the displayed x axis values,
  #                  what's shown on the graph.
  # $legend_titles - Hash ref of the displayed legend values,
  #                  what's shown on the graph.
  # $main_label - Label for the table
  # $x_axis_label - Label for the x axis data
  # $legend_label - Label for the legend data
  # $data - 2D Hash ref of the data keyed by x_axis and legend
  #         values.

  # Create the hash to hold all the vars
  # for this object.

  my $self = {};

  # Bless it with the type sent (I think this
  # makes it a full fledged object)

  bless $self, $type;

  # Add the info into the hash

  $self->{main_label} = $main_label if $main_label;
  $self->{x_axis_label} = $x_axis_label if $x_axis_label;
  $self->{legend_label} = $legend_label if $legend_label;
  $self->{x_axis_values} = $x_axis_values if $x_axis_values;
  $self->{legend_values} = $legend_values if $legend_values;
  $self->{x_axis_titles} = $x_axis_titles if $x_axis_titles;
  $self->{legend_titles} = $legend_titles if $legend_titles;
  $self->{data} = $data if $data;

  # Return thyself 

  return $self;

}

$Relations::Display::Table::VERSION;