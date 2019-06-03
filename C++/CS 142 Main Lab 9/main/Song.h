#ifndef SONG_H
#define SONG_H

#include <iostream>
#include <string>

using namespace std;

class Song {
	private:
		string songTitle;
		string firstLine;
		int numTimePlayed = 0;

	public:
		Song();
		Song(string songTitle, string firstLine);
		string GetTitle() { return songTitle; }
		string PlaySong();
		void Print();
};

#endif