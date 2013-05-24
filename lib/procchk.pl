#!/usr/bin/perl -w


use Net::OpenSSH;
use YAML qw(LoadFile);

my $y = LoadFile("../config.yml");

pcheck("1");
pcheck("2");
pcheck("3");
pcheck("5");
pcheck("6");
pcheck("7");
pcheck("8");
pcheck("9");
pcheck("10");
pcheck("11");


sub pcheck {
	my $room = $_[0];
	my $result;

	my $ip = $y->{ssh}{client}{$room};
	my $userid = $y->{ssh}{userid};
	my $passwd = $y->{ssh}{passwd};

	print "ROOM:$room $ip\t";

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
