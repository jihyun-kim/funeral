#!/usr/bin/perl -w

use strict;
use Gearman::Worker;
use Net::OpenSSH;
use YAML qw(LoadFile);


my $worker = new Gearman::Worker;
my $y = LoadFile("../../config.yml");
$worker->job_servers('10.70.62.100:4730');
$worker->register_function(pcheck => \&pcheck);
$worker->work while 1;


sub pcheck {
	my $job = shift;
	my $result;
	my $room = $job->arg;


	my $ip = $y->{ssh}{client}{$room};
	my $userid = $y->{ssh}{userid};
	my $passwd = $y->{ssh}{passwd};

	print "$ip $userid $passwd \n";

	my $ssh = connect_ssh($ip, $userid, $passwd);
	my $proc = $ssh->capture("./cproc.sh");
	if ($proc =~ /Runing/) { 
	    print "Runing Chromium!!\n";
	    $result = 1;
	} else {
	    print "Stopped Chromium!!\n";
	    $result = 0;
	}

	return $result;

}


sub connect_ssh {
	my $ssh_client = $_[0];
	my $ssh_user = $_[1];
	my $ssh_passwd = $_[2];

	my $host = $ssh_client;
	my %opts = (
		user => $ssh_user,
		password => $ssh_passwd,
	);

	my	$Rssh = Net::OpenSSH->new($host, %opts);
	$Rssh->error and die "SSH connection failed: " . $Rssh->error;

	return $Rssh;
}
