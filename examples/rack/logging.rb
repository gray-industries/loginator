module Rack
  module Loginator
    # Log all the things.
    class Logging
      attr_reader :app, :level

      # @param app [Rack::App] #{Rack::App} being passed through middleware chain
      # @option opts [Symbol] :level (:info) Default logging level
      def initialize(app, level: :info)
        @app = app
        @level = level
      end

      def call(env)
        req = Rack::Request.new(env)
        request = Loginator::Request.new(env['X-REQUEST-UUID'], Time.now.utc.to_s, env['REQUEST_PATH'], req.body.read)
        logger.send(level, request)
        req.body.rewind
        @app.call(env).tap do |status, _headers, body|
          response = Loginator::Response.new(env['X-REQUEST-UUID'], Time.now.utc.to_s, env['REQUEST_PATH'], status, body)
          logger.send(level, response)
        end
      end
    end
  end
end
