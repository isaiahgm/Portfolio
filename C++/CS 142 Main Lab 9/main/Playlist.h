#ifndef PLAYLIST_H
#define PLAYLIST_H

#include <iostream>
#include <vector>
#include <string>
#include "Song.h"

using namespace std;

class Playlist {
	private:
		string name;
		vector<Song*> list;
	public:
		Playlist(string name);
		string GetName() { return name; }
		vector<Song*> GetList() { return list; }
		void AddSong(Song* newSong) { list.push_back(newSong); }
		void DelSong(int index) { list.erase(list.begin() + index); }
};


#endif