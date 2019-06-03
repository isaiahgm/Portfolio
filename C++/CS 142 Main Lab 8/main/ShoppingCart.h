#ifndef SHOPPINGCART_H
#define SHOPPINGCART_H
#include <string>
#include <vector>
#include "ItemToPurchase.h"


class ShoppingCart {
	private:
		std::string shopperName;
		std::string shopperCreateDate;
		std::vector<ItemToPurchase> shopperCart;

		bool IsItemInVector(ItemToPurchase item); //borrowed from Lab 7
		bool IsItemInVector(std::string item); //Overloaded for string input
		
	public:
		//Basic Setting Functions
		void SetName(std::string shopperName) { this->shopperName = shopperName; }
		void SetDate(std::string shopperCreateDate) { this->shopperCreateDate = shopperCreateDate; }

		//Getting Functions
		std::string GetName() { return shopperName; }
		std::string GetDate() { return shopperCreateDate; }

		//Constructors
		ShoppingCart();
		ShoppingCart(std::string shopperName, std::string shopperCreateDate);

		//Public Shopping Cart Functions
		//Modifying Functions
		void AddItem(ItemToPurchase item);
		void RemoveItem(std::string itemName);
		void UpdateItemQuantity(std::string item, int newQuantity);

		//Summary Functions
		int GetTotalQuantity();
		double GetTotalCost();
		void PrintCostSummary();
		void PrintDescrSummary();
};

#endif

