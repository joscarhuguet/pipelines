#!/bin/sh
#SBATCH --account=plantpath
#SBATCH --qos=plantpath
#SBATCH --job-name=trim_pipe
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=jhuguet@ufl.edu
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --mem=4gb
#SBATCH --time=24:00:00
#SBATCH --output=trim_pipe_%j.out
module load trim_galore
module load cutadapt
for x in `cat list2bowtie`;do trim_galore --max_length 21 -o 21 $x.fastq.gz ;done
for x in `cat list2bowtie`;do trim_galore --max_length 22 -o 22 $x.fastq.gz ;done
for x in `cat list2bowtie`;do trim_galore --max_length 23 -o 23 $x.fastq.gz ;done
for x in `cat list2bowtie`;do trim_galore --max_length 24 -o 24 $x.fastq.gz ;done
