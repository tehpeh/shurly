Shurly
======

Introduction
------------

A URL shortener.

Development and Testing
-----------------------

### Dependencies:

sqlite3

### Setup:

cp config/database.example.yml config/database.yml

bundle install

rake db:migrate

RACK_ENV=test rake db:migrate

### Run:

rackup [-p 3000 -s thin]

### Testing:

autotest

Deployment
----------

[Heroku](http://www.heroku.com/)

License
-------
This work is licensed under a [Creative Commons Attribution-ShareAlike 3.0 Unported License](http://creativecommons.org/licenses/by-sa/3.0/).