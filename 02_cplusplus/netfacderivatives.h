#ifndef _NETFACDERIVATIVES_H
#define	_NETFACDERIVATIVES_H

#include <iostream>
#include <vector>
#include <fstream>
#include <string>
#include <sstream>
#include <cstdlib> 
#include <iterator>

using namespace std;

#include "edgederivative.h"

class EdgeDerivative;

class NetfacDerivatives{

public:

	NetfacDerivatives(int,string);
	NetfacDerivatives(const NetfacDerivatives& orig);
    virtual ~NetfacDerivatives();

    void generate_network();
    void present_derivative_net();

    void get_sellers_and_reference_id(int, vector<int> &, vector<int> &);
	void get_buyers_and_reference_id(int, vector<int> &, vector<int> &);

    // float get_avg_out_degree();
    // vector<int> get_out_neighbours_id(int);

private:

	int _n_nodes;

	string _network_source;

	vector<EdgeDerivative*> _edges;
	
	// float _avg_k;
	// int _topology;

    // vector<Node*> _nodes;
	// vector<float> _edges;

	// bool is_in_list(int, vector<int> &);

};

#endif	/* _NETFACDERIVATIVES_H */