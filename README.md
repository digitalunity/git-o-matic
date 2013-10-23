git-o-matic
===========

Pseudo Automation of Git interaction

###Overview
This is a bash script using a touch of sed which allows you to enter settings of a development repository and a live repository. Then with each of these the ability to check commits, push and pull is given.

Rather skip to a video to show you what I mean? See Here [youtube](http://www.youtube.com/watch?v=e9RhZfJ0T-Q&feature=youtu.be)

###Prerequisites
Setup SSH Keys.
For this to work seamlessly, i.e. no passwords you will need to generate some keys, or copy existing ones.

1) For git
You will need to do this on any machine that is going to commit or pull changes to your repository, a good walkthrough is here.

2) For your servers
You will need to setup SSH Keys in your development and production environments, so let's say you have a dev server and a live server, both different machines and you are working remotely. You need to generate the keys on your machine if you havent already done 

	ssh-keygen -t rsa

and then copy those keys to the servers using a similar command to this, one for each server.
	ssh-copy-id -i ~/.ssh/id_rsa.pub username@server.com

Once you have done this, you should be able to test it by ssh'ing into the server

	ssh username@server

and you will be prompted, only once, to type yes to authenticate. The next time you try this it will log straight in. The same is said for all SSH interaction, including scp.


###Why A script to do this?
Firstly it's in bash because although I love ncurses I wanted to keep it as simple as possible with as little dependencies as possible.
I spend most of my daily life sat infront of black screens, staring at black terminal windows, and as a fellow dev said when I showed them the initial video a few weeks ago...
....."Ooooh nice! :D Automation = the simple life!".......

Quite a lot of my git usage is as follows:

	ssh into dev server
	enter password
	cd to working directory
	git add *
	git commit -m "Version... Comment"
	git push
	exit
	ssh into live server
	enter password
	cd to working directory
	git pull
	exit

Not any more, with the script I managed to get that whole lot (apart from the comment) down to two key presses.

By using ssh-keys for both git interaction and also between servers, it has allowed me to produce a script that automates all of this for you.

###What next?
At the moment there is so much more I would like it to do. It's kinda locked to how I use git but I plan on breaking the menu system down so that you can choose the project, then the server and then the action for those times when you really just need to type the command straight in.

Author
------

Chris Harrison

Freenode:	digitalunity_uk

Mail:		`<chris@digitalunity.co.uk>`

Twitter: 	[@digitalunity](https://twitter.com/digitalunity)

Blog:		[Blogger article on script](http://digitalunity.blogspot.co.uk/2013/10/git-automation.html)

Installation
------------

Needs none but you could make life easier by making it executable and adding it to your path.

without those (assuming you are in the same directory as the script) you can run it immediately with

	bash gitomatic.sh

License
-------

MIT license. Copyright (c) 2013 Chris Harrison


