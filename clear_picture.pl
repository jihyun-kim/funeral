#!/usr/bin/perl

use DBI;
use strict;

my $dbh = DBI->connect( "dbi:SQLite:dbname=funeral.db" ) || die "Cannot connect: $DBI::errstr";
my $query = "SELECT * FROM tb_master ORDER BY room_no DESC";
my $query_handle = $dbh->prepare($query);
$query_handle->execute();
$query_handle->bind_columns(\my($room_no, $dname, $sname, $pname, $balin, $trans, $jangji));

my @pictures;
while($query_handle->fetch()) {
   push @pictures, $pname;
}
my $dir = "./public/pictures/";
chdir $dir or die "Cannot chroot to $dir: $!\n";
my @files = glob("*.*");
my %hash = map { ($_, 1)} @files;
foreach my $key (@pictures)
{
		delete $hash{$key};
}
my @result = sort keys %hash;
unlink @result;

$query_handle->finish;
undef($dbh);