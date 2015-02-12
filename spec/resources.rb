def resource(filename)
  File.expand_path("../resources/#{filename}", __FILE__)
end

module Loginator
  module Test
    # This should include test-specific resources (i.e. pre-built uniform objects)
    # that are required in order to run your specs. It is largely an object
    # factory for building objects for testing.
    #
    # @example
    # Loginator::Test::Resources::LoggedInUser
    module Resources
    end
  end
end
