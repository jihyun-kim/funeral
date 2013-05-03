#!/usr/bin/perl
use v5.10;
use strict;
use Gearman::Client;
use DBI;

my $client = new Gearman::Client;
$client->job_servers('10.70.62.100:4730');

while (1) {
	my $result_ref = $client->do_task('fcheck','10.70.62.99');
	print "$$result_ref\n";
	last if (!$$result_ref);
	sleep(15);
}

##### step 2 workup client
print "Check Server Not ping!!!\n";


my $dbh = DBI->connect("DBI:Pg:dbname=stvin;host=localhost",  "stvin", "1234", {'RaiseError' => 1});
my $sth = $dbh->prepare("SELECT * FROM tb_master");
$sth->execute();

while(my $ref = $sth->fetchrow_hashref()) {
	print "room_no=>$ref->{'room_no'} \n";
	my $room_no = $ref->{'room_no'};
	my $result_ref = $client->do_task('wake_up', $room_no);
	print "$$result_ref\n";
}
$dbh->disconnect();



