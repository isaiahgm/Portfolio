#include "Bread.h"
#include <sstream>
#include <iomanip>

Bread::Bread(std::string type, double price) : BakedGood(price) {
	this->type = type;
}

std::string Bread::ToString() {
	std::ostringstream outSS;
	outSS << type << " bread ($" << std::fixed << std::setprecision(2) << price << ")" << std::endl;
	return outSS.str();
}

double Bread::DiscountedPrice(int numPurchased) {
	int numFourths = numPurchased / 3;
	double subTotal = numPurchased * price;
	double Total = subTotal - (numFourths * price);
	return Total;
}