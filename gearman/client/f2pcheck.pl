#!/usr/bin/perl -w

use strict;
use Gearman::Client;

my $client = new Gearman::Client;
$client->job_servers('10.70.62.100:4730');

while (1) {
    #foreach my $key (keys $y->{ssh}{client}) {
    my $key = "1";
	my $result_ref = $client->do_task('pcheck', $key);
	#print "ROOM:$key  STATUS => $$result_ref\n";
	#if (!$$result_ref) {
	#    print "Not Runing Chromium : $key\n";
	#}
    #}
    sleep(15);
}




