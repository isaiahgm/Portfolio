#pragma once

#include <string>

class BakedGood {
	protected:
		double price;
	public:
		BakedGood(double price) { this->price = price; }
		virtual std::string ToString() = 0;
		virtual double DiscountedPrice(int numPurchased) = 0;
};