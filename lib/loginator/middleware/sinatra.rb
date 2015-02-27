require 'securerandom'

module Loginator
  module Middleware
    # Middleware for logging transactions with Sinatra.
    class Sinatra
      attr_reader :app, :logger

      # @param app [Rack::App] #{Rack::App} being passed through middleware chain
      # @param logger [IO] #{IO} object where log messages will be sent via puts()
      def initialize(app, logger)
        @app = app
        @logger = logger
      end

      def call(env)
        uuid = env['X-REQUEST-ID'] ||= SecureRandom.uuid
        req = Rack::Request.new(env)
        @transaction = Loginator::Transaction.new(uuid: uuid)
        @transaction.begin do |txn|
          txn.path = env['PATH_INFO']
          txn.request = req
          status, headers, body = @app.call(env)
          txn.status = status
          txn.response = body
          logger.puts(txn)
          [status, headers, body]
        end
      end

      protected

      def request(req)
        @transaction.request = req.body.read
        req.body.rewind
      end
    end
  end
end
