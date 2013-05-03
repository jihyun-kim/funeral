#!/usr/bin/perl

use v5.10;
use strict;
use Gearman::Worker;
use Net::Ping;

my $worker = new Gearman::Worker;
$worker->job_servers('10.70.62.100:4730');
$worker->register_function(fcheck => \&fcheck);
$worker->work while 1;


sub fcheck {
	my $job = shift;
	
	my $result;
	my $host = $job->arg;

	print "$host\n";
	my $p = Net::Ping->new('icmp');
	if ( $p->ping($host) ) {
	    print "ping succeeded.\n";
	    $result = 1;
	}
	else {
	    print "ping failed\n";
	    $result = 0; 
	}
	
	return $result;

}
