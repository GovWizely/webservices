trade.gov Webservices
==============

## I Can Haz Docker?

If you have [Docker](http://docker.io/) and [Fig](http://fig.sh/), all you have to do is

    $ fig up

And it should automatically bring up the ElasticSearch container and the rails app,
correctly linking them.

Otherwise, follow the standard setup instructions.

## Standard setup

### Ruby

You'll need [Ruby 2.1](http://www.ruby-lang.org/en/downloads/).

### Gems

We use bundler to manage gems. You can install bundler and other required gems like this:

    gem install bundler
    bundle install

### ElasticSearch

We're using [ElasticSearch](http://www.elasticsearch.org/) (>= 1.2.0) for fulltext search. On a Mac, it's easy to install with [Homebrew](http://mxcl.github.com/homebrew/).

    brew install elasticsearch

Otherwise, follow the [instructions](http://www.elasticsearch.org/download/) to download and run it.

### Running it

Fire up a server and try it all out.

    bundle exec rake ita:import[TradeEvent::Ita] ita:import[ItaOfficeLocation]
    bundle exec rails s

<http://127.0.0.1:3000/trade_events/ita/search?size=5&offset=8>

<http://127.0.0.1:3000/trade_events/ita/search?q=electrical>

<http://127.0.0.1:3000/trade_events/ita/search?countries=US,CA>

<http://127.0.0.1:3000/trade_events/ita/search?industry=agriculture>

<http://127.0.0.1:3000/ita_office_locations/search?q=new>

<http://127.0.0.1:3000/ita_office_locations/search?country=BR>

<http://127.0.0.1:3000/ita_office_locations/search?country=US&state=DC&q=national>

### Tests

These require an [ElasticSearch](http://www.elasticsearch.org/) server to be running.

    bundle exec rake

### Code Coverage

We track test coverage of the codebase over time, to help identify areas where we could write better tests and to see when poorly tested code got introduced.

After running your tests, view the report by opening `coverage/index.html`.

Click around on the files that have < 100% coverage to see what lines weren't exercised.

### Code Status

* [![Build Status](https://travis-ci.org/GovWizely/webservices.svg?branch=master)](https://travis-ci.org/GovWizely/webservices/)
* [![Test Coverage](https://codeclimate.com/github/GovWizely/webservices/badges/coverage.svg)](https://codeclimate.com/github/GovWizely/webservices)
* [![Code Climate](https://codeclimate.com/github/GovWizely/webservices/badges/gpa.svg)](https://codeclimate.com/github/GovWizely/webservices)

