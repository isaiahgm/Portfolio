#include <iostream>
#include <iomanip>
#include "ItemToPurchase.h"

// Constructors
ItemToPurchase::ItemToPurchase() {
	itemName = "none";
	itemDescr = "none";
	itemPrice = 0.0;
	itemQuantity = 0;
}

ItemToPurchase::ItemToPurchase(std::string itemName, std::string itemDescr, double itemPrice, int itemQuantity) {
	this->itemName = itemName;
	this->itemDescr = itemDescr;
	this->itemPrice = itemPrice;
	this->itemQuantity = itemQuantity;
}

//Operation Functions
void ItemToPurchase::PrintCost() {
	std::cout << itemName << " " << itemQuantity << " @ $" << std::fixed << std::setprecision(2) << itemPrice << " = $" << itemPrice * itemQuantity;
	std::cout << std::endl;
}

void ItemToPurchase::PrintDescr() {
	std::cout << itemName << ": " << itemDescr << std::endl;
}