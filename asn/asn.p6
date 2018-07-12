#! /usr/bin/perl6
# Program to synch NFS contents between AVHS sites.

use strict;


# Global Variables
our $event_path = "testpath/";
our @paths = ();
our $last_update;

sub get_pid ($pid_file) {
  return 1337;
}

sub set_pid ($pid_file, $pid) {
}

sub clear_pid ($pid_file) {
}

sub update_paths {
}

sub daemonize {
  monitor_path $event_path;
}

sub monitor_path ($path) {
  my $monitor_start_time = time;

  my $finish = Promise.new;
  IO::Notification.watch-path($path).act( -> $change {
    my $modified = $path.IO.modified;
    say "$change.path(): $change.event()";
    $finish.keep if $modified < $monitor_start_time + 60;
  });
  await $finish;
}

sub main {
  my $pid = $*PID;
  my $pid_file="asn.pid";

  if ($pid_file.IO.e) {
    $pid=get_pid($pid_file);
    my $ps=shell "ps aux | grep $0";
    
    unless ($ps ~~ m/$pid/) {
      clear_pid($pid_file);
      set_pid($pid_file, $pid);
      daemonize();
      clear_pid($pid_file);
    }
    print("$pid\n");
    exit;
  }
  else {
    print("No running process, starting $pid\n");
    set_pid($pid_file, $pid);
    daemonize();
    clear_pid($pid_file);
    exit;
  }
}

main();
