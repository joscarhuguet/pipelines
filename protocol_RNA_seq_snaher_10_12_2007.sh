#!/bin/bash
#SBATCH --account=plantpath
#SBATCH --qos=plantpath
#SBATCH --job-name=pbalign
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=jhuguet@ufl.edu
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=32g
#SBATCH --time=20:00:00
#SBATCH --output=protocol_RNA_seq_snaher_10_12_2007_%j.log
module load  cufflinks/2.2.1.1
#change gff3 format to gtf using gffread from cufflinks package
#gffread all.gff3.txt -T -o all.gtf
gffread xa21.gff3 -T -o xa21.gtf
#ready to obtain raw counts from genes features using Hseq-count
#module load samtools
#module load htseq/0.6.1p1
#samtools sort -n C_41_rmdup_hits.bam -o C_41_rmdup_sorted.bam
#htseq-count -f bam -s no -r name -i gene_name C_41_rmdup_sorted.bam all.gtf  > HTSeq2-count_C_41.txt
#module load cufflinks/2.2.1.1
module load subread/1.5.3
for x in `cat list`
do
cd $x"_out"
#featureCounts -T 6 -p -B -a all.gtf  -o $x"_all_counts.txt" $x"_hits.bam"
featureCounts -t exon -T 6 -g gene_id -p -B -a /ufrc/jhuguet/jhuguet/data/snaher/xa21_2.gtf  -o $x"_counts.txt" $x"_rmdup_hits.bam"
cut -f 2,7 $x"_counts.txt" | grep U72723 > $x"_counts_file_trans.txt"
#cufflinks -p 8 --library-type fr-unstranded -o $x"_cufflinks_out_gtf" -G all.gtf $x"_rmdup_hits.bam"
cd ..
done
