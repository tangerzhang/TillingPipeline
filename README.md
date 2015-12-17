# SOAPsnp based Tilling analysis pipeline

A. Prerequisites
1. install bwa
2. install samtools
3. install SOAP snp
4. install iTools

B. how to use:
perl step1_SplitReads_byP1.pl -a left_reads.fq.gz -b right_reads.fq.gz -l label
perl step2_callSNPforTilling.pl -g ref.fasta 
