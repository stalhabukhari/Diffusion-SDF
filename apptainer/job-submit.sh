#!/bin/bash
ACCT=zkingsto-n

JOB_MAIN=$(sbatch -A $ACCT --parsable job-train.sub) && \
echo "Submitted batch job $JOB_MAIN" && \
# nero
sbatch -A $ACCT --dependency=afterany:$JOB_MAIN job-nero.sub $JOB_MAIN && \
echo " - Dependency: $JOB_MAIN"
