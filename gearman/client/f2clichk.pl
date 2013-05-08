#!/usr/bin/perl -w

use strict;
use Gearman::Client;
use YAML qw(LoadFile);

my $client = new Gearman::Client;
$client->job_servers('10.70.62.100:4730');
my $y = LoadFile("../config.yml");


while (1) {
    foreach my $key (keys $y->{ssh}{client}) {
	my $ip = $y->{ssh}{client}{$key};
	my $result_ref = $client->do_task('fcheck', $ip);
	print "IP:$ip STATUS => $$result_ref\n";
	if (!$$result_ref) {
	    print "DisConnect ROOM : $ip\n";
	}
    }
    sleep(15);
}




