#pragma once

#include "BakedGood.h"
#include <string>

class Bread : public BakedGood {
	private:
		std::string type;
	public:
		Bread(std::string type, double price);
		std::string ToString();
		double DiscountedPrice(int numPurchased);
};