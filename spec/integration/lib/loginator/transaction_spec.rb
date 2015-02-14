require 'loginator/transaction'

RSpec.describe Loginator::Transaction do
  subject { Loginator.const_get(type).new }

  describe '.from_json' do
    context 'when passed a request json body' do
      let(:type) { 'Request' }

      it 'returns a request' do
        expect(Loginator::Transaction.from_json(subject.to_json)).to be_a_kind_of(Loginator::Request)
      end
    end

    context 'when passed a response json body' do
      let(:type) { 'Response' }

      it 'recognizes a response' do
        expect(Loginator::Transaction.from_json(subject.to_json)).to be_a_kind_of(Loginator::Response)
      end
    end
  end
end
