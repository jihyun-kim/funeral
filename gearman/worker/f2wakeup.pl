#!/usr/bin/perl -w

use v5.10;
use strict;
use Gearman::Worker;

my $worker = new Gearman::Worker;
$worker->job_servers('10.70.62.100:4730');
$worker->register_function(wake_up => \&wake_up);
$worker->work while 1;



sub wake_up {
	my $job = shift;

	my $room_no = $job->arg;
	print "Wake Up ROOM =>$room_no\n";
	system("curl -d \"trans_ok=Trans record\" http://10.70.62.100:5000/trans/" . $room_no );
	return "workup";


}
