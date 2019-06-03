#include "Song.h"
#include <iostream>

using namespace std;

Song::Song() {
	songTitle = "";
	firstLine = "";
	numTimePlayed = 0;
}

Song::Song(string songTitle, string firstLine) {
	this->songTitle = songTitle;
	this->firstLine = firstLine;
	numTimePlayed = 0;
}

void Song::Print() {
	cout << songTitle << ": \"" << firstLine << "\", " << numTimePlayed << " play(s)." << endl;
}

string Song::PlaySong() {
	++numTimePlayed;
	return firstLine;
}
