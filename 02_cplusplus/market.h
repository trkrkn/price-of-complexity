
#ifndef _MARKET_H
#define	_MARKET_H

#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <time.h>
#include <vector>
#include <math.h>
#include <algorithm>
#include <numeric>

using namespace std;

#include "agent.h"
#include "netfac.h"
#include "netfacderivatives.h"
#include "edgederivative.h"

class Agent;
class Netfac;
class NetfacDerivatives;

class Market {

public:

    Market(float, float, float, float, float, float, float, float, float, float, float, float, float, float, string, string);
    Market(const Market& orig);
    virtual ~Market();

    void present_network();
    void start_simulation_recursive();
    long double get_systemic_risk();
    long double get_individual_PD(int);

private:

	int _number_agents;
    int _number_shocks;
    int _step_shocks;
    float _epsilon;
    float _beta;
    float _delta;
    float _mu;
    float _sigma;
    float _c;
    float _recovery;
    float _notional;
    float _spread;
    float _error_threshold;
    float _max_iteration;
    long double _PD_initial;
    string _network_credit_source;
    string _network_derivative_source;
    vector<long double> _systemic_PD_history;
    vector<long double> _systemic_chi_history;
    
    vector <Agent*> _banks;
    Netfac* _netfac;
    NetfacDerivatives* _netfac_derivatives;
    vector <float> _list_shocks;

    void create_banks();
    void generate_list_shocks();
    vector<Agent*> get_borrowers(Agent*);
    void get_cds_sellers_and_reference(Agent*, vector<Agent*>&, vector<Agent*>&);
    void get_cds_buyers_and_reference(Agent*, vector<Agent*>&, vector<Agent*>&);

    void recursive_combination(int);
    float get_shock(int);

    void launch_simulation();

    vector<float> get_all_shocks();
    long double get_probability(vector<float>);

    void compute_systemic_PD();
    void check_systemic_default(bool, float);

	
};

#endif	/* _MARKET_H */
