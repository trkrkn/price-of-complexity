#!/bin/bash

# this code only computes PD for Circle - Star in - Star out - Complete graphs

# previous config: 4 10 10 10 -0.05 0.1 1 0.5 0.1 0.9 0.01 0.00001 10000 10
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

# type="complete_buy_4_banks"
type="credit_stylized"
directory="${type}/"
credit_network="${directory}network_"
cds_networks="${directory}network_cds"

clear
start_time=$(date +"%s")
echo -e "starting at: $(date +"%T")\n"
# for ((cap=0;cap<=$max_cap;cap=cap+1));do
# 	under_score='_'
indeces=4
for ((i=0;i<$indeces+1;i=i+1));do
	index=_index_$i
	# cds_networks='no'
	credit_network="${directory}network_$i"
	# $cds_networks_type$cap$index
	# echo "./run $number_agents $epsilon $beta $delta $mu $sigma $c $recovery $PD_initial $notional $spread $error_threshold $max_iteration $number_shocks $credit_network $cds_networks $cap $i"
	# result=$(./run $number_agents $epsilon $beta $delta $mu $sigma $c $recovery $PD_initial $notional $spread $error_threshold $max_iteration $number_shocks $credit_network $cds_networks $cap $i)
	result=$(./run $number_agents $epsilon $beta $delta $mu $sigma $c $recovery $PD_initial $notional $spread $error_threshold $max_iteration $number_shocks $credit_network $cds_networks 0 0)
	echo "stored result: $result"
	echo""

	# rest='.data'
	# echo $result >> ./01_results/$type$rest
done
# done

# conf='.config'
# echo $number_agents $epsilon $beta $delta $mu $sigma $c $recovery $PD_initial $notional $spread $error_threshold $max_iteration $number_shocks $credit_network $cds_networks >./01_results/$type$conf

finish_time=$(date +"%s")
diff=$(($finish_time-$start_time))
echo -e "\nfinishing at: $(date +"%T")"
echo "Total Running Process = $diff seconds"
