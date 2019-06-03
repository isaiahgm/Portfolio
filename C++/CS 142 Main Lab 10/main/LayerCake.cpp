#include "LayerCake.h"
#include <sstream>
#include <iomanip>

LayerCake::LayerCake(std::string flavor, std::string frosting, int numLayers, double price) : Cake(flavor, frosting, price) {
	this->numLayers = numLayers;
}

std::string LayerCake::ToString() {
	std::ostringstream outSS;
	outSS << numLayers << "-layer " << flavor << " cake with " << frosting << " frosting ($" << std::fixed << std::setprecision(2) << price << ")" << std::endl;
	return outSS.str();
}

double LayerCake::DiscountedPrice(int numPurchased) {
	double total = numPurchased * price;
	if (numPurchased >= 3) {
		total = total - (numPurchased * 2.0);
	}
	return total;
}