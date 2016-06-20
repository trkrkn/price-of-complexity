#!/bin/bash
#make clean
#make

number_agents=4
epsilon=10
beta=3
delta=0
mu=-0.08
sigma=0.05
c=1
recovery=0.5
PD_initial=0.1
notional=0
spread=0
max_iteration=100
error_threshold=0.001
number_shocks=10

max_cap=12

type="credit_all_configurations"
directory="${type}/"
credit_network="${directory}4_banks_cap"
cds_networks="${directory}network_cds"

#clear
start_time=$(date +"%s")

jobID=0

results_directory="01_results/$directory"
rm -f $results_directory/*

for ((cap=0;cap<=$max_cap;cap=cap+1));do
	
	under_score='_'
	all_files="network_files/${directory}4_banks_cap_$cap$under_score*"
	indeces=$(ls -l $all_files | wc -l)
	
	for ((i=0;i<$indeces;i=i+1));do

		index="_index_$i"
		credit_network="${directory}4_banks_cap_$cap$index"
		
		# launch new job HERE!

		name="job_${jobID}"
		nameout="${jobID}.data"
    		#results_directory="01_results/$directory"

		qsub -v PATH -b y -N  $name -o $results_directory/stdout.txt -e $results_directory/stderr.txt -cwd "mkdir -p /tmp/$results_directory; ./run $number_agents $epsilon $beta $delta $mu $sigma $c $recovery $PD_initial $notional $spread $error_threshold $max_iteration $number_shocks $credit_network $cds_networks $cap $i > /tmp/$results_directory/$nameout ; cp /tmp/$results_directory/$nameout $results_directory/"
    
    	jobID=$((jobID+1))

		# result=$(./run $number_agents $epsilon $beta $delta $mu $sigma $c $recovery $PD_initial $notional $spread $error_threshold $max_iteration $number_shocks $credit_network $cds_networks $cap $i)
		# rest='.data'
		# echo $result >> ./01_results/$type$rest
	done
done

conf='.config'
slash='/'
echo $number_agents $epsilon $beta $delta $mu $sigma $c $recovery $PD_initial $notional $spread $error_threshold $max_iteration $number_shocks $credit_network $cds_networks >$results_directory$type$conf

