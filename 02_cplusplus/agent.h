#ifndef _AGENT_H
#define	_AGENT_H

#include <iostream>

using namespace std;

#include "node.h"
#include "edgederivative.h"

class Node;
class EdgeDerivative;

class Agent{

public:
    
	Agent(int, float, float, float, float, float, float, float);
	Agent(const Agent& orig);
    virtual ~Agent();

    int get_id();
    long double get_PD();
    float get_state_return();

    void set_node(Node*);

    void set_shock(float);
    void set_shock_position(int);

    int get_shock_position();
    float get_shock();

    void update_shock_position(int);

    int get_out_degree();

    void present_out_neighbours();
    void present_in_neighbours();

    void compute_state_return(vector <Agent*>, vector <Agent*>, vector <Agent*>, vector <Agent*>, vector <Agent*>, float, float);
    int check_default(vector <Agent*>, vector <Agent*>, vector <Agent*>, vector <Agent*>, vector <Agent*>, float, float, long double);

    void compute_PD();

private:

    Node* _node;

	int _id;
    float _beta;
    float _epsilon;
    float _delta;
    float _recovery;
    float _notional;
    float _spread;
    long double _PD_initial;
    float _state_return;
    // float _PD_current;

    int _chi;
    vector <long double> _chi_history;
    vector <long double> _PD_history;

    int _shock_position;
    long double _shock;

    float _equity;

    long double get_interbank_claims_PDs(vector <Agent*>);
    long double get_cds_claims_PDs(vector <Agent*>, vector <Agent*>, vector <Agent*>, vector <Agent*>);
    long double get_interbank_claims_states(vector <Agent*>, float, float);
    long double get_theta_PD(vector <Agent*>, vector <Agent*>, vector <Agent*>, vector <Agent*>, vector <Agent*>, float, float);
    long double get_theta_states(vector <Agent*>, vector <Agent*>, vector <Agent*>, vector <Agent*>, vector <Agent*>, float, float);
    int compute_chi(vector <Agent*>, vector <Agent*>, vector <Agent*>, vector <Agent*>, vector <Agent*>, float, float);

};

#endif	/* _AGENT_H */