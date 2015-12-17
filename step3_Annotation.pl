#!perl

use Getopt::Std;
getopts "v:d:";


if ((!defined $opt_v) || (!defined $opt_d)) {
    die "************************************************************************
    Usage: perl step3Annotation.pl -v genome_version -d snpEff_path
      -h : help and usage.
      -v : genome version that you configured in your snpEff.config file, 
           e.g. TILING.LitChi in this case
      -d : location that you installed snpEff
           e.g. /share/bioinfo/zhangxt/software/snpEff/snpEff.jar in this case
************************************************************************\n";
}else{
  print "************************************************************************\n";
  print "Version 1.0\n";
  print "Copyright to Tanger, tanger.zhang\@gmail.com\n";
  print "RUNNING...\n";
  print "************************************************************************\n";
        
    }

open(OUT, "> SNP.vcf") or die"";
print OUT "\#CHROM	POS	ID	REF	ALT	QUAL	FILTER	INFO	FORMAT\n";
while(my $file = glob "*.filter.snp"){
	next if (-f $file and -z _);
	$outfile = $file;
	$outfile =~ s/.filter.snp//g;
	$count = 0;
	open(my $fh, $file) or die"";
	while(<$fh>){
		chomp;
		$snp_id = "SNP".$count++;
		@data = split(/\s+/,$_);
		$chrn = $data[0];
		$posi = $data[1];
		$refN = $data[2];
		$altN = $data[3];
		print OUT "$chrn	$posi	$snp_id	$refN	$altN	qual	PASS	$outfile	.\n";
		}
	close $fh;
	}
close OUT;


$cmd = "java -jar $opt_d eff $opt_v SNP.vcf > SNP.anno.vcf";
system($cmd);
system("rm SNP.vcf");
system("rm snpEff*");
