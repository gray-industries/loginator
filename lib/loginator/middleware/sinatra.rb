require 'securerandom'

module Loginator
  module Middleware
    # Middleware for logging transactions with Sinatra.
    class Sinatra
      attr_reader :app, :logger, :transaction

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
        transaction.begin do |txn|
          txn.path = env['PATH_INFO']
          txn.request = read_body(req)
          status, headers, body = @app.call(env)
          txn.status = status
          txn.response = body
          [status, headers, body]
        end
      ensure
        logger.puts(transaction.to_json)
      end

      protected

      def read_body(req)
        req.body.read
      ensure
        req.body.rewind
      end
    end
  end
end
