/*
    Tarik Roukny
    The Price of Complexity

 date: 15/06/2016
*/


#include "node.h"

Node::Node(int id){

	_id=id;

	_on=true;
}

Node::Node(const Node& orig) {
}

Node::~Node() {

}

void Node::add_out_neighbour(Node* n){
	this->_out_neighbours.push_back(n);
}
    
void Node::add_in_neighbour(Node* n){
	this->_in_neighbours.push_back(n);
}

int Node::get_out_degree(){
	if (_out_neighbours.empty()){
		return 0;
	}
	else{
		return _out_neighbours.size();
	}
}

int Node::get_in_degree(){
		if (_in_neighbours.empty()){
		return 0;
	}
	else{
		return _in_neighbours.size();
	}
}

bool Node::is_out_neighbour(Node* n){
	bool is=false;
	for (int i=0; i<_out_neighbours.size(); i++){
		if (n==_out_neighbours[i]){
			is=true;
			break;
		}
	}
	return is;
}

bool Node::is_in_neighbour(Node* n){
	bool is=false;
	for (int i=0; i<_in_neighbours.size(); i++){
		if (n==_out_neighbours[i]){
			is=true;
			break;
		}
	}
	return is;
}

int Node::get_id(){
	return this->_id;
}

void Node::set_off(){
	_on=false;
}

void Node::set_on(){
	_on=true;
}

int Node::get_out_off_degree(){
	int n=0;
	for (int i=0;i<_out_neighbours.size();i++){
		if (!_out_neighbours[i]->is_on()){
			n++;
		}
	}
	return n;
}

vector<int> Node::get_out_neighbours_id(){
	vector<int> out_list ;
	for (int i = 0; i < _out_neighbours.size(); i++)
	{
		out_list.push_back(_out_neighbours[i]->get_id());
	}
	return out_list;
}

bool Node::is_on(){
	return _on;
}

void Node::present_out_neighbours(){
	for (int o=0; o<_out_neighbours.size(); o++){
		printf("[%d] ", _out_neighbours[o]->get_id());
	}
}

void Node::present_in_neighbours(){
	for (int o=0; o<_in_neighbours.size(); o++){
		printf("[%d] ", _in_neighbours[o]->get_id());
	}
}