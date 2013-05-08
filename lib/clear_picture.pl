#!/usr/bin/perl -w

use DBI;
use strict;

my $dbh = DBI->connect( "DBI:Pg:dbname=postgres;host=localhost", "postgres", "7025" ) || die "Cannot connect: $DBI::errstr";
my $query = "SELECT * FROM tb_master ORDER BY room_no DESC";
my $query_handle = $dbh->prepare($query);
$query_handle->execute();
$query_handle->bind_columns(\my($room_no, $dname, $sname, $pname, $balin, $trans, $jangji));

my @pictures;

while($query_handle->fetch()) {
   push @pictures, trim($pname);
}
my $dir = "/Users/funeral/funeral/public/pictures/";
chdir $dir or die "Cannot chroot to $dir: $!\n";
my @files = glob("*.*");
my %hash = map { ($_, 1)} @files;


foreach my $key (@pictures) {
    delete $hash{$key};
}

my @result = sort keys %hash;

foreach my $res (@result) {
    print "delete file : $res\n";
}

unlink @result;

$query_handle->finish;
undef($dbh);

sub trim {
	my @result = @_;
	foreach (@result) {
		s/^\s+//;
		s/\s+$//;
	}
	return wantarray ? @result : $result[0];
}