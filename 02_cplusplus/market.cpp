#include "market.h"

Market::Market(float number_agents, float epsilon, float beta, float delta, float mu, float sigma, float c, float notional, float spread, float recovery, float error_threshold, float max_iteration, float number_shocks, float PD_initial, string network_credit_source, string network_derivatives_source) {
	// Market(number_agents, epsilon, beta, delta, mu, sigma, c, notional, spread, recovery, error_threshold, max_iteration, number_shocks, PD_initial, network_credit_source, network_derivatives_source);

    // printf("New MARKET\n");
    _number_agents      = (int) number_agents;
    // printf(" number agents : %d \n", _number_agents);
    _epsilon            = epsilon;
    _beta               = beta;
    _delta              = delta;
    // printf(" epsilon, beta, delta : %f, %f, %f \n", _epsilon, _beta, _delta);
    _mu                 = mu;
    _sigma              = sigma;
    // printf(" mu, sigma: %f, %f \n", _mu, _sigma);
    _recovery           = recovery;
    _notional           = notional;
    _spread             = spread;
    _PD_initial         = PD_initial;
    // printf(" recovery, notional, spread, pd_init: %f, %f, %f, %Lf \n", _recovery, _notional, _spread, _PD_initial);
    _c                  = c;
    // printf("c = %f\n", c);
    _error_threshold    = error_threshold;
    _max_iteration      = max_iteration;
    // printf(" error_threshold and max_iteration: %f, %f\n", _error_threshold, _max_iteration);
    
    _step_shocks        = (int) number_shocks;

    _network_credit_source     = network_credit_source;
    _network_derivative_source = network_derivatives_source;

    create_banks();

    _netfac = new Netfac(_number_agents, _banks, _network_credit_source);
    _netfac->generate_network();

    _netfac_derivatives = new NetfacDerivatives (_number_agents, _network_derivative_source);
    _netfac_derivatives->generate_network();
    // _netfac_derivatives->present_derivative_net();

    generate_list_shocks();
}

Market::Market(const Market& orig) {
}

Market::~Market() {

    // delete agents
    for (int i=0;i<_banks.size();i++){
        delete _banks[i];
    }
    // delete netfac
    delete _netfac;

    delete _netfac_derivatives;
}

// ----------------------------------------------------
//  INITIALIZATION
// ----------------------------------------------------

void Market::create_banks(){

	for (int i=0;i<_number_agents;i++){
		Agent *a = new Agent(i, _beta, _epsilon, _delta, _recovery, _notional, _spread, _PD_initial);
		_banks.push_back(a);
	}
}

void Market::generate_list_shocks(){
    float step = 2.0/_step_shocks;

    for (float k = 0; k<_step_shocks + 1; k+= 1)
    {
        float shock = float(-1) + k*step;
        _list_shocks.push_back(shock);
    } 
    
    _number_shocks = _list_shocks.size();
}

// ----------------------------------------------------
//  SIMULATION
// ----------------------------------------------------

void Market::start_simulation_recursive(){
 
    int pos = 0 ;
    printf("\t -> Launching Recursive Simulation\n");
    
    recursive_combination(pos);

    for (int i = 0; i< _number_agents; i++)
    {
        _banks[i]->compute_PD();
    }

    compute_systemic_PD();
}

void Market::recursive_combination(int agent_position)
{
    // printf("- Entering Agent %d\n", agent_position);
    int current_agent = agent_position;
    for (int i = 0; i < _number_shocks; i ++)
    {
        float shock = _list_shocks[i];
        _banks[current_agent]->set_shock(shock);
        _banks[current_agent]->set_shock_position(i);
        // printf("    - Shock = %f and Position = %d\n", shock, i);

        if (current_agent+1 == _number_agents)
        {
            // printf("-----------IN-----------------\n");
             string input = "";
            launch_simulation();
            getline(cin, input);
            // printf("-----------OUT----------------\n");
        }
        else
        {
            recursive_combination(agent_position + 1);
        }
    }
}

void Market::launch_simulation()
{
    // printf("        - Simulation Launched:\n");
    // banks compute their state return
    printf("\t\t\t 1) computing returns\n");   
    for (int i = 0; i< _number_agents; i++)
    {

        
        vector <Agent*> borrowers = get_borrowers(_banks[i]);
        if (i == 0)
        {
        printf("\t COMPUTING FOR AGENT %d\n", i);
        printf("\t\tBorrowers of Agent %d: %d\n", i, borrowers[0]->get_id());   }

        vector <Agent*> cds_sellers, cds_reference_sellers;
        get_cds_sellers_and_reference(_banks[i], cds_sellers, cds_reference_sellers);

        vector <Agent*> cds_buyers, cds_reference_buyers;
        get_cds_buyers_and_reference(_banks[i], cds_buyers, cds_reference_buyers);
        
        _banks[i]->compute_state_return(borrowers, cds_sellers, cds_reference_sellers, cds_buyers, cds_reference_buyers, _mu, _sigma);
        if (i == 0)
        {printf("            State Return of Agent %d: %f\n", i, _banks[i]->get_state_return());   }
    }

    vector <float> shock_combination    = get_all_shocks();
    long double probability             = get_probability(shock_combination);
    // printf("- Probability = %LF\n", probability);
    // banks compute their default status
    printf("\t\t\t 2) computing default status\n"); 
    bool all_default = true;
    for (int i = 0; i< _number_agents; i++)
    {
        vector <Agent*> borrowers   = get_borrowers(_banks[i]);
        vector <Agent*> cds_sellers, cds_reference_sellers;
        get_cds_sellers_and_reference(_banks[i], cds_sellers, cds_reference_sellers);
        vector <Agent*> cds_buyers, cds_reference_buyers;
        get_cds_buyers_and_reference(_banks[i], cds_buyers, cds_reference_buyers);

        // _banks[i]->compute_state_return(borrowers, cds_sellers, cds_reference_sellers, cds_buyers, cds_reference_buyers, _mu, _sigma);
        int individual_bank         = _banks[i]->check_default(borrowers, cds_sellers, cds_reference_sellers, cds_buyers, cds_reference_buyers, _mu, _sigma, probability);  

        if (individual_bank != 1)
        {
            all_default = false;
        } 
    }

    check_systemic_default(all_default, probability);
}

void Market::check_systemic_default(bool all_default, float probability){
    int chi = 0;
    if (all_default == true)
    {
        chi = 1;
        // printf("                            SYSTEMIC Default!\n");
    }

    _systemic_chi_history.push_back(chi*probability);
}

void Market::compute_systemic_PD()
{
    long double PD = 0.0;
    for (int i = 0 ; i < _systemic_chi_history.size() ; i++)
    {
        PD += _systemic_chi_history[i];
    }

    _systemic_PD_history.push_back(PD);
    _systemic_chi_history.clear();
}


// ----------------------------------------------------
//  GET AND SET
// ----------------------------------------------------

vector<Agent*> Market::get_borrowers(Agent* agent){

    vector <int> id_borrowers = _netfac->get_out_neighbours_id(agent->get_id());
    vector <Agent*> borrowers;
    for (int j = 0; j < id_borrowers.size(); j++)
    {
        borrowers.push_back(_banks[id_borrowers[j]]);
    }

    return borrowers;

}

vector<float> Market::get_all_shocks()
{
    vector <float> all_shocks;
    for (int i = 0; i<_number_agents; i++)
    {
        all_shocks.push_back(_banks[i]->get_shock());
    }
    return all_shocks;
}

long double Market::get_probability(vector<float> shocks){

    long double probability;
    float total_sum     = _number_shocks * (_c - 1) + pow(_number_shocks, _number_agents);    
    bool diagonal       = true;
    float value         = shocks[0];

    for (int i = 1; i < _number_agents && diagonal == true; i ++)
    {
        if (shocks[i] != value){
            diagonal = false;
        }
    }

    if (diagonal)
    {
        probability = _c / total_sum;
    }
    else
    {
        probability = 1.0/total_sum;
    }
    return probability;
}

long double Market::get_systemic_risk()
{
    return _systemic_PD_history.back();
}

long double Market::get_individual_PD(int id)
{
    return _banks[id]->get_PD();
}

void Market::get_cds_sellers_and_reference(Agent* agent, vector <Agent*> &sellers, vector <Agent*> &references){

    vector <int> id_cds_sellers;
    vector <int> id_cds_reference_sellers;
    _netfac_derivatives->get_sellers_and_reference_id(agent->get_id(), id_cds_sellers, id_cds_reference_sellers);

    for (int j = 0; j < id_cds_sellers.size(); j++)
    {
        sellers.push_back(_banks[id_cds_sellers[j]]);
    }

    for (int j = 0; j < id_cds_reference_sellers.size(); j++)
    {
        references.push_back(_banks[id_cds_reference_sellers[j]]);
    }
}

void Market::get_cds_buyers_and_reference(Agent* agent, vector <Agent*> &buyers, vector <Agent*> &references){

    vector <int> id_cds_buyers;
    vector <int> id_cds_reference_buyers;
    _netfac_derivatives->get_buyers_and_reference_id(agent->get_id(), id_cds_buyers, id_cds_reference_buyers);

    for (int j = 0; j < id_cds_buyers.size(); j++)
    {
        buyers.push_back(_banks[id_cds_buyers[j]]);
    }
    for (int j = 0; j < id_cds_reference_buyers.size(); j++)
    {
        references.push_back(_banks[id_cds_reference_buyers[j]]);
    }
}

// ----------------------------------------------------
//  PRESENT
// -------------------------------------------------------


void Market::present_network(){
    printf("\n The Market Network:\n");
    for (int a=0;a<_banks.size();a++){
        printf("     -Agent[%d] with out neigh: ", _banks[a]->get_id());
        _banks[a]->present_out_neighbours();
        printf("     and in neigh: ");
        _banks[a]->present_in_neighbours();
        printf("\n");
    }
    printf("\n\n");
    _netfac_derivatives->present_derivative_net();

}
    