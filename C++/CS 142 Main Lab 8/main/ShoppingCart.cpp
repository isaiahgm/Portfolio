#include "ShoppingCart.h"
#include <iostream>

ShoppingCart::ShoppingCart() {
	shopperName = "none";
	shopperCreateDate = "January 1, 2016";
}

ShoppingCart::ShoppingCart(std::string shopperName, std::string shopperCreateDate) {
	this->shopperName = shopperName;
	this->shopperCreateDate = shopperCreateDate;
}

bool ShoppingCart::IsItemInVector(ItemToPurchase item) {
	bool isContained = false;
	for (unsigned int i = 0; i < shopperCart.size(); i++) {
		if (item.GetName() == shopperCart.at(i).GetName()) {
			isContained = true;
		}
	}
	return isContained;
}

bool ShoppingCart::IsItemInVector(std::string item) { //overload this function so it can handle ItemToPurchase objects and Strings
	bool isContained = false;
	for (unsigned int i = 0; i < shopperCart.size(); i++) {
		if (item == shopperCart.at(i).GetName()) {
			isContained = true;
		}
	}
	return isContained;
}

void ShoppingCart::AddItem(ItemToPurchase item) {
	if (!IsItemInVector(item)) {
		shopperCart.push_back(item);
	} else {
		std::cout << "Item is already in cart. Nothing added." << std::endl;
	}
}

void ShoppingCart::RemoveItem(std::string itemName) {
	if (IsItemInVector(itemName)) { //FIXME: Decide what to do about the IsItemVector Function, should it take strings or item objects?
		int itemIndex;
		for (unsigned int i = 0; i < shopperCart.size(); i++) {
			if (itemName == shopperCart.at(i).GetName()) {
				itemIndex = i;
			}
		}
		shopperCart.erase(shopperCart.begin() + itemIndex);
		
	} else {
		std::cout << "Item not found in cart. Nothing removed." << std::endl;
	}
}

void ShoppingCart::UpdateItemQuantity(std::string item, int newQuantity) {
	if (IsItemInVector(item)) {
		for (unsigned int i = 0; i < shopperCart.size(); i++) {
			if (item == shopperCart.at(i).GetName()) {
				shopperCart.at(i).SetQuantity(newQuantity);
			}
		}
	} else {
		std::cout << "Item not found in cart. Nothing modified." << std::endl;
	}

}

int ShoppingCart::GetTotalQuantity() {
	int totalQuantity = 0;
	for (unsigned int i = 0; i < shopperCart.size(); i++) {
		totalQuantity = totalQuantity + shopperCart.at(i).GetQuantity();
	}
	return totalQuantity;
}

double ShoppingCart::GetTotalCost() {
	double totalCost = 0;
	for (unsigned int i = 0; i < shopperCart.size(); i++) {
		totalCost = totalCost + shopperCart.at(i).GetCost();
	}
	return totalCost;
}

void ShoppingCart::PrintCostSummary() {
	std::cout << shopperName << "\'s Shopping Cart - " << shopperCreateDate << std::endl;
	if (shopperCart.size() > 0) {		
		std::cout << "Number of Items: " << GetTotalQuantity() << std::endl << std::endl;
		for (unsigned int i = 0; i < shopperCart.size(); i++) {
			shopperCart.at(i).PrintCost();
		}
		std::cout << std::endl << "Total: $" << GetTotalCost() << std::endl << std::endl;
	} else {
		std::cout << "Shopping cart is empty." << std::endl << std::endl;
	}
}

void ShoppingCart::PrintDescrSummary() {
	std::cout << shopperName << "\'s Shopping Cart - " << shopperCreateDate << std::endl;
	if (shopperCart.size() > 0) {
		std::cout << std::endl << "Item Descriptions" << std::endl;
		for (unsigned int i = 0; i < shopperCart.size(); i++) {
			shopperCart.at(i).PrintDescr();
		}
		std::cout << std::endl;
	} else {
		std::cout << "Shopping cart is empty." << std::endl << std::endl;
	}
}