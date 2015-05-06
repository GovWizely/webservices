trade.gov Webservices
==============

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

### Redis

You'll need to have redis installed on your machine. `brew install redis`, `apt-get install redis-server`, etc.

### Running it

Fire up a server and try it all out.

    foreman start -f Procfile.dev
    bundle exec rake ita:import[ScreeningList,MarketResearchData]

<http://127.0.0.1:3000/consolidated_screening_list/search?size=5&offset=8>

<http://127.0.0.1:3000/consolidated_screening_list/search?q=john>

<http://127.0.0.1:3000/consolidated_screening_list/search?sources=SDN,EL>

<http://127.0.0.1:3000/market_research_library/search?q=oil>

<http://127.0.0.1:3000/market_research_library/search?countries=HU,CA>

### Tests

These require an [ElasticSearch](http://www.elasticsearch.org/) server to be running.

    bundle exec rspec

### Code Coverage

We track test coverage of the codebase over time, to help identify areas where we could write better tests and to see when poorly tested code got introduced.

After running your tests, view the report by opening `coverage/index.html`.

Click around on the files that have < 100% coverage to see what lines weren't exercised.

### Mailcatcher

We use [Mailcatcher](http://mailcatcher.me/) to test emails sent from dev environments. Their advice is not to add the gem to your Gemfile, so in order
to use it please do:

    gem install mailcatcher
    mailcatcher

If you use [RVM](https://rvm.io/), you should follow their [specific instructions](http://mailcatcher.me/) (search for "RVM") on how to install the gem.

### Code Status

* [![Build Status](https://travis-ci.org/GovWizely/webservices.svg?branch=master)](https://travis-ci.org/GovWizely/webservices/)
* [![Test Coverage](https://codeclimate.com/github/GovWizely/webservices/badges/coverage.svg)](https://codeclimate.com/github/GovWizely/webservices)
* [![Code Climate](https://codeclimate.com/github/GovWizely/webservices/badges/gpa.svg)](https://codeclimate.com/github/GovWizely/webservices)

