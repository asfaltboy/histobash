#!/usr/bin/perl 
use DBI;


# Database Setting ###############################
$host = 'roypadina.sytes.net';                   #
$user = 'root';					                   #
$password = 'Xrcd2499!';			                #
$port = '3306';					                   #
# END Of Databse Settings ########################

# HistoBash Settings ############################################
# 0 to Disable , 1 to Enable                                    #
$arg = 0;    #To Enable Argument as Default change to 1.        #
$sudo =0;    #To Enable 'Run as Sudo' as Deafult change to 1.   #
$clear =1;   #To Disable system clear as default set to 0       #
# End of HistoBash Settings #####################################

NewStart:

if (@ARGV) {
	if (@ARGV[0] =~ "-v"){
		print "HistoBash Version 1.1\n";
		exit;
	}
	if (@ARGV[0] =~ "-h"){
		HelpMenu();
		exit;
	}
	if (@ARGV[0] =~ "-S"){
		$sudo =1;
		shift (@ARGV);
		goto NewStart;
	}
	
		if (@ARGV[0] =~ "-s"){
		$sudo =0;
		shift (@ARGV);
		goto NewStart;
	}
	
	if (@ARGV[0] =~ "-A"){
		$arg =1;
		shift (@ARGV);
		goto NewStart;
	}
	
		if (@ARGV[0] =~ "-a"){
		$arg =0;
		shift (@ARGV);
		goto NewStart;
	}
	
	if (@ARGV[0] =~ "-C"){
		$clear =1;
		shift (@ARGV);
		goto NewStart;
	}
	
	if (@ARGV[0] =~ "-c"){
		$clear =0;
		shift (@ARGV);
		goto NewStart;
	}

	$dbh = DBI->connect("DBI:mysql:database=histobash;host=$host;port=$port" , $user, $password );
	$sql = "select * from commands where number = @ARGV[0]" ;
	$sth = $dbh->prepare($sql);
	$sth->execute 	or die "SQL Error: $DBI::errstr\n";
	@row = $sth->fetchrow_array;
	delete $ARGV[0];
	$count =0;
	foreach(@ARGV) {
			@row[2] .= "  @ARGV[$count]";
			$count ++;
	}
	if ($sudo ==1){
		$com = @row[2];
		@row[2] = "sudo $com"; 
		print "Sudo ";
	}
	print "\nRuning  - @row[2]\n ";
	print "\n********************************************HistoBash********************************************************************\n";
	system ( @row[2] );
	print "\nCommand return ";
	system "echo $?";
	print "\n********************************************HistoBash********************************************************************\n";	
	print "\n    		Thanks for Useing HistoBash :-) \n\n ";
	exit;
	}


start:
StartPrint();
sub StartPrint {
	if ($clear == 1) {system "clear";}
	print "\n********************************************HistoBash********************************************************************\n" ;
	print "Wellcome to HistoBash\n\n";
	print "* To go back to main menu press 'M'\n";
	print "* To Enable Argument Press 'A'\n";
	print "* To Disable Arguments Press 'Z'\n" ;
	print "* To Run Command as Sudo press 'S'\n";
	print "* To Disable Sudo run press 'U'\n";
	print "* To Filter Table press 'F'\n";
	print "* To add a command press 'I'\n";
	print "* To delete a command press 'D'\n\n";
	print "Number  | Command | Comment | Subject \n";
}


$dbh = DBI->connect("DBI:mysql:database=histobash;host=$host;port=$port" , $user, $password );
$sql = "select * from commands order by number" ;
$sth = $dbh->prepare($sql);
$sth->execute 	or die "SQL Error: $DBI::errstr\n";
print "\n********************************************HistoBash********************************************************************\n";
while (@row = $sth->fetchrow_array) {
	print "@row[1] | @row[2] | @row[3] | @row[4]\n";

	}
SecondStart:

print "\n********************************************HistoBash********************************************************************\n";
if ($arg == 1) {print "Add Arguments is Enabled.\n";}
if ($sudo ==1) {print "Run as Sudo is Enabled.\n";}
print "Press command number : " ;
$in = <> ;
if ($in =~ "M"){goto start;}
if ($in =~"F"){
	if ($clear == 1) {system "clear";}
	$sql = "select * from commands" ;
	print $filter;
	$sth = $dbh->prepare($sql);
	$sth->execute   or die "SQL Error: $DBI::errstr\n";
	print "\n********************************************HistoBash********************************************************************\n";
	while (@row = $sth->fetchrow_array) {
		$wr =1;
		if (grep {$_ eq @row[4]} @subject) {$wr =0;}
		if ($wr ==1) { 
			push (@subject,@row[4]);			
		}   
	}
	$subnum =0;
	
	foreach (@subject) {
		print "$subnum ) @subject[$subnum]\n";
		$subnum ++;
	}
	print "\n********************************************HistoBash********************************************************************\n";
	print " What Subject you wish to filter by :";
	$filter =<>;
	$sql = "select * from commands where subject = '@subject[$filter]' order by number" ;
	$sth = $dbh->prepare($sql);
	$sth->execute 	or die "SQL Error: $DBI::errstr\n";
	if ($clear == 1) {system "clear";}
	StartPrint();
	print "\n********************************************HistoBash********************************************************************\n";
	print " All '@subject[$filter]' Commands:\n\n";
	while (@row = $sth->fetchrow_array) {
		print "@row[1] | @row[2] | @row[3] | @row[4]\n";
	
	}
	
	goto SecondStart;
}	

if ($in =~"S"){
	$sudo = 1;
	goto start;
}
if ($in =~"U"){
	$sudo =0;
	goto start;
}
if ($in =~"A"){
	$arg = 1;
	goto start;
}
if ($in =~"Z"){
	$arg = 0 ;
	goto start;
}
if ($in =~"D"){
	print "Command Number to DELETE : ";
	$delcommand = <>;
	print "Are you sure you want to DELETE Command Number $delcommand ? (y/n) ";
	$in = <>;
	if ($in =~"y"){
		$sql = "delete from commands where number = $delcommand ";
		$sth = $dbh->prepare($sql);
		$sth->execute 	or die "\nSQL Error: $DBI::errstr\n";
		goto start;
	}
	
}
if($in =~ "I") {

insertStart: 
	print "Enter New Command Number :";
		$number = <>;
	
	$sql = "select * from commands where number = $number" ;
	$sth = $dbh->prepare($sql);
	$sth->execute 	or die "\nSQL Error: $DBI::errstr\n";
	@row = $sth->fetchrow_array;
	if (@row != ""){
		print "\n Command Number $number  is all ready in use.\n";
		goto insertStart;
			
	}
		print "Enter Commands Values as  'command','command_comment','subject' :\n ";
	$insert = <>;
	
	
		$query = "INSERT INTO histobash.commands (number , command ,comment , subject) values ($number , $insert)";
		print "$query";
		$sth = $dbh->prepare($query);
 		$sth->execute 	or die "\nSQL Error: $DBI::errstr\n";
		goto start;
		
}	

$sql = "select * from commands WHERE number=$in" ;
$sth = $dbh->prepare($sql);
$sth->execute or die "\nSQL Error: $DBI::errstr\n";
@row = $sth->fetchrow_array;
if ($arg ==1){
	print "Arguments :";
	$addarg =<>;
	@row[2] .= " $addarg";
}
if ($sudo ==1){
	$com = @row[2];
	@row[2] = "sudo $com"; 
	print "Sudo ";
}

print "\nRuning  - @row[2]\n ";
print "\n********************************************HistoBash********************************************************************\n";
system ( @row[2] );
print "\nCommand return ";
system "echo $?";
print "\n********************************************HistoBash********************************************************************\n";	
print "\n    		Thanks for Useing HistoBash :-) \n\n ";

sub HelpMenu {
print "\n********************************************HistoBash********************************************************************\n	
Arguments :
	
	-v Show HistoBash Version.
	-h Help Menu
	-S/-s  Set 'Run as Sudo' to Enable / Disable.
	-A/-a Set Arguments to Enable / Disable.
	-C/-c Set System Clear to Enable / Disable.	
	-Number(Number as Command number to run) + (Optional arguments for the command)

In Script Options :

	To go back to main menu press 'M'
	To Enable Argument Press 'A'
	To Disable Arguments Press 'Z'
	To Run Command as Sudo press 'S'
	To Disable Sudo run press 'U'
	To Filter Table press 'F'
	To add a command press 'I'
	To delete a command press 'D'
	

";
print "********************************************HistoBash********************************************************************\n";
}
#END	
