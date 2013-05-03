#!/usr/bin/perl

use v5.10;
use strict;
use Gearman::Worker;
# load module
use DBI;
use Net::SFTP::Foreign;

my $worker = new Gearman::Worker;
$worker->job_servers('10.70.62.100:4730');
$worker->register_function(trans_table => \&trans_table);
$worker->work while 1;

sub trans_table {
	my $job = shift;

	my $host = "10.70.116.40";
	my $username = "funeral";
	my $password = "7025";
	my $path = "/Users/funeral/funeral/public/pictures/";

	my $sftp = Net::SFTP::Foreign->new($host, user => $username, password => $password);
	$sftp->die_on_error("Unable to establish FTP connection!");
	$sftp->setcwd($path) or die "unable to change CDW: " . $sftp->error;

	# connect
	my $dbh_org = DBI->connect("DBI:Pg:dbname=postgres;host=10.70.116.40", "postgres", "7025", {'RaiseError' => 1});
	my $dbh_rep = DBI->connect("DBI:Pg:dbname=stvin;host=10.70.62.100",  "stvin", "1234", {'RaiseError' => 1});

	###### select org
	my $sth_org = $dbh_org->prepare("SELECT * FROM tb_master");
	$sth_org->execute();

	my $sth_rep = $dbh_rep->prepare("DELETE FROM tb_master");
	$sth_rep->execute();

	while(my $ref = $sth_org->fetchrow_hashref()) {
		###### insert rep
		my $rows = $dbh_rep->do("INSERT INTO tb_master VALUES (?, ?, ?, ?, ?, ?, ?) ", undef, $ref->{'room_no'} , $ref->{'dname'} , $ref->{'sname'} , $ref->{'pname'} , $ref->{'balin'} , $ref->{'trans'} , $ref->{'jangji'} );
		print "======>INSERT INTO tb_master (ROOM NO=>$ref->{'room_no'})!!\n";
		print "$ref->{'pname'}\n";

		#$sftp->get($ref->{'pname'}, $ref->{'pname'}) or die "get failed: " . $sftp->error;
		my $infile = trim($ref->{'pname'});
		my $outfile = "/home/stvin/funeral/public/pictures/" . $infile;
		$sftp->get($infile, $outfile) or die "get failed: " . $sftp->error;

		print "sftp file get!!!\n";

	}


	# clean up
	$dbh_org->disconnect();
	$dbh_rep->disconnect();

	return $job->arg + 1;

}


sub trim {
	my @result = @_;

	foreach (@result) {
		s/^\s+//;
		s/\s+$//;
	}

	return wantarray ? @result : $result[0];
}
