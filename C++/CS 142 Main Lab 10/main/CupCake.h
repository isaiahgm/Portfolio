#pragma once
#include "Cake.h"

class CupCake : public Cake {
private:
	std::string sprinkleCol;
public:
	CupCake(std::string flavor, std::string frosting, std::string sprinkleCol, double price);
	std::string ToString();
	double DiscountedPrice(int numPurchased);
};
