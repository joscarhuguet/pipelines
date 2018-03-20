#!/bin/sh
#SBATCH --account=plantpath
#SBATCH --qos=plantpath
#SBATCH --job-name=kinetics_pipe
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=jhuguet@ufl.edu
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --mem=8gb
#SBATCH --time=24:00:00
#SBATCH --output=kinetcis_pipe_%j.out
pwd; hostname; date
module load pacbio
for x in `cat methyl_list`
do
samtools faidx $x"_circularized_and_start_fixed.fasta"
ipdSummary $x".cmp.h5" --reference $x"_circularized_and_start_fixed.fasta" --numWorkers 12 --identify m6A,m4C --methylFraction --gff "basemods_"$x".gff" --csv "kinetics_"$x".csv"
motifMaker find -f $x"_circularized_and_start_fixed.fasta" -g "basemods_"$x".gff" -o "motifs_"$x".csv"
motifMaker reprocess -f $x"_circularized_and_start_fixed.fasta" -g "basemods_"$x".gff" -m "motifs_"$x".csv" -o "motifs_"$x".gff"
done
