// main.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <iostream>
#include <string>
#include <sstream>
#include <vector>
#include <iomanip>
#include "Bread.h"
#include "LayerCake.h"
#include "CupCake.h"


using namespace std;

//Global Constants
const double PRICE_BREAD = 4.5;
const double PRICE_CUPCAKE = 1.95;
const double PRICE_LAYERCAKE_BASE = 9.0;
const double PRICE_LAYERCAKE_ADD = 3.0; //for extra layers past 1
const double FEE_CC_CUPCAKE = 0.20; //for cream-cheese frosting
const double FEE_CC_LAYERCAKE = 1.0; //for cream-cheese frosting per layer

int main() {
	//Variable Declarations
	string userInput; // to capture the whole user input on what items to purchase
	string firstInput; // the first chunk of user input. determines type of good or ends sub-order process
	istringstream inSS; // to split user input into useable chunks
	
	vector<BakedGood*> userOrder; // to keep track of the users entire order

	//Program
	//Step 1: Get sub-orders
	cout << "**Bread and Cakes Bakery**" << endl << endl;
	cout << "Enter sub-order (enter \"done\" to finish)" << endl;
	do {
		// Get Input
		cout << "Sub-order:";
		getline(cin, userInput);
		//cout << endl;

		// Prep extractor
		inSS.clear();
		inSS.str(userInput);

		// Check first chunk to determine next step
		inSS >> firstInput;

		// Add the corresponding baked good
		if (firstInput == "Bread") {
			// Read in remaining values
			string type;
			int quantity;
			inSS >> type >> quantity;
			
			//Create new object(s)
			for (int i = 0; i < quantity; i++) {
				Bread* newGood = new Bread(type, PRICE_BREAD);
				userOrder.push_back(newGood);
			}
		} else if (firstInput == "Cupcake") {
			// Read in remaining values
			string flavor;
			string frosting;
			string sprinkleCol;
			int quantity;
			inSS >> flavor >> frosting >> sprinkleCol >> quantity;

			//Create new object(s)
			for (int i = 0; i < quantity; i++) {
				CupCake* newGood;
				if (frosting == "cream-cheese") {
					newGood = new CupCake(flavor, frosting, sprinkleCol, PRICE_CUPCAKE + FEE_CC_CUPCAKE);
				} else {
					newGood = new CupCake(flavor, frosting, sprinkleCol, PRICE_CUPCAKE);
				}
				userOrder.push_back(newGood);
			}
		} else if (firstInput == "Layer-cake") {
			// Read in remaining values
			string flavor;
			string frosting;
			int numLayers;
			int quantity;
			inSS >> flavor >> frosting >> numLayers >> quantity;

			//Create new object(s)
			for (int i = 0; i < quantity; i++) {
				LayerCake* newGood;
				if (frosting == "cream-cheese") {
					newGood = new LayerCake(flavor, frosting, numLayers, PRICE_LAYERCAKE_BASE + FEE_CC_LAYERCAKE + ((numLayers - 1.0) * (PRICE_LAYERCAKE_ADD + FEE_CC_LAYERCAKE)));
				} else {
					newGood = new LayerCake(flavor, frosting, numLayers, 9.0 + ((numLayers - 1.0) * PRICE_LAYERCAKE_ADD));
				}
				userOrder.push_back(newGood);
			}
		}
	} while (firstInput != "done");

	//Step 2: Print order confirmation
	cout << endl << "Order Confirmations: " << endl;
	for (unsigned int i = 0; i < userOrder.size(); i++) {
		cout << userOrder.at(i)->ToString();
	}

	//Step 3: Print Invoice
	vector<BakedGood*> uniqueItems;
	vector<int> uniqueNumOccurences;
	int totalItems = 0;
	double totalCost = 0.0;
	
	cout << endl << "Invoice: " << endl;

	uniqueItems.push_back(userOrder.at(1)); //to give a starting point
	uniqueNumOccurences.push_back(1); // the first item occurs once
	// Check for duplicates and such
	for (unsigned int i = 1; i < userOrder.size(); i++) {
		bool isDuplicate = false;
		for (unsigned int j = 0; j < uniqueItems.size(); j++) {
			if (uniqueItems.at(j)->ToString() == userOrder.at(i)->ToString()) {
				uniqueNumOccurences.at(j)++;
				isDuplicate = true;
			}
		}
		if (!isDuplicate) {
			uniqueItems.push_back(userOrder.at(i));
			uniqueNumOccurences.push_back(1);
		}
	}

	//Print out unique items and get totals
	cout << setw(75) << left << "Baked Good" << setw(9) << right << "Quantity" << setw(9) << "Total" << endl;
	for (unsigned int i = 0; i < uniqueItems.size(); i++) {
		cout << setw(75) << left << uniqueItems.at(i)->ToString() << setw(9) << right << uniqueNumOccurences.at(i) << setw(9) << fixed << setprecision(2) << uniqueItems.at(i)->DiscountedPrice(uniqueNumOccurences.at(i)) << endl;
		totalItems = totalItems + uniqueNumOccurences.at(i);
		totalCost = totalCost + uniqueItems.at(i)->DiscountedPrice(uniqueNumOccurences.at(i));
	}
	cout << setw(75) << left << "Totals" << setw(9) << right << totalItems << setw(9) << totalCost << endl;

	//Clean up
	for (unsigned int i = 0; i < userOrder.size(); i++) {
		delete userOrder.at(i);
		userOrder.erase(userOrder.begin() + i);
	}
	cout << "Good Bye" << endl;
}
