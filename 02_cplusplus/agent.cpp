/*
    Tarik Roukny
    The Price of Complexity

 date: 15/06/2016
*/

#include "agent.h"

Agent::Agent(int id, float beta, float epsilon, float delta, float recovery, float notional, float spread, float PD_initial){
	
	_id                 = id;
    _beta               = beta;
    _epsilon            = epsilon;
    _delta              = delta;
    _recovery 	        = recovery;
    _notional           = notional;
    _spread             = spread;
    _PD_initial         = PD_initial;
    _equity 	        = 1;
    _shock_position     = 0;

    // storing first PD
    _PD_history.push_back(PD_initial);
	
}

Agent::Agent(const Agent& orig) {
}

Agent::~Agent() {

    // printf("Agent %d killed\n", _id);
}

void Agent::compute_state_return(vector <Agent*> borrowers, vector <Agent*> cds_sellers, vector <Agent*> cds_reference_sellers, vector <Agent*> cds_buyers, vector <Agent*> cds_reference_buyers, float mu, float sigma){

    float return_value;
    long double theta     = get_theta_PD(borrowers,cds_sellers, cds_reference_sellers, cds_buyers, cds_reference_buyers, mu, sigma);

    // printf("                        Agent %d --> THETA: %f       and SHOCK: %f\n", _id, theta, _shock);       
    // default
    if (_shock < theta)
    {
        return_value = _recovery;
        // printf("default\n");
    }
    // no default
    else
    {
        return_value = 1;
        // printf("no default\n");
    }
    _state_return = return_value;
    if (_id == 0)
    {printf("                        Agent %d --> THETA: %Lf  and SHOCK: %Lf ---> state: %f \n", _id, theta, _shock, return_value);}
    int a;
    cin >> a;
    // system("pause");
}

long double Agent::get_theta_PD(vector <Agent*> borrowers, vector <Agent*> cds_sellers, vector <Agent*> cds_reference_sellers, vector <Agent*> cds_buyers, vector <Agent*> cds_reference_buyers, float mu, float sigma){

    long double theta;

    long double derivative_value  = 0;

    if (cds_buyers.size() > 0 || cds_sellers.size() > 0)
    {
        derivative_value = get_cds_claims_PDs(cds_sellers, cds_reference_sellers, cds_buyers, cds_reference_buyers);
        if (_id == 0)
        {printf("Derivative value = %Lf\n", derivative_value);}
    }


    long double interbank_value = 0;
    // check if agent has borrowers!
    if (borrowers.size() >0)
    {
        interbank_value   = get_interbank_claims_PDs(borrowers);
        if (_id == 0)
        {printf("Interbank value = %Lf\n", _beta*(1 - interbank_value) );}
    }
    
    theta = (-_epsilon*mu + _beta*(1 - interbank_value) - derivative_value - 1)/(_epsilon * sigma);    

    return theta;
}

long double Agent::get_interbank_claims_PDs(vector <Agent*> borrowers){

    // compute new asset value in the inter bank (expected value of claims to counterparties)
    long double inter_bank_new    = 0.0;
    int degree_out          = borrowers.size();

    
    for (int i = 0; i< degree_out; i ++){

        long double borrower_PD   = borrowers[i]->get_PD();

        float weight        = 1/float(degree_out);
        inter_bank_new     += weight * (1 - borrower_PD  + _recovery * borrower_PD);
    }

    return inter_bank_new;
}

long double Agent::get_cds_claims_PDs(vector <Agent*> cds_sellers, vector <Agent*> cds_reference_sellers, vector <Agent*> cds_buyers, vector <Agent*> cds_reference_buyers){

    // cout <<endl<< "AGENT: "<< _id<< "-----------"<<endl;
    long double derivatives_new       = 0.0;
    int number_cds_contracts    = cds_sellers.size() + cds_buyers.size();
    float weight                = 1/float(number_cds_contracts);
    // buyer case
    for (int i = 0; i < cds_sellers.size(); i++)
    {
        long double reference_PD = cds_reference_sellers[i]->get_PD();
        // cout << "PARAMETERS:  "<<_delta << " " << weight << " " << _notional << " " << reference_PD << " " << _recovery << " " << _spread  <<endl;
        derivatives_new     += _delta * weight * _notional * (reference_PD * (1-_recovery) - _spread * (1 - reference_PD));
        // cout << "BUYS: " <<derivatives_new << endl;
    }
    // seller case
    for (int i = 0; i < cds_buyers.size(); i++)
    {
        long double reference_PD = cds_reference_buyers[i]->get_PD();

        derivatives_new     += _delta * weight * _notional * (-reference_PD * (1-_recovery) + _spread * (1 - reference_PD));
        if (_id == 0)
        {cout << "PARAMETERS:  "<<_delta << " " << weight << " " << _notional << " " << reference_PD << " " << _recovery << " " << _spread  <<endl;
        cout << "SELS: " <<derivatives_new << endl;}       
    }
    cout << endl;

    return derivatives_new;
}

// Sets the new PD
int Agent::check_default(vector <Agent*> borrowers, vector <Agent*> cds_sellers, vector <Agent*> cds_reference_sellers, vector <Agent*> cds_buyers, vector <Agent*> cds_reference_buyers, float mu, float sigma, long double probability_shock){

    int chi = compute_chi(borrowers,cds_sellers, cds_reference_sellers, cds_buyers, cds_reference_buyers, mu, sigma);
    _chi_history.push_back(chi*probability_shock);
    return chi;
}

// Compute whether the agent defaults
int Agent::compute_chi(vector <Agent*> borrowers, vector <Agent*> cds_sellers, vector <Agent*> cds_reference_sellers, vector <Agent*> cds_buyers, vector <Agent*> cds_reference_buyers, float mu, float sigma){

    int chi;
    long double theta     = get_theta_states(borrowers, cds_sellers, cds_reference_sellers, cds_buyers, cds_reference_buyers, mu, sigma);
    // no default
    if (_shock > theta)
    {
        chi = 0;
    }
    // default
    else
    {
        chi = 1;
    }

    return chi;
}

long double Agent::get_theta_states(vector <Agent*> borrowers, vector <Agent*> cds_sellers, vector <Agent*> cds_reference_sellers, vector <Agent*> cds_buyers, vector <Agent*> cds_reference_buyers, float mu, float sigma){

    float theta;
    float derivative_value  = get_cds_claims_PDs(cds_sellers, cds_reference_sellers, cds_buyers, cds_reference_buyers);

    if (borrowers.size() == 0)
    {
        // printf("Agent: %d\n", _id);
        // cout << "no borrowers theta states"<<endl;
        theta = (-_epsilon*mu - derivative_value - 1)/(_epsilon * sigma);
    }
    else
    {
        float interbank_value   = get_interbank_claims_states(borrowers, mu, sigma);
        theta = (-_epsilon*mu + _beta - interbank_value - derivative_value - 1)/(_epsilon * sigma);
    }

    return theta;

}

long double Agent::get_interbank_claims_states(vector <Agent*> borrowers, float mu, float sigma){
    // compute new asset value in the inter bank (expected value of claims to counterparties)
    float inter_bank_new    = 0.0;
    int degree_out          = borrowers.size();
    for (int i = 0; i< degree_out; i ++){

        // state returns are assumed to have been pre-computed
        float borrower_state_return     = borrowers[i]->get_state_return();
        float weight                    = 1/float(degree_out);
        inter_bank_new                 += _beta * weight * borrower_state_return;
    }

    return inter_bank_new;
}

void Agent::compute_PD()
{
    float PD = 0.0;
    for (int i = 0 ; i < _chi_history.size() ; i++)
    {
        PD += _chi_history[i];
    }

    _PD_history.push_back(PD);
    _chi_history.clear();
}

// -----------------------------------------
//  GETS and SETS
// -----------------------------------------

int Agent::get_id(){
	return _id;
}

long double Agent::get_PD(){
    // printf("\nReturning PD: %Lf \n",_PD_history.back() );
	return _PD_history.back();
    // return _PD_initial;
}

void Agent::set_node(Node* n){
	_node = n;
}

int Agent::get_out_degree(){
	return _node->get_out_degree();
}

float Agent::get_state_return(){
    return _state_return;
}

void Agent::set_shock(float shock){
    _shock = shock;
}

void Agent::set_shock_position(int position)
{
    _shock_position = position;
}

float Agent::get_shock()
{
    return _shock;
}

// -----------------------------------------
//  PRESENT
// -----------------------------------------

void Agent::present_out_neighbours(){
	_node->present_out_neighbours();
}

void Agent::present_in_neighbours(){
	_node->present_in_neighbours();
}