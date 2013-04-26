
package funeral;
use Dancer ':syntax';
use Template;
use Dancer::Plugin::Database;
use Net::OpenSSH;
use File::Basename;

our $VERSION = '0.1';
# template toolkit
set template => 'template_toolkit';

get '/' => sub {
    redirect '/list';
};

get '/room/:id' => sub {
	my $data = {
		goin => "",
		goin1 => "",
		goin2 => "",
		balin => "",
		jangji => "",
		sangju1 => "",
		sangju2 => "",
		pname => "",
	};

	my $master = database->quick_select('tb_master', { room_no   => params->{id}  });
	if (defined $master) {
		#$data->{goin} = $master->{dname};
		my @goin = split /,/, $master->{dname};
		if(defined $goin[1]) {
			$data->{goin1} = "故 " . $goin[0];
			$data->{goin2} = $goin[1];
			$data->{goin} = "";
		} else {
			$data->{goin} =  "故 " . $master->{dname};
			$data->{goin1} = "";
			$data->{goin2} = "";
		}

		$data->{balin} = $master->{balin};
		$data->{jangji} = $master->{jangji};
		$data->{pname} = $master->{pname};

		$master->{sname} =~ s/\&/&nbsp;&nbsp;/g;
		$master->{sname} =~ s/\%/&nbsp;&nbsp;&nbsp;/g;
		my @sangju = split /,/, $master->{sname};
		my $count = $#sangju + 1;
		if ($count > 14) {
			print "Out of Range!! \n";
			print " @sangju \n";
		} else {
			if ($count <= 7) {
				for(my $i = 0; $i < $count; $i++) {
					$data->{sangju1} = $data->{sangju1} . "<br>" .  $sangju[$i];
					$data->{sangju2} = $data->{sangju2} . "<br>" .  $sangju[$i];
				}
			} else {
				for(my $i = 0; $i < 7; $i++) {
					$data->{sangju1} = $data->{sangju1} . "<br>" . $sangju[$i];
				}
				for(my $i = 7; $i < $count; $i++) {
					$data->{sangju2} = $data->{sangju2} . "<br>" . $sangju[$i];
				}
			}
		}
	    template 'show', {
	    	data => $data,
	    };
	} else		{
		$data->{goin} = "";
		$data->{balin} = "";
		$data->{jangji} = "";
		$data->{sangju1} = "";
		$data->{sangju2} = "";

	    template 'show', {
	    	data => $data,
	    };
	}
};

get '/lobby' => sub {
	my $data = shift;

	my @ref = database->quick_select('tb_master', {}, { order_by => 'room_no' } );
	my $count = $#ref + 1;

	for (my $i = 0; $i <= $#ref; $i++) {
		$ref[$i]->{sname} = convet_sname($ref[$i]->{sname});


		$ref[$i]->{dname} =~ s/\,/<br>/g;

		$data->{$i} = {
			room_no => $ref[$i]->{room_no},
			dname => $ref[$i]->{dname},
			pname => $ref[$i]->{pname},
			balin => $ref[$i]->{balin},
			jangji => $ref[$i]->{jangji},
			sname => $ref[$i]->{sname},
		};
	}

	if ($count <= 4) {
		########   count 4 under
	    template 'lobby_1', {
	    	data => $data,
	    };
	} elsif ($count <= 8) {
		########   count 5 over 8 under
	    template 'lobby_2', {
	    	data => $data,
	    };
	} elsif ($count <= 10) {
		########   count 8 over 10 under
	    template 'lobby_3', {
	    	data => $data,
	    };
	} else {
		########   count 10 over
		print "Out of Range!! \n";
		print " @ref \n";
	}
};



get '/list' => sub {
	my $data;

	my @ref = database->quick_select('tb_master', {}, { order_by => 'room_no' } );
	for (my $i = 0; $i <= $#ref; $i++) {
		my $trans_msg = "";
		if ($ref[$i]->{trans} == 0 ) {
			$trans_msg =  "No Trans";
		} else {
			$trans_msg = "Trans";
		}
		$data->{$i} = {
			room_no => $ref[$i]->{room_no},
			dname => $ref[$i]->{dname},
			pname => $ref[$i]->{pname},
			balin => $ref[$i]->{balin},
			jangji => $ref[$i]->{jangji},
			trans => $trans_msg,
			sname => $ref[$i]->{sname},
		};
	}
    template 'list', {
    	data => $data,
    };
};

get '/edit/:id' => sub {
	my $data;

	my $master = database->quick_select(
						   'tb_master',
						   { room_no   => params->{id}  }
							);
	$data->{room_no} = $master->{room_no};
	$data->{dname} = $master->{dname};
	$data->{pname} = $master->{pname};
	$data->{balin} = $master->{balin};
	$data->{jangji} = $master->{jangji};
	$data->{sname} = $master->{sname};
    template 'edit', {
    	data => $data,
    };
};

post '/edit/:id' => sub {
	my $update_ok = params->{_submit};
	if ($update_ok eq "Submit") {
		my $dname = params->{dname};
		my $pname = params->{pname};
		# file upload
	    my $file = request->upload('file');
	    if (defined $file) {
		  	$file->copy_to('./public/pictures');
		    $pname = basename($file->tempname);
	    }

		my $balin= params->{balin};
		my $jangji= params->{jangji};
		my $trans = "0";
		my $sname= params->{sname};

		database->quick_update(
		          'tb_master',
		          { room_no => params->{id}},
		          { dname => $dname, pname => $pname, balin => $balin, jangji => $jangji, trans => $trans, sname => $sname}
		);
	}
    redirect '/list';
};

get '/delete/:id' => sub {
    template 'delete', {
    };
};

post '/delete/:id' => sub {
	my $room_no = params->{id};

	my $delete_ok = params->{delete_ok};
	if ($delete_ok eq "Delete record") {
		database->quick_delete('tb_master', { room_no => params->{id}});

		my $ssh = connect_ssh($room_no);
		$ssh->capture("/home/pi/chrome.sh ps_on &");
		redirect '/list';
	}
};

get '/trans/:id' => sub {
    template 'trans', {
    };
};

post '/trans/:id' => sub {
	my $room_no = params->{id};
	my $trans_ok = params->{trans_ok};
	if ($trans_ok eq "Trans record") {
		database->quick_update(
		          'tb_master',
		          { room_no => params->{id}},
		          { trans => "1" }
		);
		my $ssh = connect_ssh($room_no);
		$ssh->capture("/home/pi/chrome.sh " . $room_no . " &");
		redirect '/list';
	}
};


get '/add' => sub {
    template 'add', {
    };
};

post '/add' => sub {
	my $room_no = params->{room_no};
	my $add_ok = params->{_submit};
	if ($add_ok eq "Submit") {
		# file upload
	    my $file = request->upload('file');
	  	$file->copy_to('./public/pictures');
	    my $pname = basename($file->tempname);

		database->quick_insert(
		          'tb_master',
		          { room_no => params->{room_no}, dname => params->{dname}, pname => $pname , balin => params->{balin}, jangji => params->{jangji}, sname => params->{sname} }
                 );
		my $ssh = connect_ssh($room_no);
		$ssh->capture("/home/pi/chrome.sh ps_off &");
	}
    redirect '/list';
};

sub convet_sname {
	my $sname = $_[0];

	my @str_sname = split /\,/, $sname;
	for (my $i = 0; $i <= $#str_sname; $i++) {
		if (( ($i + 1) % 5) == 0)  {
			$str_sname[$i] .= "<br>";
		}
	}
	my $ret_sname = join ",", @str_sname;


	$ret_sname =~ s/\&//g;
	$ret_sname =~ s/\%//g;
	$ret_sname =~ s/\,/&nbsp;&nbsp;/g;

	return $ret_sname;
}

sub connect_ssh {
	my $room_no = $_[0];
	my @ip = split /\./, config->{ssh}{server};
	$ip[3] = $ip[3] + $room_no;
	my $sshserver = join ".", @ip;
	my $sshuser = config->{ssh}{userid};
	my $sshpasswd = config->{ssh}{passwd};

	my $host = $sshserver;
	my %opts = (
		user => $sshuser,
		password => $sshpasswd,
	);

	my	$Rssh = Net::OpenSSH->new($host, %opts, timeout => 5, kill_ssh_on_timeout=> 1);
	#$ssh->error and die "SSH connection failed: " . $ssh->error;

	return $Rssh;
}

true;
