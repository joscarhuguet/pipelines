#!/bin/sh
#SBATCH --account=plantpath
#SBATCH --qos=plantpath
#SBATCH --job-name=hybrid_job_test      # RaxML
#SBATCH --mail-type=END,FAIL                 # Mail
#SBATCH --mail-user=jhuguet@ufl.edu     # Where to send mail	
#SBATCH --ntasks=8                      # Number of MPI ranks
#SBATCH --cpus-per-task=4               # Number of cores per MPI rank 
#SBATCH --nodes=2                       # Number of nodes
#SBATCH --ntasks-per-node=4             # How many tasks on each node
#SBATCH --ntasks-per-socket=2           # How many tasks on each CPU or socket
#SBATCH --mem-per-cpu=4gb             # Memory per core
#SBATCH --time=024:00:00                 # Time limit hrs:min:sec
#SBATCH --output=hybrid_test_%j.out     # Standard output and error log

pwd; hostname; date
 
module load intel/2016.0.109 openmpi/1.10.2 raxml/8.2.8
 
srun --mpi=pmi2 raxmlHPC-HYBRID-SSE3 -T $SLURM_CPUS_PER_TASK \
      -f a -m GTRGAMMA -s aligment_xoo.phy  \
      -p 12345 -x 12345 -# 100 -n dna
 
date

