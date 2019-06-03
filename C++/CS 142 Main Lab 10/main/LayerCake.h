#pragma once
#include "Cake.h"

class LayerCake : public Cake {
	private:
		int numLayers;
	public:
		LayerCake(std::string flavor, std::string frosting, int numLayers, double price);
		std::string ToString();
		double DiscountedPrice(int numPurchased);
};