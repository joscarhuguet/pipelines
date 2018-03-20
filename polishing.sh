#!/bin/sh
#SBATCH --account=plantpath
#SBATCH --qos=plantpath
#SBATCH --job-name=polish_pipe
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=jhuguet@ufl.edu
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32gb
#SBATCH --time=72:00:00
#SBATCH --output=polish_pipe_%j.out
pwd; hostname; date
module load pacbio/5.0.1
#module load pacbio/5.0.1 gcc/5.2.0 genomicconsensus/20160523 pbalign/20160921

for x in `cat list2polish`

do

cd $x"_assembly"

cd $x"_erate-0.075"
pbalign ../movie_merged.subreads.bam $x".contigs.fasta" aligned.bam
samtools faidx $x".contigs.fasta" 
#variantCaller --algorithm=arrow aligned.bam --referenceFilename=$x".contigs.fasta" -j8 -o "improved_arrow_"$x".contigs.fastq" -o "improved_arrow_"$x".contigs.fasta"
variantCaller --algorithm=quiver aligned.bam --referenceFilename=$x".contigs.fasta" -j8 -o "improved_quiver_"$x".contigs.fastq" -o "improved_quiver_"$x".contigs.fasta"
rm aligned.bam
cd ..

cd $x"_erate-0.039"
pbalign ../movie_merged.subreads.bam $x".contigs.fasta" aligned.bam
samtools faidx $x".contigs.fasta" 
#variantCaller --algorithm=arrow aligned.bam --referenceFilename=$x".contigs.fasta" -j8 -o "improved_arrow_"$x".contigs.fastq" -o "improved_arrow_"$x".contigs.fasta"
variantCaller --algorithm=quiver aligned.bam --referenceFilename=$x".contigs.fasta" -j8 -o "improved_quiver_"$x".contigs.fastq" -o "improved_quiver_"$x".contigs.fasta"
rm aligned.bam
cd ..

cd $x"_erate-0.025"
pbalign ../movie_merged.subreads.bam $x".contigs.fasta" aligned.bam
samtools faidx $x".contigs.fasta" 
#variantCaller --algorithm=arrow aligned.bam --referenceFilename=$x".contigs.fasta" -j8 -o "improved_arrow_"$x".contigs.fastq" -o "improved_arrow_"$x".contigs.fasta"
variantCaller --algorithm=quiver aligned.bam --referenceFilename=$x".contigs.fasta" -j8 -o "improved_quiver_"$x".contigs.fastq" -o "improved_quiver_"$x".contigs.fasta"
rm aligned.bam
cd ..

cd $x"_auto"
pbalign ../movie_merged.subreads.bam $x".contigs.fasta" aligned.bam
samtools faidx $x".contigs.fasta" 
#variantCaller --algorithm=arrow aligned.bam --referenceFilename=$x".contigs.fasta" -j8 -o "improved_arrow_"$x".contigs.fastq" -o "improved_arrow_"$x".contigs.fasta"
variantCaller --algorithm=quiver aligned.bam --referenceFilename=$x".contigs.fasta" -j8 -o "improved_quiver_"$x".contigs.fastq" -o "improved_quiver_"$x".contigs.fasta"
rm aligned.bam
cd /ufrc/jhuguet/jhuguet/data/

done
