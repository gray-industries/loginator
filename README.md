# Loginator

[![Code Climate](https://codeclimate.com/github/gray-industries/loginator/badges/gpa.svg)](https://codeclimate.com/github/gray-industries/loginator)
[![Build Status](https://travis-ci.org/gray-industries/loginator.svg)](https://travis-ci.org/gray-industries/loginator)

Loginator is a gem for standardizing different types of log formats. It particularly focuses on standardized
logging for service interactions in a SOA / distributed application.

I am tired of having useless logs at work, and I wanted to standardize those logs. Jordan Sissel puts it
much better than me:

> I want to be able to log in a structured way and have the log output know how that should be formatted.
> Maybe for humans, maybe for computers (as JSON), maybe as some other format. Maybe you want to log to a
> csv file because that's easy to load into Excel for analysis, but you don't want to change all your
> applications log methods?

I found this in the README.md for ruby-cabin (jordansissel/ruby-cabin). When I read this, I was pretty
floored. "Someone else get it." This is exactly what I'm trying to accomplish with Loginator, but
I want to take Cabin just a step further. It's intended for use in my Gray Industries projects, but
if someone else finds it useful, that would be amazing.

## Installation

Requires Ruby >= 2.0

Add this line to your application's Gemfile:

    gem 'loginator'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install loginator

## Usage

Remote APIs (be they HTTP or otherwise) follow a pattern fairly similar to that
of a common HTTP API. 

### Transactions

Transactions include the following fields:
  - uuid (string)
  - timestamp (serialized as a float, otherwise Time)
  - duration (float)
  - path (string)
  - status (integer)
  - request (string)
  - response (string)
  - params (hash)

Custom transactions can be made by extending Transaction. These custom transactions
could include additional fields, change field types, etc. In general, however, API
transactions have all or most of these characteristics regardless of protocol.

To use a transaction, wrap your API response generation in a Transaction#begin block
like so (as seen in the Sinatra middleware):

```
Loginator::Transaction.new.begin do |txn|
  txn.path = env['PATH_INFO']
  txn.request = req
  status, _headers, body = @app.call(env)
  txn.status = status
  txn.response = body
  [status, _headers, body]
end
```

The begin method will return the last line much like a function, allowing you
to seemlessly integrate transaction logging into your middleware.

## Middleware

This Gem includes middleware. I am not adding explicit dependencies on the frameworks I'm targeting.
that being said, I do want to document the version of those frameworks and have put a separate Gemfile
in `lib/loginator/middleware` that includes the appropriate development dependencies required for
for testing and development. I am also adding that Gemfile to the gem's root Gemfile to make testing
and contributing easier. I feel it is necessary to draw this distinction, because Loginator does not
explicitly require those gems.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## Testing

The Rakefile comes with several convenience tasks for running tests as well. By rake task:

  + `spec`: Runs all rspec tests in the spec directory.
  + `yard`: Generates yard documentation.
  + `rubocop`: Runs rubocop.
  + `run_guards`: Runs all guards.

`run_guards` is the one you're most likely to want to run, since it runs all the other test-related tasks.
