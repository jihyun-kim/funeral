#!/usr/bin/perl -w

use strict;
use Net::OpenSSH;
use YAML qw(LoadFile);
use File::Temp;
use Config::Std;

my $fh = File::Temp->new();
my $fname = $fh->filename;

my $y = LoadFile("../config.yml");

foreach my $key (keys $y->{ssh}{client}) {
    my $ip = $y->{ssh}{client}{$key};
    my $userid = $y->{ssh}{userid};
    my $passwd = $y->{ssh}{passwd};
    print "room=>$key : $ip : $userid : $passwd  ";

    my $ssh = connect_ssh($ip, $userid, $passwd);
    $ssh->scp_get('/etc/lightdm/lightdm.conf', $fname);
    read_config $fname => my %config;
    print " xserver-command= $config{'SeatDefaults'}{'xserver-command'}\n";
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
