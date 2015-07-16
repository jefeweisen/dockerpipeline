use strict;
#
# sbtGitPublishLocal.pl
#
# Synopsis:
#
#   sbt can build dependencies from source.  Yet
#   it is not implemented or not obvious how to do so for multi-project sbt
#   builds.  Thus, perl (the fitting language for hacks).
#
use File::Spec;
use File::Spec::Functions;
use File::Path; # qw(make_path remove_tree);

use Getopt::Long;

sub usage()
{
    print STDERR "sbtGitPublishLocal.pl usage:\n\n";
    print STDERR "  perl sbtGitPublishLocal.pl --repo <git repository> --branch <git branch>\n";
    exit(1);
}

my $repo = undef;
my $branch = undef;
my $isVerbose = 0;
my $isDryRun = 0;
GetOptions ("branch=s"   => \$branch,
	    "repo=s"   => \$repo,
	    "verbose"  => \$isVerbose,
            "dryRun" => \$isDryRun)
    or die("Error in command line arguments\n");

$repo or usage();
$branch or usage();

sub systemTeeOut {
    my ($cmd) = @_;
    my @cmd2 = @{$cmd};
    if(1 || $isVerbose || $isDryRun) {
	my $stCmd = join(" ",@cmd2);
	print "$stCmd\n";
    }
    if(!$isDryRun) {
	system(@cmd2);
    }
}

sub publishLocal {
    my ($adirTmp) = @_;
    my $cmdClone = ["git","clone","--branch",$branch,"--",$repo,$adirTmp];
    if(systemTeeOut($cmdClone) != 0) {
	print STDERR "could not git clone";
	return;
    }
    if(!$isDryRun) {
	chdir("$adirTmp") or die "could not change directory";
    }
    if(systemTeeOut(["sbt","clean"]) != 0) {
	print STDERR "could not sbt clean";
	return;
    }
    if(systemTeeOut(["sbt","clean","publishLocal"]) != 0) {
	print STDERR "could not sbt publishLocal";
	return;
    }
}



sub main {
    print "hello\n";
    my $rdirPrev = curdir();
    my $adirPrev = File::Spec->rel2abs($rdirPrev);
    chdir($adirPrev) or die "could not change directory to $adirPrev";

    my $t_tmp = int(time());
    my $adirTmp = File::Spec->catdir($adirPrev, "./tmp_".$t_tmp);

    publishLocal($adirTmp);

    #cleanup
    if(!$isDryRun) {
	chdir($adirPrev) or die "could not change directory";
	if(-e $adirTmp) {
	    File::Path->remove_tree($adirTmp)
	}
    }
}

main();

