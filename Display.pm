# The module's purpose is to take a query and return
# a graph of the query's results.

package Relations::Display;
require Exporter;
require DBI;
require GD::Graph;
require Relations;
require Relations::Query;
require Relations::Abstract;
require 5.004;

use GD::Graph;
use Relations;
use Relations::Query;
use Relations::Abstract;
use Relations::Display::Table;

# You can run this file through either pod2man or pod2html to produce pretty
# documentation in manual or html file format (these utilities are part of the
# Perl 5 distribution).

# Copyright 2001 GAF-3 Industries, Inc. All rights reserved.
# Written by George A. Fitch III (aka Gaffer), gaf3@gaf3.com

# This program is free software, you can redistribute it and/or modify it under
# the same terms as Perl istelf

$Relations::Display::VERSION = '0.90';

@ISA = qw(Exporter);

@EXPORT    = ();		

@EXPORT_OK = qw(
                new
               );

%EXPORT_TAGS = ();

# From here on out, be strict and clean.

use strict;



# Declare some defaults for the the graph.

my %graph_defaults = (
  fgclr        => 'black', 
  accentclr    => 'white', 
  labelclr     => 'black', 
  axislabelclr => 'black', 
  legendclr    => 'black', 
  textclr      => 'black'
);



# Create a Relations::Display object. This object 
# allows you to specify a query, matrix, or table
# and then can return either a matrix, table, or
# CHART of the data sent.

sub new {

  # Get the type we were sent

  my ($type) = shift;

  # Get all the arguments passed

  my ($abstract,
      $query,
      $chart,
      $width,
      $height,
      $x_axis,
      $legend,
      $data,
      $settings,
      $hide,
      $vertical,
      $horizontal,
      $matrix,
      $table) = rearrange(['ABSTRACT',
                           'QUERY',
                           'CHART',
                           'WIDTH',
                           'HEIGHT',
                           'X_AXIS',
                           'LEGEND',
                           'DATA',
                           'SETTINGS',
                           'HIDE',
                           'VERTICAL',
                           'HORIZONTAL',
                           'MATRIX',
                           'TABLE'],@_);

  # $abstract - Relations::Abstract object.
  # $chart - The chart type, lines, bars, etc.
  # $width - The width of the chart.
  # $height - The height of the chart.
  # $query - Query to obtain the data to use
  # $matrix - Array of hashes of the data to use
  # $table - Table object of the data to use
  # $x_axis - Array or string of X Axis fields
  # $legend - Array or string of Legend fields
  # $data - Data field
  # $settings - Hash of settings for GD::Graph
  # $hide - Hash, Array or string of fields to hide
  # $vertical - Array or string of fields to 
  #             use draw vertical lines.
  # $horizontal - Array or string of fields to 
  #               use draw horizontal lines.

  # Create the hash to hold all the vars
  # for this object.

  my $self = {};

  # Bless it with the type sent (I think this
  # makes it a full fledged object)

  bless $self, $type;

  # Add the info into the hash only if it was sent

  $self->{abstract} = $abstract if $abstract;

  $self->{query} = $query if $query;
  $self->{matrix} = $matrix if $matrix;
  $self->{table} = $table if $table;

  $self->{chart} = $chart if $chart;
  $self->{width} = $width if $width;
  $self->{height} = $height if $height;
  $self->{x_axis} = to_array($x_axis) if $x_axis;
  $self->{legend} = to_array($legend) if $legend;
  $self->{settings} = $settings if $settings;
  $self->{data} = $data if $data;

  $self->{hide} = to_hash($hide) if $hide;
  $self->{vertical} = to_array($vertical) if $vertical;
  $self->{horizontal} = to_array($horizontal) if $horizontal;

  # Return thyself

  return $self;

}



# Adds info to the Display object

sub add {

  # Know thyself

  my ($self) = shift;

  # Get all the arguments passed

  my ($x_axis,
      $legend,
      $settings,
      $hide,
      $vertical,
      $horizontal) = rearrange(['X_AXIS',
                                'LEGEND',
                                'SETTINGS',
                                'HIDE',
                                'VERTICAL',
                                'HORIZONTAL'],@_);

  # $x_axis - Array or string of X Axis fields
  # $legend - Array or string of Legend fields
  # $settings - Hash of settings for GD::Graph
  # $hide - Hash, Array or string of fields to hide
  # $vertical - Array or string of fields to 
  #             use draw vertical lines.
  # $horizontal - Array or string of fields to 
  #               use draw horizontal lines.

  # Add info the object only if it was sent

  $self->{x_axis} = add_array($self->{x_axis},to_array($x_axis)) if $x_axis;
  $self->{legend} = add_array($self->{legend},to_array($legend)) if $legend;
  $self->{settings} = add_hash($self->{settings},$settings) if $settings;

  $self->{hide} = add_hash($self->{hide},to_hash($hide)) if $hide;
  $self->{vertical} = add_array($self->{vertical},to_array($vertical)) if $vertical;
  $self->{horizontal} = add_array($self->{horizontal},to_array($horizontal)) if $horizontal;

  # Return thyself

  return $self;

}



# Sets info in the Display object

sub set {

  # Know thyself

  my ($self) = shift;

  # Get all the arguments passed

  my ($abstract,
      $query,
      $chart,
      $width,
      $height,
      $x_axis,
      $legend,
      $data,
      $settings,
      $hide,
      $vertical,
      $horizontal,
      $matrix,
      $table) = rearrange(['ABSTRACT',
                           'QUERY',
                           'CHART',
                           'WIDTH',
                           'HEIGHT',
                           'X_AXIS',
                           'LEGEND',
                           'DATA',
                           'SETTINGS',
                           'HIDE',
                           'VERTICAL',
                           'HORIZONTAL',
                           'MATRIX',
                           'TABLE'],@_);

  # $abstract - Relations::Abstract object
  # $chart - The chart type, lines, bars, etc.
  # $width - The width of the chart.
  # $height - The height of the chart.
  # $query - Query to obtain the data to use
  # $matrix - Array of hashes of the data to use
  # $table - Table object of the data to use
  # $x_axis - Array or string of X Axis fields
  # $legend - Array or string of Legend fields
  # $data - Data field
  # $settings - Hash of settings for GD::Graph
  # $hide - Hash, Array or string of fields to hide
  # $vertical - Array or string of fields to 
  #             use draw vertical lines.
  # $horizontal - Array or string of fields to 
  #               use draw horizontal lines.

  # Set the info into the object only if it was sent

  $self->{abstract} = $abstract if $abstract;

  $self->{query} = $query if $query;
  $self->{matrix} = $matrix if $matrix;
  $self->{table} = $table if $table;

  $self->{chart} = $chart if $chart;
  $self->{width} = $width if $width;
  $self->{height} = $height if $height;
  $self->{x_axis} = to_array($x_axis) if $x_axis;
  $self->{legend} = to_array($legend) if $legend;
  $self->{settings} = $settings if $settings;
  $self->{data} = $data if $data;

  $self->{hide} = to_hash($hide) if $hide;
  $self->{vertical} = to_array($vertical) if $vertical;
  $self->{horizontal} = to_array($horizontal) if $horizontal;

  # Return thyself

  return $self;

}



# Runs the query if it needs to and and hasn't 
# been run yet and sets and returns the matrix 
# of data.

sub get_matrix {

  # Know thyself

  my ($self) = shift;

  # Unless the matrix hasn been set already

  unless ($self->{matrix}) {

    # Return nothing if we don't have a database
    # handle or a query to use.

    return '' unless $self->{abstract} and $self->{query};

    # Set the object's matrix to this array.

    $self->{matrix} = $self->{abstract}->select_matrix(-query => $self->{query});

  }

  # Return the matrix

  return $self->{matrix};

}



# Creates a Display::Table object from
# matrix data, if it needs to, and returns
# the new object.

sub get_table {

  # Know thyself

  my ($self) = shift;

  # Unless the table has been set already

  unless ($self->{table}) {

    # Return nothing unless we can get a working
    # matrix.

    return '' unless $self->get_matrix();

    # Return nothing if we don't have any fields
    # for either the x axis or the legend.

    return '' unless ($self->{x_axis} or $self->{legend});

    # First we have to figure out which fields 
    # have the same value for all rows and which
    # ones have different values for different 
    # rows.

    # Declare a hash to indicate the fields that
    # have different values.

    my %different = ();

    # Go through each row of the matirx

    foreach my $row (@{$self->{matrix}}) {

      # Go through each of the x axis fields

      foreach my $x_axis (@{$self->{x_axis}}) {

        # Indicate this field has more than one value
        # unless it's the same as the field in the 
        # first row.

        $different{$x_axis} = 1 unless $row->{$x_axis} eq $self->{matrix}->[0]->{$x_axis};

      }

      # Go through each of the legend fields

      foreach my $legend (@{$self->{legend}}) {

        # Indicate this field has more than one value
        # unless it's the same as the field in the 
        # first row.

        $different{$legend} = 1 unless $row->{$legend} eq $self->{matrix}->[0]->{$legend};

      }

    }

    # Now we'll go through and figure out which 
    # field names and field values go where based 
    # on whether they all have the same values or 
    # not.

    # First declare some arrays to hold all the info.

    my @main_label = ();    # Holds same field values
    my @x_axis_label = ();  # Holds different x_axis field names
    my @legend_label = ();  # Holds different legend field names
    my @x_axis_value = (); # Holds different x axis field value (all)
    my @legend_value = (); # Holds different legend field value (all)
    my @x_axis_title = (); # Holds different x axis field value (shown)
    my @legend_title = (); # Holds different legend field value (shown)

    # Now go through the different fields for the 
    # x axis and legend, putting the field names
    # in the label and the field (future) value
    # in the value and titles. Values are what's
    # really store and titles are what's displayed.

    # Go through each of the x axis fields

    foreach my $x_axis (@{$self->{x_axis}}) {

      # Unless this field has different values

      unless ($different{$x_axis}) {

        # Make it part of the title unless it's to 
        # be hidden.

        push @main_label,$self->{matrix}->[0]->{$x_axis} unless $self->{hide}->{$x_axis};

      # This field has different values.

      } else {

        # Add what will be the field value (through
        # an eval string) to its array.

        push @x_axis_value,"\$row->{$x_axis}";

        # Unless the field's to be hidden.

        unless ($self->{hide}->{$x_axis}) {

          # Add what will be the field value (through
          # an eval string) to its array, and the field's
          # name to the x axis label.

          push @x_axis_title,"\$row->{$x_axis}";
          push @x_axis_label,$x_axis;

        }

      }

    }

    # Go through each of the legend fields

    foreach my $legend (@{$self->{legend}}) {

      # Unless this field has different values

      unless ($different{$legend}) {

        # Make it part of the title unless it's to 
        # be hidden.

        push @main_label,$self->{matrix}->[0]->{$legend} unless $self->{hide}->{$legend};

      # This field has different values.

      } else {

        # Add what will be the field value (through
        # an eval string) to its array.

        push @legend_value,"\$row->{$legend}";

        # Unless the field's to be hidden.

        unless ($self->{hide}->{$legend}) {

          # Add what will be the field value (through
          # an eval string) to its array, and the field's
          # name to the legend label.

          push @legend_title,"\$row->{$legend}";
          push @legend_label,$legend;

        }

      }

    }

    # Create the labels from the arrays.

    my $main_label = join ' - ',@main_label;
    my $x_axis_label = join ' - ',@x_axis_label;
    my $legend_label = join ' - ',@legend_label;

    # Create the eval strings from the arrays.

    my $x_axis_value_eval = '$x_axis_value = "' . (join ' - ',@x_axis_value) . '";';
    my $legend_value_eval = '$legend_value = "' . (join ' - ',@legend_value) . '";';
    my $x_axis_title_eval = '$x_axis_title = "' . (join ' - ',@x_axis_title) . '";';
    my $legend_title_eval = '$legend_title = "' . (join ' - ',@legend_title) . '";';

    # The titles are set, so now we have to figure
    # the different x axis values and titles and 
    # the different legend values and titles. We'll
    # go through the entire matrix using the eval
    # strings to determine the different x axis and
    # legend values for each row. We'll also figure
    # out which legend values will need lines drawn.

    # Let's declare some structures to hold 
    # everything.

    my $data = ();
    my $x_axis_value;
    my $legend_value;
    my $x_axis_title;
    my $legend_title;
    my %seen_x_axis = ();
    my %seen_legend = ();
    my @x_axis_values = ();
    my @legend_values = ();
    my %x_axis_titles = ();
    my %legend_titles = ();
    my %vertical_lines = ();
    my %horizontal_lines = ();

    # We're goin to need a hash to hold all the 
    # fields that are in the legend so we can
    # make sure the lines we're drawing will have
    # the right color.

    my %in_legend = %{to_hash($self->{legend})};
    
    # Go through all the rows in the matrix.

    foreach my $row (@{$self->{matrix}}) {

      # Eval each of the eval strings

      eval $x_axis_value_eval;
      eval $legend_value_eval;
      eval $x_axis_title_eval;
      eval $legend_title_eval;

      # Unless we've seen this x axis 
      # value before.

      unless ($seen_x_axis{$x_axis_value}) {

        # Add this x axis value to the 
        # array and this x axis title
        # to the hash.

        push @x_axis_values,$x_axis_value;
        $x_axis_titles{$x_axis_value} = $x_axis_title;

        # We've know seen this x axis 
        # value.

        $seen_x_axis{$x_axis_value} = 1;

      }

      # Unless we've seen this legend 
      # value before.

      unless ($seen_legend{$legend_value}) {

        # Add this legend value to the 
        # array and this legend title
        # to the hash.

        push @legend_values,$legend_value;
        $legend_titles{$legend_value} = $legend_title;

        # Go through the vertical lines
        # array, adding those fields'
        # values to the veritcal lines 
        # hash if they're part of the 
        # legend fields.

        foreach my $vertical (@{$self->{vertical}}) {

          $vertical_lines{scalar @legend_values} = $row->{$vertical}
            if $in_legend{$vertical};

        }

        # Save these vertical lines

        $self->{vertical_lines} = \%vertical_lines;

        # Go through the horizontal lines
        # array, adding those fields'
        # values to the veritcal lines 
        # hash if they're part of the 
        # legend fields.

        foreach my $horizontal (@{$self->{horizontal}}) {

          $horizontal_lines{scalar @legend_values} = $row->{$horizontal}
            if $in_legend{$horizontal};

        }    

        # Save these horizontal lines

        $self->{horizontal_lines} = \%horizontal_lines;

        # We've know seen this legend 
        # value.

        $seen_legend{$legend_value} = 1;

      }

      # Unless we're doing a boxplot

      unless ($self->{chart} eq 'boxplot') {

        # If this point's already set, then we're
        # overwriting another value. Let the user
        # know what's up.

        print "Over writing points for x axis: $x_axis_value legend: $legend_value!\n"
          if defined $data->{$x_axis_value}{$legend_value};

        # Set the data point for this value.

        $data->{$x_axis_value}{$legend_value} = $row->{$self->{data}};

      # We're doing a boxplot

      } else {

        # Create an empty array at this point 
        # unless it's already set.

        $data->{$x_axis_value}{$legend_value} = () 
          unless $data->{$x_axis_value}{$legend_value};

        # Add this data point to the array 

        push @{$data->{$x_axis_value}{$legend_value}}, $row->{$self->{data}};

      }

    }

    # Create a table object created from all 
    # this good stuff.

    $self->{table} =  new Relations::Display::Table(-main_label    => $main_label,
                                                    -x_axis_label  => $x_axis_label,
                                                    -legend_label  => $legend_label,
                                                    -x_axis_values => \@x_axis_values,
                                                    -legend_values => \@legend_values,
                                                    -x_axis_titles => \%x_axis_titles,
                                                    -legend_titles => \%legend_titles,
                                                    -data          =>  $data);

  }

  # Return the table

  return $self->{table};

}



# Creates a GD::Graph object from the 
# Display::Table object if it has to, and
# returns the new object.

sub get_graph {

  # Know thyself

  my $self = shift;

  # Unless the graph is already
  # created

  unless ($self->{graph}) {

    # Return nothing unless we can get a 
    # working table.

    return '' unless $self->get_table();

    # Return nothing if the chart, width 
    # or height isn't set.

    return '' unless ($self->{chart} and $self->{width} and $self->{height});

    # Create the graph using the data sent 
    # and the library provided with the 
    # graph.

    my $graph;

    eval "use GD::Graph::$self->{chart};";
    eval "\$graph = new GD::Graph::$self->{chart}($self->{width},$self->{height});";

    # Set the defaults from us.

    foreach my $option (keys %graph_defaults) {

      $graph->set($option => $graph_defaults{$option});

    }

    # Set the defaults from the table.

    $graph->set(title => $self->{table}->{main_label});
    $graph->set(x_label => $self->{table}->{x_axis_label});

    # Set the settings from the user.

    foreach my $option (keys %{$self->{settings}}) {

      $graph->set($option => $self->{settings}->{$option});

    }

    # Now let's build the data structures
    # from our Display::Table object.

    # Create the big whompum data array.

    my @data = ();

    # Push the x axis titles into the first
    # slot of the data array.

    my @x_axis_titles = ();

    my $x_axis_value;

    foreach $x_axis_value (@{$self->{table}->{x_axis_values}}) {

      push @x_axis_titles, $self->{table}->{x_axis_titles}->{$x_axis_value};

    }

    push @data,[@x_axis_titles];

    # Set the legend titles as well.

    my @legend_titles = ();

    foreach my $legend_value (@{$self->{table}->{legend_values}}) {

      push @legend_titles, $self->{table}->{legend_titles}->{$legend_value};

    }

    $graph->set_legend(@legend_titles) if (@legend_titles > 1) or ($legend_titles[0]);

    # Go through all the table data, pushing 
    # it into the data array.

    foreach my $legend_value (@{$self->{table}->{legend_values}}) {

      # Declare an array to hold all the y
      # values.

      my @y_values = ();

      foreach my $x_axis_value (@{$self->{table}->{x_axis_values}}) {

        # Push this data point onto the y
        # values.

        push @y_values,$self->{table}->{data}->{$x_axis_value}{$legend_value};

      }

      # Push these y values onto the data 
      # array.

      push @data,[@y_values];

    }

    # Ok, setting set, data fit, legend sent. 
    # Let's plot the data.

    $graph->plot(\@data);

    # Last up, the vertical and horizontal 
    # lines. 

    if ($self->{vertical} || $self->{horizontal}) {

      # Grab all the specs of the graph now into
      # small variables so the equations made
      # won't be so huge.
     
      my $r = $graph->{right};
      my $b = $graph->{bottom};
      my $l = $graph->{left};
      my $t = $graph->{top};
      my $h = $b - $t;
      my $w = $r - $l;

      # First off, we have to create a hash of 
      # points on which to draw a line. This is 
      # because some lines might be drawn on the 
      # same point, and would overwrite each other. 
      # So we'll make an array for each vertical 
      # space on which one or more lines will be 
      # drawn, in a hash keyed by the point on 
      # which the lines will be drawn.

      my %vertical_points = ();

      # Go through all the keys in the vertical lines 
      # hash. Each key is the data colour number for
      # the legend entry this lines was created under.

      foreach my $vertical_line (keys %{$self->{vertical_lines}}) {

        # Get the x,y values for the line

        my ($x,$y) = $graph->val_to_pixel($self->{vertical_lines}->{$vertical_line},0);

        # Push this legend value onto the array 
        # at the x point.

        push @{$vertical_points{$x}}, $vertical_line;

      }

      # Go through all the vertical points 

      foreach my $x (keys %vertical_points) {

        # Go through all the legend numbers for this 
        # point.

        for (my $i = 0; $i < @{$vertical_points{$x}}; $i++) {

          # Pick a data colour from legend number

          my $c = $graph->set_clr($graph->pick_data_clr($vertical_points{$x}->[$i]));

          # Make three dashes of patterns

          my $d = 3;

          for (my $j = 0; $j < $d; $j++) {

            # Dash the line between colors 

            my $s = $t + $j * $h / $d + $i * ($h) / ($d * (scalar @{$vertical_points{$x}}));
            my $e = $t + $j * $h / $d + ($i + 1) * ($h) / ($d * (scalar @{$vertical_points{$x}}));

            # Draw the vertical line

            $graph->{graph}->line($x, $s, $x, $e, $c);

          }

        }

      }

      # First off, we have to create a hash of 
      # points on which to draw a line. This is 
      # because some lines might be drawn on the 
      # same point, and would overwrite each other. 
      # So we'll make an array for each vertical 
      # space on which one or more lines will be 
      # drawn, in a hash keyed by the point on 
      # which the lines will be drawn.

      my %horizontal_points = ();

      # Go through all the keys in the vertical lines 
      # hash. Each key is the data colour number for
      # the legend entry this lines was created under.

      foreach my $horizontal_line (keys %{$self->{horizontal_lines}}) {

        # Get the x,y values for the line

        my ($x,$y) = $graph->val_to_pixel(0,$self->{horizontal_lines}->{$horizontal_line});

        # Push this legend value onto the array 
        # at the x point.

        push @{$horizontal_points{$y}}, $horizontal_line;

      }

      # Go through all the horizontal points 

      foreach my $y (keys %horizontal_points) {

        # Go through all the legend numbers for this 
        # point.

        for (my $i = 0; $i < @{$horizontal_points{$y}}; $i++) {

          # Pick a data colour from legend number

          my $c = $graph->set_clr($graph->pick_data_clr($horizontal_points{$y}->[$i]));

          # Make four dashes of patterns

          my $d = 4;

          for (my $j = 0; $j < $d; $j++) {

            # Dash the line between colors 

            my $s = $l + $j * $w / $d + $i * ($w) / ($d * (scalar @{$horizontal_points{$y}}));
            my $e = $l + $j * $w / $d + ($i + 1) * ($w) / ($d * (scalar @{$horizontal_points{$y}}));

            # Draw the horizontal line

            $graph->{graph}->line($s, $y, $e, $y, $c);

          }

        }

      }

    }

    $self->{graph} = $graph;

  }

  # Return the graph object.

  return $self->{graph};

}


$Relations::Display::VERSION;

__END__

=head1 NAME

Relations::Display - DBI/DBD::mysql Query Graphing Module

=head1 SYNOPSIS

  # DBI, Relations::Display Script that creates a couple
  # graphs from queries. 

  #!/usr/bin/perl

  use DBI;
  use Relations::Display;

  $dsn = "DBI:mysql:watcher";

  $username = "root";
  $password = '';

  $dbh = DBI->connect($dsn,$username,$password,{PrintError => 1, RaiseError => 0});

  my $Display = new Relations::Display($dbh);

  $Display->add_member(-name     => 'region',
                      -label    => 'Region',
                      -database => 'watcher',
                      -table    => 'region',
                      -id_field => 'reg_id',
                      -select   => {'id'    => 'reg_id',
                                   'label' => 'reg_name'},
                      -from     => 'region',
                      -order_by => "reg_name");

  $Display->add_member(-name     => 'sales_person',
                      -label    => 'Sales Person',
                      -database => 'watcher',
                      -table    => 'sales_person',
                      -id_field => 'sp_id',
                      -select   => {'id'    => 'sp_id',
                                   'label' => "concat(f_name,' ',l_name)"},
                      -from     => 'sales_person',
                      -order_by => ["l_name","f_name"]);

  $Display->add_lineage(-parent_name  => 'region',
                       -parent_field => 'reg_id',
                       -child_name   => 'sales_person',
                       -child_field  => 'reg_id');

  $Display->set_chosen(-label  => 'Sales Person',
                      -ids    => '2,5,7');

  $available = $Display->get_available(-label  => 'Region');

  print "Found $available->{count} Regions:\n";

  foreach $id (@{$available->{ids_arrayref}}) {

    print "Id: $id Label: $available->{labels_hashref}->{$id}\n";

  }

  $dbh->disconnect();

=head1 ABSTRACT

This perl library uses perl5 objects to simplify creating graphs
from MySQL queries. 

The current version of Relations::Display is available at

  http://www.gaf3.com

=head1 DESCRIPTION

=head2 WHAT IT DOES

The Relations::Display object takes in your query through a 
Relations::Query object, along with information pertaining to 
which field values from the query results are to be used in 
creating the graph title, x axis label and titles, legend 
label (not used on the graph) and titles, and y axis data. 

It does this by looping through the query while taking into 
account which fields you want to use for the x axis and legend.
While looping, it figures out which of these fields have all 
the same value throughout the query and which have different
values. The fields with the same values have their values 
placed in the title of the graph, while the fields with 
different values have their values placed in either the x axis
or legend, which is set by the user.

Relations::Display can return either the raw query results in 
the form of a Relations select_matrix() return value, a 
Relations::Display::Table object, or a GD::Graph object. It obtains this
data in stages. Relations::Display gets its matrix data from 
the query object, the Relations::Display::Table data from the matrix
data, and the GD::Graph data from the Relations::Display::Table data.

=head2 CALLING RELATIONS::DISPLAY ROUTINES

All standard Relations::Display routines use both an ordered and named 
argument calling style. This is because some routines have as many as 
fourteen arguments, and the code is easier to understand given a named 
argument style, but since some people, however, prefer the ordered argument 
style because its smaller, I'm glad to do that too. 

If you use the ordered argument calling style, such as

  $display->add('Book,ISBN','Publisher,Category,Discount',{interlaced => 0},'ISBN');

the order matters, and you should consult the function defintions 
later in this document to determine the order to use.

If you use the named argument calling style, such as

  $famimly->add(-x_axis   => 'Book,ISBN',
                -legend   => 'Publisher,Category,Discount',
                -settings => {interlaced => 0},
                -hide     => 'ISBN');

the order does not matter, but the names, and minus signs preceeding them, do.
You should consult the function defintions later in this document to determine 
the names to use.

In the named arugment style, each argument name is preceded by a dash.  
Neither case nor order matters in the argument list.  -name, -Name, and 
-NAME are all acceptable.  In fact, only the first argument needs to begin with 
a dash.  If a dash is present in the first argument, Relations::Display assumes
dashes for the subsequent ones.

=head1 LIST OF RELATIONS::DISPLAY FUNCTIONS

An example of each function is provided in either 'test.pl' and 'demo.pl'.

=head2 new

  $display = new Relations::Display($abstract,
                                    $query,
                                    $chart,
                                    $width,
                                    $height,
                                    $x_axis,
                                    $legend,
                                    $data,
                                    $settings,
                                    $hide,
                                    $vertical,
                                    $horizontal,
                                    $matrix,
                                    $table);

  $display = new Relations::Display(-abstract   => $abstract,
                                    -query      => $query,
                                    -chart      => $chart,
                                    -width      => $width,
                                    -height     => $height,
                                    -x_axis     => $x_axis,
                                    -legend     => $legend,
                                    -data       => $data,
                                    -settings   => $settings,
                                    -hide       => $hide,
                                    -vertical   => $vertical,
                                    -horizontal => $horizontal,
                                    -matrix     => $matrix,
                                    -table      => $table);

Creates creates a new Relations::Display object.

B<$abstract> and B<$query> - 
The Relations::Abstract object to use and the Relations::Query 
object to send to that database handle. These are unneccesary if 
you supply a $matrix or $table value.

B<$chart>, B<$width> and B<$height> - 
The GD::Graph chart type to use, and the width and height
of the GD::Graph. Width and height must be set. There is no
defaults.

B<$x_axis> and B<$legend> - 
The fields to use for the x axis and legend values. Can be 
either a comma delimmitted string, or an array. The names
sent must exactly match the field names in the query.

B<$data> - 
The fields to use for the data values of the graph. The name
sent must exactly match the field name in the query.

B<$settings> - 
GD::Graph settings to to set on the graph object. Must be a
hash of settings to set keyed by the setting name.

B<$hide> - 
The fields to use for the x axis and legend values but to 
hide on the actual display. Can be either a comma delimmitted 
string, an array, or a hash with true values keyed by the 
field names. The names sent must exactly match the field names 
in the query.

B<$vertical> and B<$horizontal> - 
The fields to use for drawing vertical and horizontal lines on 
the graph. These fields must also be in the legend settings
settings, since the color of the lines drawn on the graph will
be the color of the legend thay are connected to. If the x axis
min and max is not set, the vertical lines values indicate on
which x axis title to drawn lines on (fractions work I think),
ie 0=first x axis title, 1-scound, etc. If the x axis min and 
max is set, the vertical lines values indicate the numeric 
graph value on which to drawn lines. 

B<$matrix> - 
Matrix value to use to create the Relations::Display::Table object value
and or GD::Graph value. Uneccessary if is you supply a table 
argument.

B<$table> - 
Relations::Display::Table value to use to create the GD::Graph object. 

=head2 add

  $display->add($x_axis,
                $legend,
                $settings,
                $hide,
                $vertical,
                $horizontal);

  $display->add(-x_axis     => $x_axis,
                -legend     => $legend,
                -settings   => $settings,
                -hide       => $hide,
                -vertical   => $vertical,
                -horizontal => $horizontal);

Adds additional settings to a Relations::Display object. It does 
not override any of the current settings.

B<$x_axis> and B<$legend> - 
The fields to use for the x axis and legend values. Can be 
either a comma delimmitted string, or an array. The names
sent must exactly match the field names in the query.

B<$settings> - 
GD::Graph settings to to set on the graph object. Must be a
hash of settings to set keyed by the setting name.

B<$hide> - 
The fields to use for the x axis and legend values but to 
hide on the actual display. Can be either a comma delimmitted 
string, an array, or a hash with true values keyed by the 
field names. The names sent must exactly match the field names 
in the query.

B<$vertical> and B<$horizontal> - 
The fields to use for drawing vertical and horizontal lines on 
the graph. These fields must also be in the legend settings
settings, since the color of the lines drawn on the graph will
be the color of the legend thay are connected to. If the x axis
min and max is not set, the vertical lines values indicate on
which x axis title to drawn lines on (fractions work I think),
ie 0=first x axis title, 1-scound, etc. If the x axis min and 
max is set, the vertical lines values indicate the numeric 
graph value on which to drawn lines. 

=head2 set

  $display->set($abstract,
                $query,
                $chart,
                $width,
                $height,
                $x_axis,
                $legend,
                $data,
                $settings,
                $hide,
                $vertical,
                $horizontal,
                $matrix,
                $table);

  $display->set(-abstract   => $abstract,
                -query      => $query,
                -chart      => $chart,
                -width      => $width,
                -height     => $height,
                -x_axis     => $x_axis,
                -legend     => $legend,
                -data       => $data,
                -settings   => $settings,
                -hide       => $hide,
                -vertical   => $vertical,
                -horizontal => $horizontal,
                -matrix     => $matrix,
                -table      => $table);

Overrides any current setttings of the Relations::Display
object. It does not add to any of the values.

B<$abstract> and B<$query> - 
The Relations::Abstract object to use and the Relations::Query 
object to send to that database handle. These are unneccesary if 
you supply a $matrix or $table value.

B<$chart>, B<$width> and B<$height> - 
The GD::Graph chart type to use, and the width and height
of the GD::Graph. Width and height must be set. There is no
defaults.

B<$x_axis> and B<$legend> - 
The fields to use for the x axis and legend values. Can be 
either a comma delimmitted string, or an array. The names
sent must exactly match the field names in the query.

B<$data> - 
The fields to use for the data values of the graph. The name
sent must exactly match the field name in the query.

B<$settings> - 
GD::Graph settings to to set on the graph object. Must be a
hash of settings to set keyed by the setting name.

B<$hide> - 
The fields to use for the x axis and legend values but to 
hide on the actual display. Can be either a comma delimmitted 
string, an array, or a hash with true values keyed by the 
field names. The names sent must exactly match the field names 
in the query.

B<$vertical> and B<$horizontal> - 
The fields to use for drawing vertical and horizontal lines on 
the graph. These fields must also be in the legend settings
settings, since the color of the lines drawn on the graph will
be the color of the legend thay are connected to. If the x axis
min and max is not set, the vertical lines values indicate on
which x axis title to drawn lines on (fractions work I think),
ie 0=first x axis title, 1-scound, etc. If the x axis min and 
max is set, the vertical lines values indicate the numeric 
graph value on which to drawn lines. 

B<$matrix> - 
Matrix value to use to create the Relations::Display::Table object value
and or GD::Graph value. Uneccessary if is you supply a table 
argument.

B<$table> - 
Relations::Display::Table value to use to create the GD::Graph object. 

=head2 get_matrix

  $matrix = $display->get_matrix();

Returns the matrix value for a Relations::Display object. If the
matrix value is already set in the display object, it returns that. 
If the matrix value is not set, it attempts to run the query 
with the abstract. If successful, it returns a matrix created from the 
query, and set the matrix value for the display object. If that fails, 
it returns nothing. So, if you create the display object with only 
$table set, this function will fail because neither the abstract, query, 
nor matrix value will be set.

=head2 get_table

  $table = $display->get_table();

Returns the Relations::Display::Table value for a Relations::Display 
object. If the table value is already set in the display object, it 
returns that. If the table value is not set, it calls its own 
get_matrix, and tries to create the table from the returned matrix. 
It'll return the new table object if successful and nothing if it is 
not.

=head2 get_graph

  $graph = $display->get_graph();

Returns the graph value for Relations::Display object. If the
graph value is already set in the display object, it returns that. 
If the graph value is not set, it calls its own get_table, and
tries to create the graph from the returned table. It'll return 
the new graph object if successful and nothing if it is not.

=head1 LIST OF RELATIONS::DISPLAY::TABLE FUNCTIONS

An example of each function is provided in either 'test.pl' and 'demo.pl'.

=head2 new

  $table = new Relations::Display::Table($main_label,
                                         $x_axis_label,
                                         $legend_label,
                                         $x_axis_values,
                                         $legend_values,
                                         $x_axis_titles,
                                         $legend_titles,
                                         $data);

  $table = new Relations::Display::Table(-main_label    => $main_label,
                                         -x_axis_label  => $x_axis_label,
                                         -legend_label  => $legend_label,
                                         -x_axis_values => $x_axis_values,
                                         -legend_values => $legend_values,
                                         -x_axis_titles => $x_axis_titles,
                                         -legend_titles => $legend_titles,
                                         -data          => $data);

Creates creates a new Relations::Display::Table object.

B<$main_label> - 
The main label for the table. String.

B<$x_axis_label> and B<$legend_label> - 
The labels to use for x axis and legend. Strings.

B<$x_axis_values> and B<$legend_values> - 
The values for the x axis and legend. Array refs.

B<$x_axis_titles> and B<$legend_titles> - 
The titles (what's to be displayed) for the x axis and legend. 
Used if there are fields to be hidden. Hash refs keyed
by values arrays.

B<$data> - 
The data for the table. 2D hash ref keyed off the x axis and
legend arrays in that order.

=head1 OTHER RELATED WORK

=head2 Relations

This perl library contains functions for dealing with databases.
It's mainly used as the the foundation for all the other 
Relations modules. It may be useful for people that deal with
databases in Perl as well.

=head2 Relations::Abstract

A DBI/DBD::mysql Perl module. Meant to save development time and code 
space. It takes the most common (in my experience) collection of DBI 
calls to a MySQL databate, and changes them to one liner calls to an
object.

=head2 Relations::Query

An Perl object oriented form of a SQL select query. Takes hash refs,
array refs, or strings for different clauses (select,where,limit)
and creates a string for each clause. Also allows users to add to
existing clauses. Returns a string which can then be sent to a 
MySQL DBI handle. 

=head2 Relations.Admin.inc.php

Some generalized PHP classes for creating Web interfaces to relational 
databases. Allows users to add, view, update, and delete records from 
different tables. It has functionality to use tables as lookup values 
for records in other tables.

=head2 Relations::Family

A Perl query engine for relational databases.  It queries members from 
any table in a relational database using members selected from any 
other tables in the relational database. This is especially useful with 
complex databases; databases with many tables and many connections 
between tables.

=head2 Relations::Display

An Perl module creating GD::Graph objects from database queries. It 
takes in a query through a Relations::Query object, along with 
information pertaining to which field values from the query results are 
to be used in creating the graph title, x axis label and titles, legend 
label (not used on the graph) and titles, and y axis data. Returns a 
GD::Graph object built from from the query.

=head2 Relations::Choice

An Perl CGI interface for Relations::Family, Reations::Query, and 
Relations::Display. It creates complex (too complex?) web pages for 
selecting from the different tables in a Relations::Family object. 
It also has controls for specifying the grouping and ordering of data
with a Relations::Query object, which is also based on selections in 
the Relations::Family object. That Relations::Query can then be passed
to a Relations::Display object, and a graph or table will be displayed.
A working model already exists in a production enviroment. I'd like to 
streamline it, and add some more functionality before releasing it to 
the world. Shooting for early mid Summer 2001.

=cut