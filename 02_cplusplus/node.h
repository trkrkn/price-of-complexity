#ifndef _NODE_H
#define	_NODE_H

#include <iostream>
#include <vector> 
#include <stdio.h>
using namespace std;

class Node{

public:

	Node(int);
	Node(const Node& orig);
    virtual ~Node();

    int get_id();

    void add_out_neighbour(Node*);
    void add_in_neighbour(Node*);

    int get_out_degree();
    int get_in_degree();

    bool is_out_neighbour(Node*);
    bool is_in_neighbour(Node*);

    int get_out_off_degree();

    void set_off();
    void set_on();

    bool is_on();

    void present_out_neighbours();
    void present_in_neighbours();

    vector<Node*> get_out_neighbours();
    vector<int> get_out_neighbours_id();
    
private:

	int _id;

	bool _on;

	vector<Node*> _out_neighbours;
	vector<Node*> _in_neighbours;

};

#endif	/* _NODE_H */
