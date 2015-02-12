require 'multi_json'
require 'loginator/jsonable_struct'

# Loginator::Response
module Loginator
  # A {#Loginator::Response} is a response to a {#Loginator::Request}. It should include the same elements as a
  # request, plus the status of the response (an indicator if the API request was successful or not) as well
  # as an optional response body. Whether or not to log the response is entirely left up to implementation
  # decisions and production log volume considerations. It is trivial to log response bodies in development,
  # but not in production.
  #
  Response = Struct.new(:request_id, :timestamp, :path, :status, :body) do
    include Loginator::JsonableStruct

    # Create a new Loginator::Response
    # @param [String] request_id (SecureRandom.uuid) Unique identifier for the request
    # @param [Integer] timestamp (Time.now.utc.to_i) Time of the request
    # @param [String]  path      (nil)               Path associated with the request
    # @param [Integer] status    (0)                 Status returned to the requester
    # @param [String] body       ({})                Parameters of the request
    def initialize(request_id = SecureRandom.uuid, timestamp = Time.now.utc.to_i, path = nil, status = 0, body = '')
      super
    end
  end
end
