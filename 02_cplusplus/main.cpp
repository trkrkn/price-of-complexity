#include <stdlib.h>
#include <iostream>
// #include <iomanip>
// #include <fstream>
#include <stdio.h>
#include <string>
// #include <sstream>
#include <cmath>
#include "market.h"
// #include "agent.h"

using namespace std;
// #include <sys/stat.h>

// example of command:
//  ./run 2 5 5 5 0.1 0.2 0 0.5 0.5 1 0.2 1000 0.0001 2 network_test_3
// ./run 2 5 5 5 0.1 0.2 0 1 0 0.5 0.5 10000 0.00001 0.5 network_test_3 network_test_3
// ./run 4 5 5 5 0.1 0.2 0 1 0 0.5 0.5 10000 0.00001 4 network_test_2 network_test_2

int main( int argc, char* argv[] ) {

    if(argc == 1){
        cout << "please put something" << endl;
    }
    else 
    {
        srand((unsigned)time(0));
    	// 1 - taking the parameters

        // number of agents	
    	float number_agents 	= atof(argv[1]);
        // epsilon
        float epsilon 			= atof(argv[2]);
        // beta 
        float beta	 			= atof(argv[3]);
        // delta
        float delta             = atof(argv[4]);
        // mu
        float mu                = atof(argv[5]);
        // sigma
        float sigma 			= atof(argv[6]);
        // c (correlation)
        float c 				= atof(argv[7]);
        // recovery
        float recovery 			= atof(argv[8]);
        // PD_initial
        float PD_initial	    = atof(argv[9]);
        // notional
        float notional          = atof(argv[10]);
        // spread
        float spread            = atof(argv[11]);
        // error_threshold
        float error_threshold 	= atof(argv[12]);
        // max_iteration
        float max_iteration     = atof(argv[13]);
        // number of shocks
        float number_shocks     = atof(argv[14]);
        // network source (file or generate)
        string network_credit_source 	  = argv[15];
        // network source derivative
        string network_derivatives_source = argv[16];
        
        Market *market= new Market(number_agents, epsilon, beta, delta, mu, sigma, c, notional, spread, recovery, error_threshold, max_iteration, number_shocks, PD_initial, network_credit_source, network_derivatives_source);

        // market->present_network();

        market->start_simulation_recursive();

        long double old_systemic_PD = market->get_systemic_risk();
        // long double individual_PD   = market->get_individual_PD(0);

        int step = 0;
        bool convergence = false;
        while (step < max_iteration && convergence == false)
        {
            printf ("\n       ---     ITERATION %d ---- \n\n", step+1);
            

            market->start_simulation_recursive();



            long double new_systemic_PD = market->get_systemic_risk();

            long double error           = abs(old_systemic_PD - new_systemic_PD);

            cout <<endl<<endl<<endl<< "old Psys = " << old_systemic_PD << " and new Psys "<< new_systemic_PD << " error = " << error << " aaand threshold is= " << error_threshold<< endl;
            cout << argv[17] <<','<<argv[18]<<','<<old_systemic_PD  <<','<< market->get_individual_PD(0) << ','<< market->get_individual_PD(1) <<','<< market->get_individual_PD(2)<<','<< market->get_individual_PD(3) <<endl;


            if ( error < error_threshold)
            {
                convergence = true;
            }

            old_systemic_PD = new_systemic_PD;

            step ++;
            printf ("\n       ---     END OF ITERATION %d ---- \n\nmak", step+1);
            // cout<< "        iteration: "<<step<<endl;
        }
        
        // long double individual_PD   = market->get_individual_PD(0);
        cout << argv[17] <<','<<argv[18]<<','<<old_systemic_PD  <<','<< market->get_individual_PD(0) << ','<< market->get_individual_PD(1) <<','<< market->get_individual_PD(2)<<','<< market->get_individual_PD(3) <<endl;
        // cout << individual_PD  << endl;

        delete market;
    }
    
  return 0;
}