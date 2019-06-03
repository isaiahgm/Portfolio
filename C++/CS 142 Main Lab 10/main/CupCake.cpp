#include "CupCake.h"
#include <sstream>
#include <iomanip>

CupCake::CupCake(std::string flavor, std::string frosting, std::string sprinkleCol, double price) : Cake(flavor, frosting, price) {
	this->sprinkleCol = sprinkleCol;
}

std::string CupCake::ToString() {
	std::ostringstream outSS;
	outSS << flavor << " cupcake with " << frosting << " frosting and " << sprinkleCol << " sprinkles ($" << std::fixed << std::setprecision(2) << price << ")" << std::endl;
	return outSS.str();
}

double CupCake::DiscountedPrice(int numPurchased) {
	double total = numPurchased * price;
	if (numPurchased >= 2 && numPurchased < 4) {
		total = total - (numPurchased * 0.3);
	} else if (numPurchased >= 4) {
		total = total - (numPurchased * 0.4);
	}
	return total;
}