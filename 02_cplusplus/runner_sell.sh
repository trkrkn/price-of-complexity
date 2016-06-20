#!/bin/bash
make clean
make

number_agents=4
epsilon=10
beta=3
delta=3
mu=-0.03
sigma=0.08
c=1
recovery=0.5
PD_initial=0.1
notional=0.7
spread=0.1
max_iteration=100
error_threshold=0.001
number_shocks=10

max_cap=12

type="circle_buy_4_banks"
credit_type="circle_4_banks"
directory="${type}/"
credit_network="${directory}${credit_type}"
cds_networks_type="${directory}${type}_cds_cap_"

clear
start_time=$(date +"%s")
echo -e "starting at: $(date +"%T")\n"
for ((cap=0;cap<=$max_cap;cap=cap+1));do
	under_score='_'
	indeces=$(ls -l network_files/$cds_networks_type$cap$under_score* | wc -l)
	for ((i=0;i<$indeces;i=i+1));do
		index=_index_$i
		cds_networks=$cds_networks_type$cap$index
		# echo "${cds_networks}"
		echo "./run $number_agents $epsilon $beta $delta $mu $sigma $c $recovery $PD_initial $notional $spread $error_threshold $max_iteration $number_shocks $credit_network $cds_networks $cap $i"
		result=$(./run $number_agents $epsilon $beta $delta $mu $sigma $c $recovery $PD_initial $notional $spread $error_threshold $max_iteration $number_shocks $credit_network $cds_networks $cap $i)
		
		echo "stored result: $result"

		rest='.data'
		echo $result >> ./01_results/$type$rest
	done
done

conf='.config'
echo $number_agents $epsilon $beta $delta $mu $sigma $c $recovery $PD_initial $notional $spread $error_threshold $max_iteration $number_shocks $credit_network $cds_networks >./01_results/$type$conf

finish_time=$(date +"%s")
diff=$(($finish_time-$start_time))
echo -e "\nfinishing at: $(date +"%T")"
echo "Total Running Process = $diff seconds"
