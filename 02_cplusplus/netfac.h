/*
    Tarik Roukny
    The Price of Complexity

 date: 15/06/2016
*/


#ifndef _NETFAC_H
#define	_NETFAC_H

#include <iostream>
#include <vector>
#include <fstream>
#include <string>
#include <sstream>
#include <cstdlib> 
#include <iterator>

using namespace std;

#include "agent.h"
#include "node.h"

class Agent;
class Node;

class Netfac{

public:

	Netfac(int,vector<Agent*>,string);
	Netfac(const Netfac& orig);
    virtual ~Netfac();

    void generate_network();

    float get_avg_out_degree();
    vector<int> get_out_neighbours_id(int);

private:

	int _n_nodes;

	string _network_source;
	
	float _avg_k;
	int _topology;

    vector<Node*> _nodes;
	vector<float> _edges;

	bool is_in_list(int, vector<int> &);

};

#endif	/* _NETFAC_H */