#!/bin/sh
#SBATCH --account=plantpath
#SBATCH --qos=plantpath
#SBATCH --job-name=junli_pipe
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=jhuguet@ufl.edu
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=6
#SBATCH --mem=10gb
#SBATCH --time=24:00:00
#SBATCH --output=junli_pipe_%j.out
pwd; hostname; date
module load gcc/5.2.0
module load trinity/r20170205-2.4.0
module load R
module load perl
#run_DE_analysis.pl --matrix merged_counts.txt --method edgeR --output edgeR_selected --samples_file my_samples.txt --contrasts contrats_table
#run_DE_analysis.pl --matrix merged_counts.txt --method edgeR --output edgeR_selected --samples_file my_samples.txt --contrasts contrast_table
run_DE_analysis.pl --matrix merged_counts.txt --method DESeq2 --output Deseq_selected2 --samples_file my_samples.txt --contrasts contrast_table2

#run_DE_analysis.pl --matrix merged_counts.txt --method DESeq2 --output Deseq_selected --samples_file my_samples.txt --contrasts contrast_table
#PtR --matrix merged_counts.txt -s my_samples.txt --log2 --prin_comp prin_comp 3
#--contrasts contrast_table  --sample_cor_matrix
