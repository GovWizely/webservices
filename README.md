trade.gov Webservices
==============

## I Can Haz Docker?

If you have [Docker](http://docker.io/) and [Docker Compose](https://docs.docker.com/compose/), all you have to do is

    $ docker-compose up

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

Webservices can use foreman to start all necessary services in development environments, including elasticsearch. elasticsearch attempts to use ./elasticsearch.yml as its config file, but that file doesn't actually exist in the repository. You must symlink your system's actual elasticsearch config file to ./elasticsearch.yml. If using homebrew on OSX, you can do this as follows:

    $ brew info elasticsearch
    ...
    Or, if you don't want/need launchctl, you can just run:
        elasticsearch --config=/path/to/config/elasticsearch.yml

    $ ln -s /path/to/config/elasticsearch.yml .

### Redis

You'll need to have redis installed on your machine. `brew install redis`, `apt-get install redis-server`, etc.

### Running it

Create the indexes:

    bundle exec rake db:create
    
Generate an admin user:

    bundle exec rake db:devseed    

Fire up a server:

    foreman start -f Procfile.dev
    
Or, if you already have Elasticsearch and Redis running because the web and sidekiq actions timeout in `Procfile.dev`, you can start foreman like this:

    foreman start -f Procfile_no_es_redis.dev
    
    
Import some data:    
    bundle exec rake ita:import[ScreeningList,MarketResearchData]

#### Authentication

Since v2 of the API, an authentication token is required to every request. Pass it on the query string:

<http://localhost:3000/market_research_library/search?api_key=devkey>

<http://localhost:3000/consolidated_screening_list/search?api_key=devkey&size=5&offset=8>

<http://localhost:3000/consolidated_screening_list/search?api_key=devkey&q=john>

<http://localhost:3000/consolidated_screening_list/search?api_key=devkey&sources=SDN,EL>

<http://localhost:3000/market_research_library/search?api_key=devkey&q=oil>

<http://localhost:3000/market_research_library/search?api_key=devkey&countries=HU,CA>

Or using http headers:

    curl -H'Api-Key: devkey' 'http://localhost:3000/v2/market_research_library/search'

### Specs

    bundle exec rspec

Elasticsearch must be running. It's easiest to just `foreman start -f Procfile.dev`.

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

### Deployment

If you want to run this app on AWS Opsworks, you may find [this guide](https://github.com/GovWizely/webservices/wiki/How-to:-set-up-a-fully-decoupled-AWS-Stack) helpful.

### Code Status

* [![Build Status](https://travis-ci.org/GovWizely/webservices.svg?branch=master)](https://travis-ci.org/GovWizely/webservices/)
* [![Test Coverage](https://codeclimate.com/github/GovWizely/webservices/badges/coverage.svg)](https://codeclimate.com/github/GovWizely/webservices)
* [![Code Climate](https://codeclimate.com/github/GovWizely/webservices/badges/gpa.svg)](https://codeclimate.com/github/GovWizely/webservices)

