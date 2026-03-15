# Sword Masters
Sword Masters roblox experience presented by MOG Studios, Scripted by Marcos.
This revamped version of the project started on September, 2024.

# Why this repo?

This is a game I made from scratch for a Roblox group I am no longer a member of, based on one of their own games because it had many bugs and was a technical disaster. I don't really remember why this project was stopped, I just know that this version I was making for some strange reason was also a disaster, from bugs that appeared where they shouldn't to the equivalent of very arbitrary undefined behavior in Luau.
I could swear that this game was haunted (sic) or something "engine-level undefined behavior", because whatever I scripted, it would bug out where it normally wouldn't. 
So today, now that this game no longer works and has been archived (ahem, abandoned), I'm publishing its source code as an example of what my mental concept of a Roblox game made with Knit was like at the time. Of course, I've improved, I've evolved, and I can write better code, but I'll never know why this game was so broken.


# Technology
Sword Masters is based on the Knit Framework with modularized scripts named "Services" and "Controllers"
The main entry point in the server is Server/ServerBegin. In the client is First/ClientBegin, and from there on, the services execute code by themselves.
There can be isolated scripts, that are intented for control and specific things, but that should be avoided.

Data saving is based on ProfileService.
NPCs are based in SimplePath.

I may not be able to upload the original .rblx, because it has tons of sprites that are not mine.
