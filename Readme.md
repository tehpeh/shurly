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

cp config/database.{example.,}yml

bundle install

bundle exec rake db:migrate

RACK_ENV=test bundle exec rake db:migrate

### Run:

bundle exec rackup [-p 3000 -s thin]

### Test:

bundle exec rspec spec

### Guard (run and test):

cp Guardfile{.example,}

bundle exec guard

Deployment
----------

[Heroku](http://www.heroku.com/)

License
-------
This work is licensed under a [Creative Commons Attribution-ShareAlike 3.0 Unported License](http://creativecommons.org/licenses/by-sa/3.0/).