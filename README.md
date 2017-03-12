trade.gov Webservices
==============

The Webservices project lets you take pretty much any structured data set and turn it into a search API without writing a line of code.

# Features

* understands CSV, TSV, JSON, XLS, or XML file formats
* smart guessing of data types and schemas based on heuristics
* versioned APIs by default
* ingest by file upload or URL
* easy polling/refresh of URL-based data sources
* simple YAML-based configuration for each data source
* customize the ETL process via built-in transformations

# Installation

### Ruby

You'll need [Ruby 2.2](http://www.ruby-lang.org/en/downloads/).

### Gems

We use bundler to manage gems. You can install bundler and other required gems like this:

    gem install bundler
    bundle install
    
The `charlock_holmes` gem requires the UCI libraries to be installed. If you are using Homebrew, it's probably as simple as this:
     
     brew install icu4c

More information about the gem can be found [here](https://github.com/brianmario/charlock_holmes)             

### ElasticSearch

We're using [ElasticSearch](http://www.elasticsearch.org/) (>= 5.2.2) for fulltext search. On a Mac, it's easy to install with [Homebrew](http://mxcl.github.com/homebrew/).

    brew install elasticsearch

Otherwise, follow the [instructions](http://www.elasticsearch.org/download/) to download and run it.

### Redis

You'll need to have redis installed on your machine. `brew install redis`, `apt-get install redis-server`, etc.

### Running it

Create the indexes:

    bundle exec rake db:create
    
Generate the default admin user with username `admin@example.co` and password `1nitial_pwd`:

    bundle exec rake db:devseed    

Fire up a server:

    bundle exec rails s thin
    
Import some data:    
    bundle exec rake ita:import[ScreeningList]

Admin users can log in and monitor the progress of the Sidekiq import jobs via `/sidekiq`.

#### Authentication

Since v2 of the API, an authentication token is required for every request. Pass it on the query string:

<http://localhost:3000/consolidated_screening_list/search?api_key=devkey&size=5&offset=8>

<http://localhost:3000/consolidated_screening_list/search?api_key=devkey&q=john>

<http://localhost:3000/consolidated_screening_list/search?api_key=devkey&sources=SDN,EL>

Or using http headers:

    curl -H'Api-Key: devkey' 'http://localhost:3000/v2/consolidated_screening_list/search'

### Dynamic APIs

Admin users can create and administer search APIs from uploaded files or from URLs. The file formats supported 
include CSV, TSV, JSON, XLS, and XML. The initial admin user created with the `db:devseed` task has the `admin` flag 
set to true already. To toggle an existing user, you can do this from the Rails console:
    
    email = "admin@example.co"
    u = User.search(query: { constant_score: { filter: { term: { email: email } } } }).first
    u.update_attribute(:admin, true)

To create an API, click the `+` next to the Dynamic APIs subnav heading.

To refresh a URL-based api, you can periodically call the rake task to check for updates. Pass the `api` field from the DataSource as a parameter:

    bundle exec rake endpointme:import[business_service_providers]

### Specs

    bundle exec rspec

Elasticsearch must be running. 

### Code Coverage

We track test coverage of the codebase over time to help identify areas where we could write better tests and to see when poorly tested code got introduced.

After running your tests, view the report by opening `coverage/index.html`.

Click around on the files that have less than 100% coverage to see what lines weren't exercised.

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

