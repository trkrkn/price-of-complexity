#ifndef _EDGEDERIVATIVE_H
#define	_EDGEDERIVATIVE_H

#include <iostream>

using namespace std;

class EdgeDerivative{

public:

	EdgeDerivative(int, int, int);
	EdgeDerivative(const EdgeDerivative& orig);
    virtual ~EdgeDerivative();

    void present();

    int get_buyer();
    int get_seller();
    int get_reference();

private:

	int _buyer_id;
	int _seller_id;
	int _reference_id;
};

#endif	/* _EDGEDERIVATIVE_H */