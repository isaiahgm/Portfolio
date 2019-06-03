#pragma once
#include "BakedGood.h"

class Cake : public BakedGood {
	protected:
		std::string flavor;
		std::string frosting;
	public:
		Cake(std::string flavor, std::string frosting, double price);
		//Not defining ToString or Discount Price b/c this is still an
		//abstract class
};