#!/usr/bin/perl -w

use Getopt::Long;
use YAML qw(LoadFile);
use Net::OpenSSH;

my $y = LoadFile("../config.yml");


my $data = "file.dat";
my $client = 12;

my $result = GetOptions("client=i" => \$client,
                        "file=s" => \$data);

print "room_no=> $client  filename=> $data\n";

my $ip = $y->{ssh}{client}{$client};
my $userid = $y->{ssh}{userid};
my $passwd = $y->{ssh}{passwd};
my $ssh = connect_ssh($ip, $userid, $passwd);
$ssh->scp_put($data);


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



