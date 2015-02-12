module Rack
  module Loginator
    # Log all the things.
    class Uuid
      attr_reader :app

      def call(env)
        env['X-REQUEST-UUID'] ||= SecureRandom.uuid
        @app.call(env)
      end
    end
  end
end
