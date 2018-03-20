#!/bin/sh
#SBATCH --account=plantpath
#SBATCH --qos=plantpath
#SBATCH --job-name=map_short_pipe
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=jhuguet@ufl.edu
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --mem=4gb
#SBATCH --time=24:00:00
#SBATCH --output=map_short_pipe_%j.out

#module load bowtie2
module load samtools
for i in {21..24}
do
cd $i
	for x in `ls *.fq.gz | sed 's/.fq.gz//g'`
	do
#	bowtie2 -x ../CTVT36 -U $x".fq.gz" -S "${x}"'_'"${i}".sam
	samtools view -bS -o "${x}"'_'"${i}".bam "${x}"'_'"${i}".sam
	samtools sort "${x}"'_'"${i}".bam -o "${x}"'_'"${i}".sorted.bam
	samtools index "${x}"'_'"${i}".sorted.bam
	samtools rmdup "${x}"'_'"${i}".sorted.bam "${x}"'_'"${i}"_rmdup_hits.bam
	samtools view -h -o "${x}"'_'"${i}"_rmdup_hits.sam "${x}"'_'"${i}"_rmdup_hits.bam
	done
cd ..
done
