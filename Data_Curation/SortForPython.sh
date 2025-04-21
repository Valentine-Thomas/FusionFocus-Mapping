#!/usr/bin/env bash

echo -e "minimum counter?"
read ct
echo -e "Wich directory should be sorted?"
read directory
echo -e "kmax ="
read kmax
cd $directory

rename 's/_t/_/' *.txt*


mkdir $directory/trajectories
for ((k=1; k<kmax+1; k++))
do for i in {0..9}
do for j in {0..9} 
do echo "$k $i$j counter=$ct"
if [ -f $directory/[$k]-mCherry_[$i][$j].csv ] 
then mkdir $directory/trajectories/cell_$ct
mv -t $directory/trajectories/cell_$ct $directory/[$k]-Traj_[$i][$j]* $directory/[$k]-mCherry_[$i][$j].csv
ct=$((ct+1))
echo "trajectory $i$j for $k has been moved to cell_$ct"
fi
done
done 
done 

