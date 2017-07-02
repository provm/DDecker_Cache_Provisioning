FILES=$PWD/*
for f in $FILES
do
   echo $f >> app_perf_dump.out
   cat $f | grep 'Summary' >> app_perf_dump.out
done
