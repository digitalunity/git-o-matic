git-o-matic
===========

Pseudo Automation of Git interaction
###Overview
This is a bash script using a touch of sed which allows you to enter settings of a development repository and a live repository. Then with each of these the ability to check commits, push and pull is given.

Rather skip to a video to show you what I mean? See Here http://www.youtube.com/watch?v=e9RhZfJ0T-Q&feature=youtu.be

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





