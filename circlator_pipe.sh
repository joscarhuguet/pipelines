#!/bin/sh
#SBATCH --account=plantpath
#SBATCH --qos=plantpath
#SBATCH --job-name=polish_pipe
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=jhuguet@ufl.edu
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=6Gb
#SBATCH --time=72:00:00
#SBATCH --output=circlator_pipe_%j.out
pwd; hostname; date
module load gcc/5.2.0
module load circlator

for x in `cat list2polish2`

do

cd $x"_assembly"

cd $x"_erate-0.075"
circlator all "improved_"$x".contigs.fasta" "../"$x"_two_chem/"$x".trimmedReads.fasta.gz" $x"_erate-0.075_circlator"
cd ..

cd $x"_erate-0.039"
circlator all "improved_"$x".contigs.fasta" "../"$x"_two_chem/"$x".trimmedReads.fasta.gz" $x"_erate-0.039_circlator"
cd ..

cd $x"_erate-0.025"
circlator all "improved_"$x".contigs.fasta" "../"$x"_two_chem/"$x".trimmedReads.fasta.gz" $x"_erate-0.025_circlator"
cd ..

cd $x"_auto"
circlator all "improved_"$x".contigs.fasta" "../"$x"_two_chem/"$x".trimmedReads.fasta.gz" $x"_auto_circlator"

cd /ufrc/jhuguet/jhuguet/data/

done
