#ifndef ITEMTOPURCHASE_H
#define ITEMTOPURCHASE_H
#include <string>

class ItemToPurchase {
	private:
		std::string itemName;
		std::string itemDescr;
		double itemPrice;
		int itemQuantity;

	public:
		// Setting Functions
		void SetName(std::string itemName) { this->itemName = itemName; }
		void SetDescr(std::string itemDescr) { this->itemDescr = itemDescr; }
		void SetPrice(double itemPrice) { this->itemPrice = itemPrice; }
		void SetQuantity(int itemQuantity) { this->itemQuantity = itemQuantity;  }
		// Getting Functions
		std::string GetName() { return itemName; }
		std::string GetDescr() { return itemDescr; }
		double GetPrice() { return itemPrice; }
		int GetQuantity() { return itemQuantity; }
		double GetCost() { return (itemPrice * itemQuantity); }

		//Constructors
		ItemToPurchase();
		ItemToPurchase(std::string itemName, std::string itemDescr, double itemPrice, int itemQuantity);

		//Operation Functions
		void PrintCost();
		void PrintDescr();
};

#endif
