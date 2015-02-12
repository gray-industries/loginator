require 'multi_json'

module Loginator
  # Makes a Struct easily serializable and deserializable. Adds the
  # from_hash class method and to_json instance method to Struct
  # classes.
  module JsonableStruct
    def self.included(base)
      base.extend ClassMethods
    end

    # class level mixins
    module ClassMethods #:nodoc
      def from_hash(hsh)
        fail(ArgumentError, format('Hash must contain keys: %s', members.join(', '))) unless valid_hash?(hsh)
        new(*hsh.values)
      end

      private

      def valid_hash?(hsh)
        # Loosely validate that all necessary keys are present...
        # This does mean that we could potentially create a Response from a hash
        # representing an object _like_ a response.... Feature or... ? ^_^
        members & hsh.keys.map(&:to_sym) == members
      end
    end #:rubocop:enable documentation

    def to_json
      MultiJson.dump(to_h)
    end
  end
end
