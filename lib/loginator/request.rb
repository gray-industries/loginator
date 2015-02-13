require 'multi_json'
require 'loginator/jsonable_struct'
require 'loginator/transaction'

# Loginator::Request
module Loginator
  # A request is a tuple of a (UUID, Timestamp, Path, Parameters). Requests parameters are defined subjectively by the
  # user. For example, in the example Rack middleware ({#Rack::Loginator::Logging}), we define params as the request
  # body (our HTTP APIs tend to accept JSON bodies as opposed to parameters attached to the URL). You may also wish
  # to consider part of the HTTP headers as a request parameter.
  #
  Request = Struct.new(:request_id, :timestamp, :path, :params) do
    include Loginator::JsonableStruct
    include Loginator::Transaction

    # Create a new Loginator::Request
    # @param request_id [String] (SecureRandom.uuid) Unique identifier for the request
    # @param timestamp [Float]   (Time.now.utc.to_f) Time of the request
    # @param path [String]       (nil)               Path associated with the request
    # @param params [String]     ({})                Parameters of the request
    def initialize(request_id = uuid, timestamp = format_time, path = nil, params = {})
      super
    end
  end
end
