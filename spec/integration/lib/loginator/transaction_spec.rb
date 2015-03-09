require 'loginator/transaction'

RSpec.describe Loginator::Transaction do
  describe '#new' do
    before do
      subject.finished
    end

    context 'using defaults' do
      it 'creates a valid object' do
        expect(subject).to be_a_kind_of(described_class)
      end

      it 'sets default request id' do
        expect(subject.uuid).to be_a_kind_of(String)
      end

      it 'sets default timestamp' do
        expect(subject.timestamp).to be_a_kind_of(Time)
        expect(subject.timestamp).to be <= Time.now
      end
    end

    context 'overriding defaults' do
      let(:uuid) { 'uuid' }
      let(:timestamp) { Time.at(42) }
      let(:path) { '/' }

      subject { described_class.new(uuid: uuid, timestamp: timestamp, duration: 0, path: path) }

      [:uuid, :timestamp, :path].each do |field|
        it 'overrides defaults' do
          expect(subject.send(field)).to eq(send(field))
        end
      end

      describe '.from_json' do
        it 'faithfully deserializes' do
          expect(described_class.from_json(subject.to_json)).to eq(subject)
        end
      end
    end
  end

  describe '#finished' do
    before do
      subject.finished
    end

    it 'sets a positive float for the duration' do
      expect(subject.duration).to be_a_kind_of(Float)
      expect(subject.duration).to be > 0.0
    end
  end

  describe '#begin' do
    shared_examples_for 'transaction#begin' do
      it 'marks the beginning of the transaction' do
        expect(subject.timestamp).to be_a_kind_of(Time)
      end

      it 'executes the block' do
        expect(@in_block.to_f).to be > subject.timestamp.to_f
      end

      it 'marks the end of the transaction after the block is finished' do
        expect((subject.timestamp + subject.duration).to_f).to be > @in_block.to_f
      end
    end

    context 'when the block executes normally' do
      before do
        subject.begin do
          sleep 0.01
          @in_block = Time.now
        end

        it_behaves_like 'transaction#begin'
      end
    end

    context 'when the block passed raises an exception' do
      before do
        expect do
          subject.begin do
            sleep 0.01
            @in_block = Time.now
            fail
          end
        end.to raise_error
      end

      it_behaves_like 'transaction#begin'
    end
  end

  describe '#to_json' do
    let(:json) { MultiJson.dump(hash) }

    let(:hash) do
      {
        'uuid' => '1',
        'timestamp' => 0.0,
        'duration' => 1.0,
        'path' => '/',
        'status' => 0,
        'request' => '',
        'response' => '',
        'params' => {}
      }
    end

    subject { described_class.from_json(json) }

    before do
      subject.finished
    end

    it 'faithfully serializes' do
      %w(uuid duration path status request response params).each do |k|
        expect(subject.send(k)).to eq(hash[k])
      end

      expect(subject.timestamp.to_f).to eq(hash['timestamp'])
    end
  end

  describe '.from_json' do
    subject { described_class.new(duration: 1.0, timestamp: Time.now) }

    before do
      subject.finished
    end

    it 'faithfully deserializes' do
      expect(described_class.from_json(subject.to_json)).to eq(subject)
    end
  end
end
