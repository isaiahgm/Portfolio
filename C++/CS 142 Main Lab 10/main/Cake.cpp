#include "Cake.h"

Cake::Cake(std::string flavor, std::string frosting, double price) : BakedGood(price) {
	this->flavor = flavor;
	this->frosting = frosting;
}