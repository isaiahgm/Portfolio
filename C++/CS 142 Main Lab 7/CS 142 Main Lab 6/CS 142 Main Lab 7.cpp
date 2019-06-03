// CS 142 Main Lab 7.cpp : This file contains the 'main' function. Program execution begins and ends there.
// Resturant Battle

#include "pch.h"
#include <iostream>
#include <string>
#include <vector>
#include <cmath>
#include <limits>
using namespace std;

char InputConvertChar(string userInput) {
	char returnChar;
	if (userInput == "options" || userInput == "Options") {
		returnChar = 'o';
	} else if (userInput == "quit" || userInput == "Quit") {
		returnChar = 'q';
	} else if (userInput == "display") {
		returnChar = 'd';
	} else if (userInput == "add") {
		returnChar = 'a';
	} else if (userInput == "remove") {
		returnChar = 'r';
	} else if (userInput == "cut") {
		returnChar = 'c';
	} else if (userInput == "shuffle") {
		returnChar = 's';
	} else if (userInput == "battle") {
		returnChar = 'b';
	} else {
		cout << "Invalid Selection" << endl << endl;
		returnChar = 'o'; // this will make it go to the options screen
	}
	return returnChar;
}

int GetIntInput(string inputPrompt, string errorMessage, int lowerBound = -999999999, int upperBound = 999999999) {
	// Checks if the supplied input is a valid integer value and if it is within bounds provided.
	// Will continue to require input until correct input is given.
	// defaults are just large numbers to represent essentially no boundary
	int userNum;
	int errorSwitch = false;
	do {
		errorSwitch = false;
		cout << inputPrompt << endl;
		cin >> userNum;
		if (cin.fail() || userNum < lowerBound || userNum > upperBound) {
			cout << errorMessage << endl << endl;
			cin.clear();
			cin.ignore(numeric_limits<streamsize>::max(), '\n');
			errorSwitch = true; // Makes so the while loop will be true and loop back
		}
	} while (userNum < lowerBound || userNum > upperBound || errorSwitch);
	return userNum;
}

bool PowerOfTwo(int numberToCheck) { // Returns True if the number is a power of two (1,2,4,8 ...)
	bool isPowerTwo = false; // default is false
	if (numberToCheck > 0) { // This can only take values larger than zero
		float logNum = log2(static_cast<float>(numberToCheck)); // Take log base 2 of the number
		if (floor(logNum) == logNum) { // if the result is a whole num then it is a power of two
			//Round the number down, if it still equals the original it is a whole number
			isPowerTwo = true;
		}
	}
	return isPowerTwo;
}

void DisplayStrings(vector<string> userStrings) {
	if (userStrings.size() == 0) {
		cout << "Error. No elements detected in input string." << endl;
	} else {
		cout << "Here are the current restaurants: " << endl << endl;
		for (unsigned int i = 0; i < userStrings.size(); i++) {
			cout << "\t\"" << userStrings.at(i) << "\"" << endl;
		}
	}
	cout << endl;
}

bool IsItemInVector(string userInput, vector<string> userStrings) {
	bool isContained = false;
	for (unsigned int i = 0; i < userStrings.size(); i++) {
		if (userInput == userStrings.at(i)) {
			isContained = true;
		}
	}
	return isContained;
}

void AddRestaurant(vector<string>& userStrings) { 
	string userInput;
	cout << "What is the name of the restaurant you want to add?" << endl << endl;
	getline(cin, userInput);
	if (IsItemInVector(userInput, userStrings) || userInput == "" || userInput == " " || userInput == "/n") {
		cout << "That restaurant is already on the list, you can not add it again." << endl << endl;
	} else {
		userStrings.push_back(userInput);
		cout << userInput << " has been added." << endl << endl;
	}
}

void RemoveRestaurant(vector<string>& userStrings) {
	string userInput;
	int restaurantIndex;
	cout << "What is the name of the restaurant you want to remove?" << endl;
	getline(cin, userInput);
	if (!IsItemInVector(userInput, userStrings) || userInput == "" || userInput == " " || userInput == "/n") {
		cout << "That restaurant is not on the list, you can not remove it." << endl << endl;
	} else {
		for (unsigned int i = 0; i < userStrings.size(); i++) {
			if (userStrings.at(i) == userInput) {
				restaurantIndex = i;
			}
		}
		userStrings.erase(userStrings.begin() + restaurantIndex);
		cout << userInput << " has been removed." << endl << endl;
	}
}

vector<string> CutDeck(vector<string> userStrings) {
	vector<string> cutStrings;
	int position = GetIntInput("How many restaurants should be taken from the top and put on the bottom?",
				"The cut number must be between 0 and " + to_string(userStrings.size()), 0, userStrings.size()); 
	for (unsigned int i = position; i < userStrings.size(); i++) {
		cutStrings.push_back(userStrings.at(i));
	}
	for (int i = 0; i < position; i++) {
		cutStrings.push_back(userStrings.at(i));
	}
	return cutStrings;
}

vector<string> ShuffleDeck(vector<string> userStrings) {
	vector<string> returnStrings;
	vector<string> compString1; //component strings
	vector<string> compString2; 
	if (!PowerOfTwo(userStrings.size())) {
		cout << "The current tournament size (" << userStrings.size() << ") is not a power of two(2, 4, 8 ...)." << endl;
		cout << "A shuffle is not possible. Please add or remove restaurants." << endl << endl;
		return userStrings; //Included so if there is an error the original strings are returned
	} else {
		// First, Split the list
		for (unsigned int i = 0; i < userStrings.size() / 2; i++) {
			compString1.push_back(userStrings.at(i));
		}
		for (unsigned int i = userStrings.size() / 2; i < userStrings.size(); i++) {
			compString2.push_back(userStrings.at(i));
		}
		// Second, Shuffle
		for (unsigned int i = 0; i < userStrings.size() / 2; i++) {
			returnStrings.push_back(compString2.at(i));
			returnStrings.push_back(compString1.at(i));
		}
	}
	return returnStrings;
}

vector<string> OneBattleRound(vector<string> userStrings) {
	int userChoice = 0;
	vector<string> roundWinners;
	for (unsigned int i = 0; i < userStrings.size() / 2; i++) {
		string roundString = ("Type \"1\" if you prefer " + userStrings.at(i * 2) + " or\ntype \"2\" if you prefer " +
			userStrings.at(i * 2 + 1) + "\nChoice: ");
		userChoice = GetIntInput(roundString, "Invalid choice", 1, 2);
		cout << endl;
		if (userChoice == 1) {
			roundWinners.push_back(userStrings.at(i * 2));
		} else if (userChoice == 2) {
			roundWinners.push_back(userStrings.at(i * 2 + 1));
		}
	}
	return roundWinners;
}

void RestaurantBattle(vector<string> userStrings) {
	if (!PowerOfTwo(userStrings.size())) {
		cout << "The current tournament size (" << userStrings.size() << ") is not a power of two(2, 4, 8 ...)." << endl;
		cout << "A battle is not possible. Please add or remove restaurants." << endl << endl;
	} else {
		int numRounds = static_cast<int>(log2(userStrings.size())); //log2 will determine how many rounds there are
		for (int i = 0; i < numRounds; i++) { 
			cout << "Round: " << i + 1 << endl << endl;
			userStrings = OneBattleRound(userStrings);
		}
		cin.ignore(numeric_limits<streamsize>::max(), '\n');
		cout << "The winning restaurant is " << userStrings.at(0) << "." << endl << endl;
	}
}

int main() {
	// Variable Declarations
	string userInput;
	vector<string> restaurantString;

	// The Program
	cout << "Welcome to the restaurant battle! Enter \"options\" to see options." << endl << endl;
	do { // The loop to repeat the game
		cout << "Enter your Selection: ";
		cin >> userInput;
		cin.ignore();
		cout << endl;
		char userOption = InputConvertChar(userInput);

		//Game Options
		switch (userOption) {
		case 'o': // Options
			cout << "Please select one of the following options: " << endl << endl;
			cout << "quit - Quit the program" << endl;
			cout << "display - Display all restaurants" << endl;
			cout << "add - Add a restaurant" << endl;
			cout << "remove - Remove a restaurant" << endl;
			cout << "cut - \"Cut\" the list of restaurants" << endl;
			cout << "shuffle - \"Shuffle\" the list of restaurants" << endl;
			cout << "battle - Begin the tournament" << endl;
			cout << "options - Print the options menu" << endl << endl;
			break;
		case 'd': //display
			DisplayStrings(restaurantString);
			break;
		case 'a': //add
			AddRestaurant(restaurantString);
			break;
		case 'r': //remove
			RemoveRestaurant(restaurantString);
			break;
		case 'c': //cut
			restaurantString = CutDeck(restaurantString);
			break;
		case 's': //shuffle
			restaurantString = ShuffleDeck(restaurantString);
			break;
		case 'b': //battle
			RestaurantBattle(restaurantString);
			break;
		default:
			break;
		}
	} while (userInput != "quit");
	cout << "Goodbye!";
}
