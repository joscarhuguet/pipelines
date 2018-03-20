#!/bin/sh
#SBATCH --account=plantpath
#SBATCH --qos=plantpath
#SBATCH --job-name=pbalign_pipe
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=jhuguet@ufl.edu
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32gb
#SBATCH --time=20:00:00
#SBATCH --output=pbalign_pipe_%j.out
pwd; hostname; date

module load pacbio/5.0.1 gcc/5.2.0 genomicconsensus/20160523 pbalign/20160921
#module load pacbio/5.0.1
#module load samtools
#module load gcc/5.2.0 pbalign/20160921
#module load pacbio
#bax2bam m170128_011202_42146_c101159992550000001823267305221712_s1_p0.1.bax.h5 \
#m170128_011202_42146_c101159992550000001823267305221712_s1_p0.2.bax.h5 \
#m170128_011202_42146_c101159992550000001823267305221712_s1_p0.3.bax.h5 \
#-o movie --subread --pulsefeatures=DeletionQV,DeletionTag,InsertionQV,IPD,MergeQV,SubstitutionQV,PulseWidth,SubstitutionTag
#pbalign movie.subreads.bam assembly_auto/assembly.contigs.fasta aligned2.bam
samtools faidx assembly_auto/assembly.contigs.fasta
variantCaller --algorithm=best aligned2.bam --referenceFilename=assembly_auto/assembly.contigs.fasta  -j8 -o improved3.fastq  -o improved3.fasta

