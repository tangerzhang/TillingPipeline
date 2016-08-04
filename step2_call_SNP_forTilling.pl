#!perl

use Getopt::Std;
getopts "g:";


if (!defined $opt_g) {
    die "************************************************************************
    Usage: perl step2_callSNPforTilling.pl -g ref.fasta 
      -h : help and usage.
      -g : ref.fasta
************************************************************************\n";
}else{
  print "************************************************************************\n";
  print "Version 1.0\n";
  print "Copyright to Tanger, tanger.zhang\@gmail.com\n";
  print "RUNNING...\n";
  print "************************************************************************\n";
        
        }
$ref_genome = $opt_g;
$cmd = "cp -s $ref_genome ./ref.fa";
system($cmd);
system("2bwt-builder ref.fa");
system("samtools faidx ref.fa");

$run_SOAPsnp = "#!bin/bash

soap -p 20 -m 300 -x 800 -v 3 -s 50 -g 0 -M 4 -D ref.fa.index -a in1.fq -b in2.fq -o in.mapping.soap -2 tmp.se.soap
iTools SOAPtools msort -k8 -kn9 in.mapping.soap -o in.sort.soap
iTools SOAPtools rmdup -InPut in.sort.soap -OutPut out.rmdup.soap
gunzip out.rmdup.soap.gz
soapsnp -i out.rmdup.soap -d ref.fa -o out.cns -t -u -q -L 150
iTools CNStools ExtractCns -InPut out.cns -OutPut SNP.cns
gunzip SNP.cns.gz
iTools CNStools FilterCns -InPut SNP.cns -OutPut SNP.filter1.cns -MinQual 20 -MaxCP 2 -MinDist 5 -MinDepth 10 -MaxDepth 150 
gunzip SNP.filter1.cns.gz
awk '\$15>0.05' SNP.filter1.cns > SNP.filter2.cns

iTools SOAPtools Soap2Sam -InSoap in.mapping.soap -OutSam in.mapping.sam -Pair
gunzip in.mapping.sam.gz
samtools view -bt ref.fa.fai in.mapping.sam > in.mapping.bam
samtools sort -@ 10 -o in.sort.bam in.mapping.bam

";

open(OUT, "> run_SOAPsnp.sh") or die"";
print OUT "$run_SOAPsnp\n";
close OUT;

while(my $file = glob "*.R1.fq.gz"){
	if($file =~ /(.*).R1.fq.gz/){
		$ind = $1;
		$fq_1 = $1.".R1.fq.gz";
		$fq_2 = $1.".R2.fq.gz";
		$cmd = "cp $fq_1 in1.fq.gz"; system($cmd);
		$cmd = "cp $fq_2 in2.fq.gz"; system($cmd);
		system("gunzip in1.fq.gz"); system("gunzip in2.fq.gz"); 
		system("sh run_SOAPsnp.sh");
		$bam_final = $ind.".mapping.bam";
		system("mv in.sort.bam ./$bam_final");
		$outfile = $ind.".filter.snp";
		system("mv SNP.filter2.cns ./$outfile");
		system("rm *.soap"); 
#		system("rm *.bam");
		system("rm in*"); system("rm *cns")
		}
	}

###statistics

my %iupac = (
  "A" => "a a",
  "C" => "c c",
  "G" => "g g",
  "T" => "t t",
  "M" => "a c", 
  "K" => "g t",   
  "Y" => "c t",
  "R" => "a g", 
  "W" => "a t", 
  "S" => "c g",
  "-" => "- -",
  "N" => "N N"
);

while(my $file = glob "*.snp"){
	$sample = $file;
	$sample =~ s/.filter.snp//g;
	open(my $fh, $file) or die"";
	while(<$fh>){
		chomp;
		($refN, $altN) = (split/\s+/,$_)[2,3];
		($a,$b) = split(/\s+/,$iupac{$altN});
		$a = uc $a; $b = uc $b;
    $altc = ($a eq $refN)?$b:$a;
    $type = $refN."->".$altc;
    $typedb{$type} = 1;
    $infordb{$sample}->{$type} += 1;
#    print "$refN	$altN	$iupac{$altN}	$altc\n";
		}
	close $fh;
	}
	
	foreach $sample(sort keys %infordb){
		foreach $type(sort keys %typedb){
			$infordb{$sample}->{$type} = 0 if(!exists($infordb{$sample}->{$type}));
			}
		}

open(OUT, "> stat.txt") or die"";		
	print OUT "sample	";
	foreach $type(sort keys %typedb){
		print OUT "$type	";
		}
	print OUT "total\n";
	
	foreach $sample(sort keys %infordb){
		print OUT "$sample	";
		$sum_num = 0;
		foreach $type(sort keys %typedb){
			print OUT "$infordb{$sample}->{$type}	";
			$sum_num += $infordb{$sample}->{$type};
			}
		print OUT "$sum_num\n";
		}
close OUT;

system("rm run_SOAPsnp.sh");
system("rm ref.fa*");