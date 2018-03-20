#!/bin/sh
#SBATCH --job-name=serial_job_test # job name
#SBATCH --mail-type=END,FAIL # mail events
#SBATCH --mail-user=jhuguet@ufl.edu  # where to send
#SBATCH --nodes=1   # one node 
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1gb
#SBATCH --time=00:05:00  ##time limit
#SBATCH --output=array_%A-%a.out
#SBATCH --array=1-100,105,106,120-125%10  ## array range
#SBATCH --output=parallel_%j.out  #standard error output and error

pwd; hostname; date
module load python
echo This is task $SLURM_ARRAY_TASK_ID
##match the number of processor with the command in the program
