// main.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <iostream>
#include <string>
#include "ShoppingCart.h"

using namespace std;

char InputConvertChar(string userInput) { //borrowed from lab 7 b/c I prefer switch statements
	char returnChar;
	if (userInput == "options" || userInput == "Options") {
		returnChar = 'o';
	} else if (userInput == "quit" || userInput == "Quit") {
		returnChar = 'q';
	} else if (userInput == "descriptions") {
		returnChar = 'd';
	} else if (userInput == "add") {
		returnChar = 'a';
	} else if (userInput == "remove") {
		returnChar = 'r';
	} else if (userInput == "change") {
		returnChar = 'h'; //overlaps with cart
	} else if (userInput == "cart") {
		returnChar = 'c';
	} else {
		returnChar = 'o'; // this will make it go to the options screen
	}
	return returnChar;
}

int main() {
	//Initial Variable Declarations
	string userName;
	string userDate;
	string userInput;
	char userOption; // is char conversion of input string
	string userItemName;
	string userItemDescr;
	int userItemQuantity = 0;
	double userItemPrice = 0.0;
	ItemToPurchase userItem;

	//Get Initial User Input
	cout << "Enter Customer\'s Name: ";
	getline(cin, userName);

	cout << "Enter Today\'s Date: ";
	getline(cin, userDate);
	cout << endl;

	//Declare Shopping Cart w/ user data
	ShoppingCart userCart(userName, userDate);

	//Enter Program Loop
	do { // The loop to repeat the game
		cout << "Enter option: ";
		cin >> userInput;
		cin.ignore();
		cout << endl;
		userOption = InputConvertChar(userInput);
		
		//Game Options
		switch (userOption) {
		case 'o': // Options
			cout << "MENU" << endl;
			cout << "add - Add item to cart" << endl;
			cout << "remove - Remove item from cart" << endl;
			cout << "change - Change item quantity" << endl;
			cout << "descriptions - Output items\' descriptions" << endl;
			cout << "cart - Output shopping cart" << endl;
			cout << "options - Print the options menu" << endl;
			cout << "quit - Quit" << endl << endl;
			break;

		case 'a': // Add
			cout << "Enter the item name: ";
			getline(cin, userItemName);
			userItem.SetName(userItemName);
			
			cout << "Enter the item description: ";
			getline(cin, userItemDescr);
			userItem.SetDescr(userItemDescr);
			
			cout << "Enter the item price: ";
			cin >> userItemPrice;
			userItem.SetPrice(userItemPrice);
			
			cout << "Enter the item quantity: ";
			cin >> userItemQuantity;
			cout << endl;
			cin.ignore();
			userItem.SetQuantity(userItemQuantity);

			userCart.AddItem(userItem);
			break;
			
		case 'r': // Remove
			cout << "Enter name of the item to remove: ";
			getline(cin, userItemName);
			userCart.RemoveItem(userItemName);
			cout << endl;
			break;

		case 'h': // Change
			cout << "Enter the item name: ";
			getline(cin, userItemName);
			cout << "Enter the new quantity: ";
			cin >> userItemQuantity;
			cout << endl;
			cin.ignore();
			userCart.UpdateItemQuantity(userItemName, userItemQuantity);
			break;

		case 'd': // Descriptions
			userCart.PrintDescrSummary();
			break;

		case 'c': // Cart
			userCart.PrintCostSummary();
			break;

		default:
			break;
		}
	} while (userInput != "quit");
	cout << "Goodbye.";
	return 0;
}
