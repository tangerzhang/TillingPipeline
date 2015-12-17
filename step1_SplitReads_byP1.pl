#!/usr/bin/perl 

use Getopt::Std;
getopts "a:b:l:";


if ((!defined $opt_a)|| (!defined $opt_b) || (!defined $opt_l) ) {
    die "************************************************************************
    Usage: perl step1_SplitReads_byP1.pl -a left_reads.fq.gz -b right_reads.fq.gz -l label 
      -h : help and usage.
      -a : left reads
      -b : right reads
      -l : label
************************************************************************\n";
}else{
  print "************************************************************************\n";
  print "Version 1.0\n";
  print "RUNNING...\n";
  print "************************************************************************\n";
        
        }

#my ($index,$fq1,$fq2)=@ARGV;#fastq.gz
my $fq1 = $opt_a;
my $fq2 = $opt_b;
$label  = $opt_l;
my $n1=countReads($fq1);
my $n2=countReads($fq2);
print "$fq1 $n1 reads\n";
print "$fq2 $n2 reads\n";
my $x=0;

while (<DATA>) {
    chomp;
    next if(/^$/);
    next if(/^Sample/);
    my $tmp = $label."_".$_;
    my @line=split("\t",$tmp);
    my $index=$line[4];
    my $index_len=length($index);
    my $filename=$line[0]."_".$line[2]."_".$line[4];
    
    my $out1="$filename.R1.fq.gz";
    my $out2="$filename.R2.fq.gz";
    open(I1,"zcat $fq1 |")||die("$!\n");
    open(I2,"zcat $fq2 |")||die("$!\n");
    open(O1,"| gzip -c > $out1")||die("$!\n");
    open(O2,"| gzip -c > $out2")||die("$!\n");
    my $y=0;
    while(<I1>){
        my $l1=$_;
        my $l2=<I1>;
        my $l3=<I1>;
        my $l4=<I1>;
        my $l5=<I2>;
        my $l6=<I2>;
        my $l7=<I2>;
        my $l8=<I2>;
        
        my $pre_nuc=substr($l2,0,$index_len);
        if ($pre_nuc eq $index) {
            print O1 "$l1","$l2","$l3","$l4";
            print O2 "$l5","$l6","$l7","$l8";
            $y++;
        }
    }
    close I1;
    close I2;
    close O1;
    close O2;
    $x += $y;
    print "$out1 $y reads\n";
}
close(DATA);
print "allocation $x reads\n";

sub countReads{
  my $file=shift;
  my $r=0;
  open(A,"zcat $file |");
  while(<A>){
    chomp;
    next if(/^$/);
    if(/^\+$/){
      $r++;
    }else{
      
    }
  }
  close(A);
  return $r;
}

__DATA__
Sample name	i7 index	i7 Index sequence	i5 Index	i5 Index sequence	Qubit conc. (ng/ml)
A1	1	ATCACG	1	CTCC	16.6
A2	1	ATCACG	2	TGCC	18.5
A3	1	ATCACG	3	AGTA	25.9
A4	1	ATCACG	4	CAGA	12.8
A5	1	ATCACG	5	AACT	12.7
A6	1	ATCACG	6	GCGT	20.5
A7	1	ATCACG	7	TGCGA	11.5
A8	1	ATCACG	8	CGAT	14.6
A9	1	ATCACG	9	CGCTT	17.7
A10	1	ATCACG	10	TCACC	20.8
A11	1	ATCACG	11	CTAGC	17.5
A12	1	ATCACG	12	ACAAG	24.2
B1	1	ATCACG	13	TTCTC	13.9
B2	1	ATCACG	14	AGCCC	14.1
B3	1	ATCACG	15	GTATT	16.7
B4	1	ATCACG	16	CTGTA	12.8
B5	1	ATCACG	17	ATCGT	13.4
B6	1	ATCACG	18	GTAA	24.2
B7	1	ATCACG	19	AGTTGG	13.3
B8	1	ATCACG	20	CCAGCT	12.2
B9	1	ATCACG	21	TTCAGG	11.1
B10	1	ATCACG	22	TAGGAA	25.2
B11	1	ATCACG	23	GCTCTA	26.9
B12	1	ATCACG	24	CCACAA	
C1	1	ATCACG	25	GCTTA	16.9
C2	1	ATCACG	26	CTTCCA	24.6
C3	1	ATCACG	27	GAGATA	16.2
C4	1	ATCACG	28	ATGCAC	23.2
C5	1	ATCACG	29	TATTGGT	15.2
C6	1	ATCACG	30	CTTGCAT	26.1
C7	1	ATCACG	31	ATGAAAC	12.9
C8	1	ATCACG	32	AAAAGTT	15.6
C9	1	ATCACG	33	ACATTCA	21.8
C10	1	ATCACG	34	GAACTCA	19
C11	1	ATCACG	35	GGACCTA	10.4
C12	1	ATCACG	36	GTCGAAT	15.8
D1	1	ATCACG	37	AACGCCT	76.4
D2	1	ATCACG	38	AATATGC	90.9
D3	1	ATCACG	39	ACGACTAC	11.5
D4	1	ATCACG	40	GGTGT	64.3
D5	1	ATCACG	41	TAGCATGC	117
D6	1	ATCACG	42	AGTGGA	49.7
D7	1	ATCACG	43	TAGGCCAT	208
D8	1	ATCACG	44	TGCAAGGA	11.8
D9	1	ATCACG	45	TGGTACGT	19.4
D10	1	ATCACG	46	TCTCAGTC	17.3
D11	1	ATCACG	47	CTGGATAA	17.7
D12	1	ATCACG	48	CGCCTTAT	19.1
E1	2	CGATGT	1	CTCC	11.1
E2	2	CGATGT	2	TGCC	69
E3	2	CGATGT	3	AGTA	69.3
E4	2	CGATGT	4	CAGA	12.7
E5	2	CGATGT	5	AACT	77.2
E6	2	CGATGT	6	GCGT	16.3
E7	2	CGATGT	7	TGCGA	287
E8	2	CGATGT	8	CGAT	67.1
E9	2	CGATGT	9	CGCTT	51.5
E10	2	CGATGT	10	TCACC	103
E11	2	CGATGT	11	CTAGC	84.9
E12	2	CGATGT	12	ACAAG	11.6
F1	2	CGATGT	13	TTCTC	78.3
F2	2	CGATGT	14	AGCCC	12.8
F3	2	CGATGT	15	GTATT	97.7
F4	2	CGATGT	16	CTGTA	19.9
F5	2	CGATGT	17	ATCGT	72.1
F6	2	CGATGT	18	GTAA	15.4
F7	2	CGATGT	19	AGTTGG	51.3
F8	2	CGATGT	20	CCAGCT	62.3
F9	2	CGATGT	21	TTCAGG	57.7
F10	2	CGATGT	22	TAGGAA	13.2
F11	2	CGATGT	23	GCTCTA	20.4
F12	2	CGATGT	24	CCACAA	11.6
G1	2	CGATGT	25	GCTTA	36.3
G2	2	CGATGT	26	CTTCCA	43.6
G3	2	CGATGT	27	GAGATA	59.6
G4	2	CGATGT	28	ATGCAC	45.1
G5	2	CGATGT	29	TATTGGT	74.6
G6	2	CGATGT	30	CTTGCAT	91.2
G7	2	CGATGT	31	ATGAAAC	24.6
G8	2	CGATGT	32	AAAAGTT	64.4
G9	2	CGATGT	33	ACATTCA	101
G10	2	CGATGT	34	GAACTCA	74
G11	2	CGATGT	35	GGACCTA	68.1
G12	2	CGATGT	36	GTCGAAT	73.5
H1	2	CGATGT	37	AACGCCT	48.4
H2	2	CGATGT	38	AATATGC	67.1
H3	2	CGATGT	39	ACGACTAC	72.6
H4	2	CGATGT	40	GGTGT	103
H5	2	CGATGT	41	TAGCATGC	89.2
H6	2	CGATGT	42	AGTGGA	93
H7	2	CGATGT	43	TAGGCCAT	91.4
H8	2	CGATGT	44	TGCAAGGA	60.5
H9	2	CGATGT	45	TGGTACGT	71.8
H10	2	CGATGT	46	TCTCAGTC	76.4
H11	2	CGATGT	47	CTGGATAA	74.1
H12	2	CGATGT	48	CGCCTTAT	56.6

