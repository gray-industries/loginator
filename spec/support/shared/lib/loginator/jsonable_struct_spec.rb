shared_examples_for 'jsonable_struct' do
  describe '#to_json' do
    it 'faithfully serializes' do
      expect(subject.to_json).to eq(MultiJson.dump(subject.to_h.merge(type: described_class.type)))
    end
  end

  describe '.from_json' do
    it 'faithfully deserializes' do
      expect(described_class.from_json(MultiJson.load(subject.to_json))).to eq(subject)
    end
  end
end
