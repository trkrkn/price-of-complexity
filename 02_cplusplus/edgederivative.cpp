#include "edgederivative.h"

EdgeDerivative::EdgeDerivative(int buyer_id, int seller_id, int reference_id){

	_buyer_id 		= buyer_id;
	_seller_id 		= seller_id;
	_reference_id 	= reference_id;

	// printf(" EDGE created with [%d] - [%d] - [%d]\n", _buyer_id, _seller_id, _reference_id);

}

EdgeDerivative::EdgeDerivative(const EdgeDerivative& orig){

}


EdgeDerivative::~EdgeDerivative(){
	
}

int EdgeDerivative::get_buyer(){
	
	return _buyer_id;
}

int EdgeDerivative::get_seller(){
	return _seller_id;
}

int EdgeDerivative::get_reference(){
	return _reference_id;
}

void EdgeDerivative::present(){
	printf(" EDGE presents itself with [%d] - [%d] - [%d]\n", _buyer_id, _seller_id, _reference_id);
}