shared_examples_for 'struct_with_defaults' do
  describe '#new' do
    context 'using defaults' do
      it 'creates a valid object' do
        expect(subject).to be_a_kind_of(described_class)
      end

      it 'sets default request id' do
        expect(subject.request_id).to be_a_kind_of(String)
      end

      it 'sets default timestamp' do
        expect(subject.timestamp).to be_a_kind_of(Float)
        expect(subject.timestamp).to be <= Time.now.utc.to_f
        expect(subject.timestamp).to be > 0.0
      end
    end

    context 'overriding defaults' do
      let(:request_id) { 'uuid' }
      let(:timestamp) { 42 }
      let(:path) { '/' }

      subject { described_class.new(request_id, timestamp, path) }

      [:request_id, :timestamp, :path].each do |field|
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
end
