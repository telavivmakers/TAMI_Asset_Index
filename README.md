


# TAMI Space Catalogue

_by Wylie Kulik_
[kulicuu]()


### Preface: A User Story

Recently I arrived at TAMI as a resident volunteer and set upon a course of maintenance, cleaning, organisation, etc.  There was and is a lot of stuff, some of it which needs to be thrown out, some broken, some useful, some useful but redundant, some valuable but broken. There are lots of things that belong to members as part of projects -- it's not always clear what belongs to who, what belongs to no one, what needs to be thrown out, given away etc.  It is clear that we need to create more space, and that some stuff can be gotten rid of but it is not clear from item to item what.


### An Idea:

It occured to me that it would be nice to have a perfect organisation and information system for this, so I thought to make a simple database which covered every little space and location in the TAMI space, and listed what was there, who owned it, contact details and so on and so forth.  This would make it a much simpler matter to determine given a space &or item what it was and what could be done with it, if anything.  There would be an interface available to anyone with a web browser, and also an in-space terminal set up with access, probably also through a web-browser.



### Initial Design:

- We'll need to label all the spaces (for example all the shelving will need some sticker labels with codes written on them identifying the slot location.)

- I'll use Redis for the DB, simply because I like it. Should be fast, but will also save to disk.

- NodeJS server and ReactJS webclient connected with Primus for Websockets.  This may seem like overkill but will allow realtime change viewing by any connected client.


### Extended possibilities:

This could conceivably become a quite elaborate card-catalogue-esque system of organisation for all kinds of TAMI assets.  For example the electronic equipment and supplies could be tracked with the system.  Tools, materials, so on and so forth.


- Lost and Found



### App Design

Web-app with primary focus on mobile compatibility.  Will follow pattern used recently for a commercial game.
