/*
    Tarik Roukny
    The Price of Complexity

 date: 15/06/2016
*/


#include "netfac.h"

Netfac::Netfac(int n_nodes, vector<Agent*> list, string network_source){
	
	// printf("Netfac ready to create the network\n");

	_n_nodes		= n_nodes;
	_network_source = network_source;

	for (int i=0; i<_n_nodes; i++){
		Node* n=new Node(list[i]->get_id());
		list[i]->set_node(n);
		_nodes.push_back(n);
	}
}

Netfac::Netfac(const Netfac& orig) {
}

Netfac::~Netfac() {
	for (int i=0;i<_nodes.size();i++){
		delete _nodes[i];
	}

}

void Netfac::generate_network(){

	char c[200];

	sprintf(c, "network_files/%s.data", _network_source.c_str());

	ifstream infile (c);
	if (infile.good())
	{
		string line;
  		for (int i=0;i<_n_nodes; i++){
  			Node* node=_nodes[i];
  			std::getline(infile,line);
  			stringstream lineStream(line);
			vector<int> numbers;
			int num;
			while (lineStream >> num) numbers.push_back(num);
			for (int j=0; j<numbers.size();j++){
				Node* neigh=_nodes[numbers[j]];
				node->add_out_neighbour(_nodes[numbers[j]]);
				_nodes[numbers[j]]->add_in_neighbour(node);
			}
  		}
	}
	else{
		printf("Error: no file %s detected!\n", c);
	}
	infile.close();


}

vector<int> Netfac::get_out_neighbours_id(int id)
{
	return _nodes[id]->get_out_neighbours_id();
}

float Netfac::get_avg_out_degree(){
	// for now
	// cout<<_avg_k<<endl;
	return this->_avg_k;
}