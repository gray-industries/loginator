# Loginator

Loginator is a gem for standardizing the logging of requests and responses for
remote APIs.

## Installation

Add this line to your application's Gemfile:

    gem 'loginator'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install loginator

## Usage

Remote APIs (be they HTTP or otherwise) follow a pattern fairly similar to that
of a common HTTP API. 

### Requests

A request is typically made to a path with request parameters. We attach
metadata to this request in order to track it throughout a distributed system.
This metadata includes a unique identifier and a UTC timestamp.

### Responses

A response is typically yielded to requests. It includes the same metadata
as a request, but also a response typically has associated with it a status
code indicating success or failure of some kind (we have chosen to standardize
around HTTP status codes -- or some interpretation thereof). Like a request,
a response typically also contains a body.

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
