#!/usr/bin/perl

use DBI;
use Relations;
use Relations::Query;
use Relations::Abstract;
use Relations::Display;
use Relations::Display::Table;

configure_settings('dsp_test','root','','localhost','3306') unless -e "Settings.pm";

eval "use Settings";

$dsn = "DBI:mysql:mysql:$host:$port";

$dbh = DBI->connect($dsn,$username,$password,{PrintError => 1, RaiseError => 0});

$abs = new Relations::Abstract($dbh);

create_watcher($abs,$database);

$data->{'0'}{'a'} = 'Mercury';
$data->{'0'}{'b'} = 'Venus';
$data->{'0'}{'c'} = 'Earth';
$data->{'1'}{'a'} = 'Mars';
$data->{'1'}{'b'} = 'Jupiter';
$data->{'1'}{'c'} = 'Uranus';
$data->{'2'}{'a'} = 'Saturn';
$data->{'2'}{'b'} = 'Neptune';
$data->{'2'}{'c'} = 'Pluto';

$tbl = new Relations::Display::Table(-main_label     => 'The Main Event',
                                     -x_axis_label   => 'Axis Spin X',
                                     -legend_label   => 'Legend in Mind',
                                     -x_axis_values => ['0','1','2'],
                                     -legend_values => ['a','b','c'],
                                     -x_axis_titles  => {'0' => 'One',
                                                         '1' => 'Two',
                                                         '2' => 'Three'},
                                     -legend_titles  => {'a' => 'Ay',
                                                         'b' => 'Bee',
                                                         'c' => 'Cie'},
                                     -data           =>  $data);
                                      
die "Create Table failed" unless (('The Main Event' eq $tbl->{main_label}) and
                                  ('Axis Spin X' eq $tbl->{x_axis_label}) and
                                  ('Legend in Mind' eq $tbl->{legend_label}) and
                                  ('0 1 2' eq join ' ', @{$tbl->{x_axis_values}}) and 
                                  ('a b c' eq join ' ', @{$tbl->{legend_values}}) and
                                  ('One' eq $tbl->{x_axis_titles}->{'0'}) and
                                  ('Two' eq $tbl->{x_axis_titles}->{'1'}) and
                                  ('Three' eq $tbl->{x_axis_titles}->{'2'}) and
                                  ('Ay' eq $tbl->{legend_titles}->{'a'}) and
                                  ('Bee' eq $tbl->{legend_titles}->{'b'}) and
                                  ('Cie' eq $tbl->{legend_titles}->{'c'}) and
                                  ('Mercury' eq $tbl->{data}->{'0'}{'a'}) and
                                  ('Venus' eq $tbl->{data}->{'0'}{'b'}) and
                                  ('Earth' eq $tbl->{data}->{'0'}{'c'}) and
                                  ('Mars' eq $tbl->{data}->{'1'}{'a'}) and
                                  ('Jupiter' eq $tbl->{data}->{'1'}{'b'}) and
                                  ('Uranus' eq $tbl->{data}->{'1'}{'c'}) and
                                  ('Saturn' eq $tbl->{data}->{'2'}{'a'}) and
                                  ('Neptune' eq $tbl->{data}->{'2'}{'b'}) and
                                  ('Pluto' eq $tbl->{data}->{'2'}{'c'}));

$dsp = new Relations::Display(-query      => 'Why?',
                              -chart      => 'Pretty',
                              -x_axis     => 'Atlas,Shrug',
                              -legend     => 'Mind,Spring',
                              -data       => 'Hanky',
                              -settings   => {'fee' => 7,
                                              'fie' => 'blue'},
                              -abstract   => 'Monkey',
                              -hide       => 'Donkey,Falafel',
                              -vertical   => ['Ding','Dong'],
                              -horizontal => ['Mine','Mom'],
                              -matrix     => 'Has U',
                              -table      => 'Top');

die "Display new failed" unless (($dsp->{query} eq 'Why?') and
                                 ($dsp->{chart} eq 'Pretty') and
                                 ($dsp->{x_axis}->[0] eq 'Atlas') and
                                 ($dsp->{x_axis}->[1] eq 'Shrug') and
                                 ($dsp->{legend}->[0] eq 'Mind') and
                                 ($dsp->{legend}->[1] eq 'Spring') and
                                 ($dsp->{settings}->{fee} == 7) and
                                 ($dsp->{settings}->{fie} eq 'blue') and
                                 ($dsp->{abstract} eq 'Monkey') and
                                 ($dsp->{hide}->{Donkey}) and
                                 ($dsp->{hide}->{Falafel}) and
                                 ($dsp->{vertical}->[0] eq 'Ding') and
                                 ($dsp->{vertical}->[1] eq 'Dong') and
                                 ($dsp->{horizontal}->[0] eq 'Mine') and
                                 ($dsp->{horizontal}->[1] eq 'Mom') and
                                 ($dsp->{matrix} eq 'Has U') and
                                 ($dsp->{table} eq 'Top'));

$dsp->add(-x_axis     => 'Ayn,Rand',
          -legend     => ['Hand','Thing'],
          -settings   => {'foe' => 11,
                          'fum' => 'moon'},
          -hide       => ['Eating','Waffle'],
          -vertical   => 'Candy,Gram',
          -horizontal => 'Dad,Home');

die "Display add failed" unless (($dsp->{query} eq 'Why?') and
                                 ($dsp->{chart} eq 'Pretty') and
                                 ($dsp->{x_axis}->[0] eq 'Atlas') and
                                 ($dsp->{x_axis}->[1] eq 'Shrug') and
                                 ($dsp->{x_axis}->[2] eq 'Ayn') and
                                 ($dsp->{x_axis}->[3] eq 'Rand') and
                                 ($dsp->{legend}->[0] eq 'Mind') and
                                 ($dsp->{legend}->[1] eq 'Spring') and
                                 ($dsp->{legend}->[2] eq 'Hand') and
                                 ($dsp->{legend}->[3] eq 'Thing') and
                                 ($dsp->{settings}->{fee} == 7) and
                                 ($dsp->{settings}->{fie} eq 'blue') and
                                 ($dsp->{settings}->{foe} == 11) and
                                 ($dsp->{settings}->{fum} eq 'moon') and
                                 ($dsp->{abstract} eq 'Monkey') and
                                 ($dsp->{hide}->{Donkey}) and
                                 ($dsp->{hide}->{Falafel}) and
                                 ($dsp->{hide}->{Eating}) and
                                 ($dsp->{hide}->{Waffle}) and
                                 ($dsp->{vertical}->[0] eq 'Ding') and
                                 ($dsp->{vertical}->[1] eq 'Dong') and
                                 ($dsp->{vertical}->[2] eq 'Candy') and
                                 ($dsp->{vertical}->[3] eq 'Gram') and
                                 ($dsp->{horizontal}->[0] eq 'Mine') and
                                 ($dsp->{horizontal}->[1] eq 'Mom') and
                                 ($dsp->{horizontal}->[2] eq 'Dad') and
                                 ($dsp->{horizontal}->[3] eq 'Home') and
                                 ($dsp->{matrix} eq 'Has U') and
                                 ($dsp->{table} eq 'Top'));

$dsp->set(-query      => 'Cuz',
          -chart      => 'Funny',
          -x_axis     => 'Sucked',
          -legend     => 'Visor',
          -data       => 'Panky',
          -settings   => {'giant' => 'yum'},
          -abstract   => 'BeeGee',
          -hide       => 'Pocket',
          -vertical   => ['Dash'],
          -horizontal => ['Family'],
          -matrix     => 'Neo',
          -table      => 'Down');

die "Display set failed" unless (($dsp->{query} eq 'Cuz') and
                                 ($dsp->{chart} eq 'Funny') and
                                 ($dsp->{x_axis}->[0] eq 'Sucked') and
                                 ($dsp->{legend}->[0] eq 'Visor') and
                                 ($dsp->{settings}->{giant} eq 'yum') and
                                 ($dsp->{abstract} eq 'BeeGee') and
                                 ($dsp->{hide}->{Pocket}) and
                                 ($dsp->{vertical}->[0] eq 'Dash') and
                                 ($dsp->{horizontal}->[0] eq 'Family') and
                                 ($dsp->{matrix} eq 'Neo') and
                                 ($dsp->{table} eq 'Down'));

$qry = new Relations::Query(-select => {id    => 'co_id',
                                        label => 'co_name'},
                            -from   => 'county');

$dsp = new Relations::Display(-query    => $qry,
                              -abstract => $abs);

$mtx = $dsp->get_matrix();

die "Display get_matrix failed" unless (($mtx->[0]->{id} == 1) and
                                        ($mtx->[0]->{label} eq 'Rockingham') and
                                        ($mtx->[1]->{id} == 2) and
                                        ($mtx->[1]->{label} eq 'Merrimack') and
                                        ($mtx->[2]->{id} == 3) and
                                        ($mtx->[2]->{label} eq 'Coos') and
                                        ($mtx->[3]->{id} == 4) and
                                        ($mtx->[3]->{label} eq 'Boosely') and
                                        ($mtx->[4]->{id} == 5) and
                                        ($mtx->[4]->{label} eq 'Hazard'));

$qry = new Relations::Query(-select   => {total  => "count(*)",
                                          first  => "'Bird'",
                                          second => "'Count'",
                                          third  => "if(gender='Male','Boy','Girl')",
                                          tao    => "if(gender='Male','Yang','Yin')",
                                          sex    => "gender",
                                          kind   => "sp_name",
                                          id     => "species.sp_id",
                                          fourth => "(species.sp_id+50)",
                                          vert   => "2",
                                          horiz  => "1.5"},
                            -from     => ['bird','species'],
                            -where    => ['species.sp_id=bird.sp_id',
                                          'species.sp_id < 4'],
                            -group_by => ['sp_name','gender','first','second'],
                            -order_by => ['gender','sp_name']);

$dsp = new Relations::Display(-query      => $qry,
                              -abstract   => $abs,
                              -x_axis     => 'first,kind,id,fourth',
                              -legend     => 'second,third,tao,sex,vert,horiz',
                              -data       => 'total',
                              -hide       => 'fourth,third,vert,horiz',
                              -vertical   => 'vert',
                              -horizontal => 'horiz');

$tbl = $dsp->get_table();

die "Display get_table failed" unless (
  ($tbl->{main_label} eq 'Bird - Count') and
  ($tbl->{x_axis_label} eq 'kind - id') and
  ($tbl->{legend_label} eq 'tao - sex') and
  ($tbl->{x_axis_values}->[0] eq 'Blue Jay - 1 - 51') and
  ($tbl->{x_axis_values}->[1] eq 'Robin - 2 - 52') and
  ($tbl->{x_axis_values}->[2] eq 'Sparrow - 3 - 53') and
  ($tbl->{legend_values}->[0] eq 'Girl - Yin - Female') and
  ($tbl->{legend_values}->[1] eq 'Boy - Yang - Male') and
  ($tbl->{x_axis_titles}->{'Blue Jay - 1 - 51'} eq 'Blue Jay - 1') and
  ($tbl->{x_axis_titles}->{'Robin - 2 - 52'} eq 'Robin - 2') and
  ($tbl->{x_axis_titles}->{'Sparrow - 3 - 53'} eq 'Sparrow - 3') and
  ($tbl->{legend_titles}->{'Girl - Yin - Female'} eq 'Yin - Female') and
  ($tbl->{legend_titles}->{'Boy - Yang - Male'} eq 'Yang - Male') and
  ($tbl->{data}->{'Blue Jay - 1 - 51'}{'Girl - Yin - Female'} == 1) and
  ($tbl->{data}->{'Robin - 2 - 52'}{'Girl - Yin - Female'} == 2) and
  ($tbl->{data}->{'Sparrow - 3 - 53'}{'Girl - Yin - Female'} == 1) and
  ($tbl->{data}->{'Blue Jay - 1 - 51'}{'Boy - Yang - Male'} == 3) and
  ($tbl->{data}->{'Robin - 2 - 52'}{'Boy - Yang - Male'} == 1) and
  ($tbl->{data}->{'Sparrow - 3 - 53'}{'Boy - Yang - Male'} == 2)
);

$dsp->set(-chart  => 'bars',
          -width  => 400,
          -height => 400,
          -settings => {y_min_value => 0,
                        y_max_value => 3,
                        y_tick_number => 3,
                        transparent => 0}
          );

$gph = $dsp->get_graph();

$gd = $gph->gd();

open(IMG, '>test.png') or die $!;
binmode IMG;
print IMG $gd->png;

print "\nEverything seems fine\n";

sub create_watcher {

  my $abs = shift;
  my $database = shift;

  $create = "

    DROP DATABASE IF EXISTS $database;
    CREATE DATABASE $database;
    USE $database;

    CREATE TABLE bird (
       bd_id int(10) unsigned NOT NULL auto_increment,
       sp_id int(10) unsigned DEFAULT '0' NOT NULL,
       co_id int(10) unsigned DEFAULT '0' NOT NULL,
       bd_name char(16) NOT NULL,
       gender enum('Female','Male') DEFAULT 'Male' NOT NULL,
       age tinyint(3) unsigned DEFAULT '0' NOT NULL,
       PRIMARY KEY (bd_id),
       UNIQUE bd_name (bd_name),
       KEY sp_id (sp_id)
    );

    INSERT INTO bird (bd_id, sp_id, co_id, bd_name, gender, age) VALUES ( '1', '1', '2', 'Joe', 'Male', '2');
    INSERT INTO bird (bd_id, sp_id, co_id, bd_name, gender, age) VALUES ( '2', '5', '1', 'Sally', 'Female', '3');
    INSERT INTO bird (bd_id, sp_id, co_id, bd_name, gender, age) VALUES ( '3', '7', '4', 'Smiley', 'Female', '1');
    INSERT INTO bird (bd_id, sp_id, co_id, bd_name, gender, age) VALUES ( '4', '5', '4', 'Fred', 'Male', '8');
    INSERT INTO bird (bd_id, sp_id, co_id, bd_name, gender, age) VALUES ( '5', '1', '1', 'Blue Lou', 'Male', '4');
    INSERT INTO bird (bd_id, sp_id, co_id, bd_name, gender, age) VALUES ( '6', '2', '3', 'Red', 'Female', '5');
    INSERT INTO bird (bd_id, sp_id, co_id, bd_name, gender, age) VALUES ( '7', '4', '5', 'Speedy', 'Male', '4');
    INSERT INTO bird (bd_id, sp_id, co_id, bd_name, gender, age) VALUES ( '8', '6', '5', 'African', 'Male', '3');
    INSERT INTO bird (bd_id, sp_id, co_id, bd_name, gender, age) VALUES ( '9', '6', '2', 'Eastern', 'Female', '2');
    INSERT INTO bird (bd_id, sp_id, co_id, bd_name, gender, age) VALUES ( '10', '3', '3', 'Micky-D', 'Male', '6');
    INSERT INTO bird (bd_id, sp_id, co_id, bd_name, gender, age) VALUES ( '11', '3', '4', 'BK', 'Male', '4');
    INSERT INTO bird (bd_id, sp_id, co_id, bd_name, gender, age) VALUES ( '12', '3', '1', 'Wendy', 'Female', '9');
    INSERT INTO bird (bd_id, sp_id, co_id, bd_name, gender, age) VALUES ( '13', '2', '4', 'Round', 'Female', '5');
    INSERT INTO bird (bd_id, sp_id, co_id, bd_name, gender, age) VALUES ( '14', '1', '2', 'Fly Boy', 'Male', '4');
    INSERT INTO bird (bd_id, sp_id, co_id, bd_name, gender, age) VALUES ( '15', '5', '5', 'Mike', 'Male', '4');
    INSERT INTO bird (bd_id, sp_id, co_id, bd_name, gender, age) VALUES ( '16', '2', '3', 'Jonny', 'Male', '1');
    INSERT INTO bird (bd_id, sp_id, co_id, bd_name, gender, age) VALUES ( '17', '4', '4', 'Suzy', 'Female', '5');
    INSERT INTO bird (bd_id, sp_id, co_id, bd_name, gender, age) VALUES ( '18', '4', '2', 'Sammy', 'Female', '7');
    INSERT INTO bird (bd_id, sp_id, co_id, bd_name, gender, age) VALUES ( '19', '6', '5', 'Coco', 'Male', '8');
    INSERT INTO bird (bd_id, sp_id, co_id, bd_name, gender, age) VALUES ( '20', '7', '3', 'Bull', 'Male', '4');
    INSERT INTO bird (bd_id, sp_id, co_id, bd_name, gender, age) VALUES ( '21', '7', '4', 'Gaffer', 'Male', '4');
    INSERT INTO bird (bd_id, sp_id, co_id, bd_name, gender, age) VALUES ( '22', '1', '1', 'Sweety', 'Female', '4');

    CREATE TABLE county (
       co_id int(10) unsigned NOT NULL auto_increment,
       co_name char(32) NOT NULL,
       PRIMARY KEY (co_id),
       UNIQUE co_name (co_name)
    );

    INSERT INTO county (co_id, co_name) VALUES ( '1', 'Rockingham');
    INSERT INTO county (co_id, co_name) VALUES ( '2', 'Merrimack');
    INSERT INTO county (co_id, co_name) VALUES ( '3', 'Coos');
    INSERT INTO county (co_id, co_name) VALUES ( '4', 'Boosely');
    INSERT INTO county (co_id, co_name) VALUES ( '5', 'Hazard');

    CREATE TABLE species (
       sp_id int(10) unsigned NOT NULL auto_increment,
       sp_name char(24) NOT NULL,
       PRIMARY KEY (sp_id),
       UNIQUE sp_name (sp_name)
    );

    INSERT INTO species (sp_id, sp_name) VALUES ( '1', 'Blue Jay');
    INSERT INTO species (sp_id, sp_name) VALUES ( '2', 'Robin');
    INSERT INTO species (sp_id, sp_name) VALUES ( '3', 'Sparrow');
    INSERT INTO species (sp_id, sp_name) VALUES ( '4', 'Flicker');
    INSERT INTO species (sp_id, sp_name) VALUES ( '5', 'Black Bird');
    INSERT INTO species (sp_id, sp_name) VALUES ( '6', 'Swallow');
    INSERT INTO species (sp_id, sp_name) VALUES ( '7', 'Finch')
        
  ";

  @create = split ';',$create;

  foreach $create (@create) {

    $abs->run_query($create);

  }

}

