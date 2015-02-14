require 'securerandom'

module Loginator
  # Methods for generating transactional metadata.
  module Transaction
    def self.from_json(json_str)
      json = MultiJson.load(json_str)
      Loginator.const_get(json['type'].capitalize).from_hash(json)
    end

    # Generate a UUID for this transaction.
    def uuid
      SecureRandom.uuid
    end

    # Format the time as a float.
    def format_time
      Time.now.utc.to_f
    end
  end
end
