def fixture(filename)
  File.expand_path("../fixtures/#{filename}", __FILE__)
end

module Loginator
  module Test
    # Fixtures are static content required for testing. This may include JSON bodies
    # returned from RESTful APIs, text files that need to be parsed, etc.
    module Fixtures
    end
  end
end
