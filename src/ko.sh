#!/bin/bash
#SBATCH -J ko
#SBATCH --mem=8000
#SBATCH -t 20:00:00
#SBATCH --cores=4
#SBATCH --nodes=1
# #SBATCH -o ko.%A_%a.out
# #SBATCH --array=1-960%480
# #SBATCH --array=961-1920%480

# index this run, tell us what the output directory is 
ix=${SLURM_ARRAY_TASK_ID:=1}
outd="/oak/stanford/groups/pritch/users/magu/projects/genetwork/grn-paper/grns/"

mkdir -p $outd

# parameters: total 4 * 4 * 4 * 5 * 6 = 1920
nn=2000

count=0
for rr in 2 4 8 16; do
  for d_o in 1 3 10 30; do
    for di in 10 30 100 300; do
      for kk in 1 5 10 50 100; do 
        for ww in 1 9 40 90 400 900; do 
          count=$(expr $count + 1)
          if [[ $count == $ix ]]; then
            echo $count $ix
            break 5
          fi
        done
      done
    done
  done
done


# go
python3 grn.py --out "${outd}/graph.${ix}" --num-genes $nn --num-groups $kk --w $ww --r $rr --delta-in $di --delta-out $d_o --kos --cores 4
