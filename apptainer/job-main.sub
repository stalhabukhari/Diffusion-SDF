#!/bin/bash
#SBATCH --job-name=DIFFSDF-train
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --gpus-per-node=1
#SBATCH --time=2-00:00:00
#SBATCH --output=slurm-logs/slurm-%j-%x.out
#SBATCH --mail-type=END,FAIL,TIME_LIMIT
#SBATCH --mail-user=bukhars@purdue.edu

# ------- slurm job -------
module --force purge
module load gcc/9.3.0
module load cuda/11.7.0
module load utilities
module load monitor
source define.sh

# ------- monitors -------
# track all GPUs (one monitor per host)
monitor gpu percent --csv > slurm-logs/slurm-$SLURM_JOB_ID-gpumem.csv &
GPU_PID=$!
# track all CPUs (one monitor per host)
monitor cpu percent --all-cores > slurm-logs/slurm-$SLURM_JOB_ID-cpuperc.log &
CPU_PID=$!
# ------------------------

# reset time
SECONDS=0

# build container
#bash build.sh

# execute training
RUN_CMD="python train.py -e config-gdiff/stage1_sdf/ \
    -b 16 -w 10 \
    echo 'Done gdiff-stage1'"

RUN_STR="cd $REPO_DIR && $RUN_CMD"
apptainer run --nv -B $REPO_DIR:/code-dir -B $DIFFSDF_DATA_DIR:/data-dir \
    -B $DIFFSDF_MODEL_DIR:/runs-dir diffusionsdf.sif "$RUN_STR"

# ------------------------
# elapsed time
ELAPSEDTIME="$(($SECONDS / 3600)) hrs, $((($SECONDS / 60) % 60)) min and $(($SECONDS % 60)) sec"
echo "**************************************"
echo "--- Elapsed time: $ELAPSEDTIME. ---"

# ------------------------
# shut down the resource monitors
kill -s INT $GPU_PID $CPU_PID
# ------------------------