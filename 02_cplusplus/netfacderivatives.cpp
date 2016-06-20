#include "netfacderivatives.h"

NetfacDerivatives::NetfacDerivatives(int n_nodes, string network_source){

	_n_nodes		= n_nodes;
	_network_source = network_source;
	

}

NetfacDerivatives::NetfacDerivatives(const NetfacDerivatives& orig) {
}

NetfacDerivatives::~NetfacDerivatives() {
	for (int i=0;i<_edges.size();i++){
		delete _edges[i];
	}

}

void NetfacDerivatives::generate_network(){

	char c[200];

	sprintf(c, "network_files/%s.data", _network_source.c_str());

	ifstream infile (c);

	if (infile.good())
	{
		string line;

		while(!infile.eof()){
		// !!!!HERE - need to continue until the file is over!!!!
  		// for (int i=0;i<3; i++){
  			std::getline(infile,line);
  			if (line.empty()){
  				break;
  			}
  			stringstream lineStream(line);
			vector<int> numbers;
			int num;
			for (int i = 0; i<3; i++){ (lineStream >> num); numbers.push_back(num);}
			// if buying
			// EdgeDerivative* edge = new EdgeDerivative(numbers[0], numbers[1], numbers[2]);
			// if selling
			EdgeDerivative* edge = new EdgeDerivative(numbers[1], numbers[0], numbers[2]);
			_edges.push_back(edge);
  		}
	}
	else{
		printf("Error: no file %s detected!\n", c);
	}

	infile.close();
}

void NetfacDerivatives::present_derivative_net(){
	printf("Here is the network of derivatives:\n");
	for (int i = 0; i<_edges.size(); i++)
	{
		_edges[i]->present();
	}
}

void NetfacDerivatives::get_sellers_and_reference_id(int id, vector<int> &sellers_cds, vector<int> &reference_sellers_cds){

	for (int i = 0; i<_edges.size(); i ++)
	{
		if (_edges[i]->get_buyer() == id)
		{
			sellers_cds.push_back(_edges[i]->get_seller());
			reference_sellers_cds.push_back(_edges[i]->get_reference());
		}
	}
}

void NetfacDerivatives::get_buyers_and_reference_id(int id, vector<int> &buyers_cds, vector<int> &reference_buyers_cds){

	for (int i = 0; i<_edges.size(); i ++)
	{
		if (_edges[i]->get_seller() == id)
		{
			buyers_cds.push_back(_edges[i]->get_buyer());
			reference_buyers_cds.push_back(_edges[i]->get_reference());
		}
	}
}
