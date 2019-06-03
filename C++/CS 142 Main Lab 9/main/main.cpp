// main.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <iostream>
#include <string>
#include <vector>
#include "Song.h"
#include "Playlist.h"

using namespace std;

int main() {
	string userSelection;
	vector<Song*> songLibrary;
	vector<Playlist> userPlaylists;

	cout << "Welcome to the Firstline Player! Enter options to see menu options." << endl << endl;

	//Menu
	do {
		// Get User Input
		cout << "Enter your selection now: ";
		cin >> userSelection;
		cin.ignore();

		// Execute User Input
		if (userSelection == "add") {
			string title;
			string firstLine;

			cout << "Read in Song names and first lines (type \"STOP\" when done):" << endl;

			do {
				cout << "Song Name: ";
				getline(cin, title);

				if (title != "STOP") { // Only perform other steps if the title isn't STOP
					cout << "Song\'s first line:";
					getline(cin, firstLine);

					Song* newSong; //Create Pointer
					newSong = new Song(title, firstLine); //Create Song on the Heap tied to pointer
					songLibrary.push_back(newSong); //Add song pointer to library
				}
			} while (title != "STOP");
			cout << endl;

		} else if (userSelection == "list") { //List the songs in library
			for (unsigned int i = 0; i < songLibrary.size(); i++) {
				songLibrary.at(i)->Print();
			}
			cout << endl;

		} else if (userSelection == "addp") {
			//Get new playlist name
			string playlistName;
			cout << "Playlist Name: ";
			
			//Create the new playlist
			getline(cin, playlistName);
			Playlist newPlaylist(playlistName);

			//Add playlist to list of playlists
			userPlaylists.push_back(newPlaylist);
			cout << endl;

		} else if (userSelection == "addsp") {
			// Variables for indexes
			int listIndex;
			int songIndex;

			// Display Playlists
			for (unsigned int i = 0; i < userPlaylists.size(); i++) {
				cout << "\t" << i << ": " << userPlaylists.at(i).GetName() << endl;
			}
			cout << "Pick a playlist index number: ";
			cin >> listIndex;

			// Display Songs
			for (unsigned int i = 0; i < songLibrary.size(); i++) {
				cout << "\t" << i << ": " << songLibrary.at(i)->GetTitle() << endl;
			}
			cout << "Pick a song index number: ";
			cin >> songIndex;
			cin.ignore();
			
			//Add song pointer to playlist
			userPlaylists.at(listIndex).AddSong(songLibrary.at(songIndex));

		} else if (userSelection == "listp") { //List playlists
			for (unsigned int i = 0; i < userPlaylists.size(); i++) {
				cout << "\t" << i << ": " << userPlaylists.at(i).GetName() << endl;
			}
			cout << endl;

		} else if (userSelection == "play") {
			int listIndex;

			// Get Index to play from
			for (unsigned int i = 0; i < userPlaylists.size(); i++) {
				cout << "\t" << i << ": " << userPlaylists.at(i).GetName() << endl;
			}
			cout << "Pick a playlist index number: ";
			cin >> listIndex;
			cin.ignore();

			cout << "Playing first lines of playlist: " << userPlaylists.at(listIndex).GetName() << endl;
			// Print out every song first line and increase play count
			for (unsigned int i = 0; i < userPlaylists.at(listIndex).GetList().size(); i++) { 
				cout << userPlaylists.at(listIndex).GetList().at(i)->PlaySong() << endl;
			}

		} else if (userSelection == "delp") {
			int listIndex;

			// Get Index to delete
			for (unsigned int i = 0; i < userPlaylists.size(); i++) {
				cout << "\t" << i << ": " << userPlaylists.at(i).GetName() << endl;
			}
			cout << "Pick a playlist index number to delete: ";
			cin >> listIndex;
			cin.ignore();

			userPlaylists.erase(userPlaylists.begin() + listIndex);

		} else if (userSelection == "delsp") {
			int listIndex;
			int songIndex;

			//Get Playlist Index
			for (unsigned int i = 0; i < userPlaylists.size(); i++) {
				cout << "\t" << i << ": " << userPlaylists.at(i).GetName() << endl;
			}
			cout << "Pick a playlist index number: ";
			cin >> listIndex;
			
			//Get Song Index to Remove
			for (unsigned int i = 0; i < userPlaylists.at(listIndex).GetList().size(); i++) {
				cout << "\t" << i << ": " << userPlaylists.at(listIndex).GetList().at(i)->GetTitle() << endl;
			}
			cout << "Pick a song index number to delete: ";
			cin >> songIndex;
			cin.ignore();

			// Because we are just removing a pointer from a list and not the actual song nothing more than this is necessary
			userPlaylists.at(listIndex).DelSong(songIndex);

		} else if (userSelection == "delsl") {
			int songIndex;

			//Get Song Index to Delete
			for (unsigned int i = 0; i < songLibrary.size(); i++) {
				cout << "\t" << i << ": " << songLibrary.at(i)->GetTitle() << endl;
			}
			cout << "Pick a song index number: ";
			cin >> songIndex;
			cin.ignore();

			//Check if it is on any playlists and remove if it is
			for (unsigned int i = 0; i < userPlaylists.size(); i++) {
				for (unsigned int j = 0; j < userPlaylists.at(i).GetList().size(); j++) {
					if (userPlaylists.at(i).GetList().at(j)->GetTitle() == songLibrary.at(songIndex)->GetTitle()) {
						userPlaylists.at(i).DelSong(j);
					}
				}
			}

			//Delete and Free the memory on the heap for this song
			delete songLibrary.at(songIndex);

			//Remove Pointer from library
			songLibrary.erase(songLibrary.begin() + songIndex);

		} else if (userSelection == "quit") {
			//Do nothing just proceed to the end of the loop	
		} else { // If the user asks for options or has invalid input
			cout << "add\tAdds a list of songs to the library" << endl;
			cout << "list\tLists all the songs in the library" << endl;
			cout << "addp\tAdds a new playlist" << endl;
			cout << "addsp\tAdds a song to a playlist" << endl;
			cout << "listp\tLists all the playlists" << endl;
			cout << "play\tPlays a playlist" << endl;
			cout << "delp\tDeletes a playlist" << endl;
			cout << "delsp\tDeletes a song from a playlist" << endl;
			cout << "delsl\tDeletes a song from the library(and all playlists)" << endl;
			cout << "options\tPrints this options menu" << endl;
			cout << "quit\tQuits the program" << endl << endl;
		}

	} while (userSelection != "quit");
	
	// Delete the songs on the heap FREE THE MEMORY
	for (unsigned int i = 0; i < songLibrary.size(); i++) {
		delete songLibrary.at(i);
	}

	cout << "Goodbye!" << endl;

	return 0;
}


