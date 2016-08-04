A. Prerequisites
1. install bwa
2. install samtools
3. install SOAP2 and SOAPsnp
4. install iTools
5. install SnpEff and configure your reference

B. How to use this pipeline
###0. download this pipeline
git clone https://github.com/tangerzhang/TillingPipeline.git
###1. perl step1_SplitReads_byP1.pl -a left_reads.fq.gz -b right_reads.fq.gz -l label
###2. perl step2_callSNPforTilling.pl -g ref.fasta 
###3. configure your reference
vim snpEff.config
add "TILING.LitChi.genome : Tiling.LitChi" in the configure file
mkdir data/TILING.LitChi
cd data/TILING.LitChi
cp your.reference.fasta ./sequences.fa
cp your.gff.file ./genes.gff
cd /path/to/snpEff
java -jar snpEff.jar build -gff3 TILING.LitChi
###4. Annotation the SNPs
cd /path/to/your/workdir/
perl step3Annotation.pl -v genome_version -d snpEff_location

C. How to read the results
###1. read the statistics
stat.txt shows the number of mutations in each sample and what types are they.
###2. find large effect SNPs
SNP.anno.vcf shows the effect mutations
We could use this file to find large effect SNPs, e.g. nonsyn mutation

