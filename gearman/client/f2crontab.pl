#!/usr/bin/perl -w -

use strict;
use Gearman::Client;

my $client = new Gearman::Client;
$client->job_servers('10.70.62.100:4730');
$client->do_task('trans_table', 'run');




