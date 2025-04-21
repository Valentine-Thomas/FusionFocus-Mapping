cd trajectories
for folder in *


do cd $folder
rename 's/_image//' *txt
rename 's/..txt/.txt/' *txt
rename 's/Traj_/Traj_0/' *_?_?.txt
sed -i 's/I/%I/' *.csv
sed -i 's/Rectangle/0/g' *.csv
sed -i 's/none/0/g' *.csv
sed -i 's/ ,M/# ,M/' mCherry*
rename 's/ry_/ry_0/' mCherry_?.*

 
ct=0
for i in *_B.txt
do ct=$((ct+1))
csplit -f Traj-$ct-B- -b "%02d.txt" $i '/%% Trajectory/' {*}
done

ct=0
for i in *_R.txt
do ct=$((ct+1))
csplit -f Traj-$ct-R- -b "%02d.txt" $i '/%% Trajectory/' {*}
done

ct=0
for i in *_G.txt
do ct=$((ct+1))
csplit -f Traj-$ct-G- -b "%02d.txt" $i '/%% Trajectory/' {*}
done

rm *00.txt

for traj in Traj-*
do iconv -f ISO-8859-1 -t UTF8 $traj -o $traj
sed -i 's/\xc2\xa0//g' $traj
sed -i 's/\xA0//g' $traj
sed -i 's/,/./g' $traj
iconv -f UTF-8 -t ASCII $traj -o $traj
done

for i in Traj-*
do var=`egrep -cv '#|^$' $i`
if [ $var -lt 5 ]
then rm -rf $i
else echo "keeping: [$i]" 
fi
done


rename 's/-/_/' Traj*
rename 's/-/_/' Traj*
rename 's/Traj_/Traj_0/' Traj_?_*
rename 's/Traj_/Traj_t/' Traj_??_*

mkdir raw_data
for file in Traj*_?.txt
do mv $file raw_data/$file
echo "$file moved"
done

cd ..
done 