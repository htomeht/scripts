#! /usr/bin/env perl
# Script that supports having a set of different display setups
# With a simple inifile describing the setup this script can be called 
# each time a change happens on the setup.
# Works great for docking solutions, connecting a projector and more.
# This script is simple and as such always picks the highest resolution.

# Dependencies:
# perl
#  - Config::IniFiles
#  - Switch
# xrandr
#
use strict;
use warnings;
use Switch;

require Config::IniFiles;

#-----------------------------------------------------------------------
# Get Command Line Arguments
my $config_path = "/home/gabriel/.config/ezdock.ini";

# Manage config
my $config_handler = Config::IniFiles->new( -file => "$config_path");
my $display = $config_handler->val('config', 'display');
my $lock_path = $config_handler->val('config', 'lockfile');
my $log_path = $config_handler->val('config', 'logfile');
my $loglevel = $config_handler->val('config', 'loglevel');
my $user = $config_handler->val('config', 'user');


$ENV{'XAUTHORITY'} = "/home/$user/.Xauthority";
$ENV{'DISPLAY'} = "$display";

my $xrandr_output = `xrandr`;

sub get_connected {
  my @_screens = ();
  while ( $xrandr_output =~ m/(.*) connected/g ) {
    push(@_screens, $1);
  }
  return @_screens;
}

sub get_disconnected {
  my @_screens = ();
  while ( $xrandr_output =~ m/(.*) disconnected [^p\(]/g ) {
    push(@_screens, $1);
  }
  return @_screens;
}

sub get_mode {
  my ($_screen) = @_;

  $xrandr_output =~ /^$_screen connected.*\n\s*(\S*)/m;
  my $mode = $1;

  logger("debug", "Mode for $_screen is $mode");
  return $mode;
}

sub logger {
  my ($type, $output) = @_;

  my %loglevels=(
    "none", 0,
    "error", 1, 
    "warning", 2, 
    "info", 3, 
    "debug", 4
  );

  my $timestamp = "Recently";
  open (my $fh, '>>', $log_path) or die "Could not open '$log_path' $!";
  if ($loglevel le $loglevels{"$type"} ) {
    print $fh "$timestamp - $type: $output\n";
    print "$type: $output\n";
    close $fh;
  }
}

sub kill_screen {
  my ($_screen) = @_;
  logger("debug", "Kill Screen $_screen");
  system("xrandr --output $_screen --off")
}

sub update_screen {
  my ($_count, $_screen) = @_;
  my $mode = get_mode($_screen);
  my $xrandr = "xrandr --output $_screen";
  my $rest = "";
  my $settings = $config_handler->val($_count, $_screen);
  if ($settings =~ m/off/) {
    logger("debug", "Turn off screen $_screen");
    system($xrandr . " --rotate normal --off");
    return " --output $_screen --off"
  }
  my @params = split(';', $settings); 
  foreach my $param (@params) {
    my ($key, $value) = split(':', $param);
    if (defined $value) {
      $rest .= " --$key $value";
    }
    else {
      $rest .= " --$key";
    }
  }
  
  #system("xrandr --output $_screen --mode $mode $rest");
  return " --output $_screen --mode $mode $rest ";
}

sub setup {
  my($_count, @_screens) = @_;
  my $primary;
  
  logger("info", "Number of screens connected: $_count");

  
  my $command = "xrandr";
  foreach my $screen (@_screens) {
    my $tmp = update_screen($_count, $screen);
    
    # Detect primary screen
    if ($tmp =~ m/primary/) {
      $primary = $tmp;
    }
    logger("debug", "Update screen $screen");
    if (defined $tmp) { 
      $command .= $tmp;
    }
  } 
  
  # Reset screens
  my $reset = "xrandr $primary";
  system($reset);

  # Initiate current setup
  system($command);
}
sub main {

  while (1) {
    unless ( -e "$lock_path" ) {
      `touch $lock_path`;
      last;
    }
  }

  my @screens = get_connected();
  my @disconnected = get_disconnected();
  my $count = @screens;

  foreach my $screen (@disconnected) {
    logger("debug", "Disconnecting $screen");
    kill_screen($screen);
    logger("info", "$screen is OFF");
  }

  logger("debug", "Setup stage starting");
  setup($count, @screens);
  `rm $lock_path`;
}

main();
