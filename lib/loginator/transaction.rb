require 'securerandom'

module Loginator
  # A Loginator::Transaction is meant to encapsulate a single
  # request/response cycle.
  class Transaction
    class << self
      # @param [String] json JSON body of the given transaction
      # @return [Transaction]
      def from_json(json)
        obj = MultiJson.load(json, symbolize_keys: true)
        Transaction.new(filter_hash(obj))
      end

      protected

      # This is the inverse functions for the instance-level
      # filter_hash.
      def filter_hash(hsh)
        [[:timestamp, ->(t) { Time.at(t) }]].map do |k, f|
          hsh[k] = f.call(hsh[k])
        end
        hsh
      end
    end

    attr_reader :uuid, :timestamp, :status, :path, :request, :params, :response, :duration

    protected

    attr_writer :uuid, :timestamp, :status, :path, :request, :params, :response, :duration

    public

    # Create a new Loginator::Transaction
    # @param [Hash] opts The options to create the Loginator::Transaction
    # @option opts [String]  :uuid UUID (SecureRandom.uuid)
    # @option opts [Time]    :timestamp (Time.now) Beginning timestamp of transaction
    # @option opts [Integer] :status Status returned to the requester
    # @option opts [String]  :path  Path associated with the request
    # @option opts [String]  :request Body of the request
    # @option opts [Hash]    :params Parameters of the request
    # @option opts [String]  :response Body of the response
    # @option opts [Float]   :duration Duration of the request
    def initialize(opts = {})
      @uuid = opts.delete(:uuid) || SecureRandom.uuid
      @timestamp = opts.delete(:timestamp) || Time.now
      @duration = opts.delete(:duration)
      opts.each_pair do |k, v|
        send("#{k}=", v)
      end
    end

    # Marks the beginning of a Transaction. Optionally, will execute
    # the given block in the context of a transaction, returning the
    # last line of the block and raising any exceptions thrown in the
    # block given.
    #
    # NOTE: we make a best effort to guarantee that `transaction.finished`
    # is called via an ensure block, but that is all. We do not set the
    # status or response. You must do so in your block if you wish to
    # record any failures.
    # @param [Block] &blk optional
    def begin
      @timestamp = Time.now
      yield self if block_given?
    ensure
      finished
    end

    # Marks the end of the transaction.
    #
    # NOTE: Once set, duration should be considered immutable. I.e. you
    # cannot affect the duration of this Transaction by calling finished
    # twice.
    # @return [Time] time of the end of the transaction
    def finished
      fin = Time.now
      @duration ||= calculate_duration(fin)
      fin
    end

    # Hashify the Transaction
    # @return [Hash]
    def to_h
      [:uuid, :timestamp, :status, :path, :request, :params, :response, :duration].each_with_object({}) do |key, hsh|
        hsh[key] = send(key)
      end
    end

    # JSONify the Transaction
    # @return [String]
    def to_json
      MultiJson.dump(filter_hash!(to_h))
    end

    # Two Transactions are considered equivalent if the following
    # are all equal:
    # UUID, Duration, Response, Path, Request, Parameters.
    # This is largely used for testing serialization/deserialization.
    def ==(other)
      timestamp.to_f == other.timestamp.to_f &&
        [:uuid, :duration, :response, :path, :request, :params].all? { |k| send(k) == other.send(k) }
    end

    protected

    # @param [Time] t ending timestamp of the transaction
    # @return [Float] duration of the transaction
    def calculate_duration(t)
      (t - timestamp).to_f
    end

    # Filter the transaction hash's elements based on a mapping of
    # element->proc pairs. This is largely for serialization/deserialization.
    def filter_hash!(hsh)
      [[:timestamp, ->(t) { t.to_f }]].each do |k, f|
        hsh[k] = f.call(hsh[k])
      end
      hsh
    end
  end
end
