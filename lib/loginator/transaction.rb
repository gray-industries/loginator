module Loginator
  # Methods for generating transactional metadata.
  module Transaction
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
