require 'loginator/middleware/sinatra'
require 'rack'

describe Loginator::Middleware::Sinatra do
  let(:app) { ->(_env) { response } }
  let(:response) { [200, env, 'app'] }
  let(:env) { Rack::MockRequest.env_for('http://test/path', input: body) }
  let(:body) { StringIO.new('Request body') }
  let(:logger) { StringIO.new }
  let(:transaction) { subject.transaction }

  subject { described_class.new(app, logger) }

  before do
    subject.call(env)
  end

  it 'adds the UUID to the sinatra env' do
    expect(transaction.uuid).to be_a_kind_of(String)
  end

  it 'rewinds the Sinatra request body' do
    expect(body.eof?).to be_falsey
  end

  it 'sets the request path' do
    expect(transaction.path).to eq('/path')
  end

  it 'sets the request body' do
    expect(transaction.request).to eq(body.string)
  end

  it 'sets the timestamp' do
    expect(transaction.timestamp).to be_a_kind_of(Time)
  end

  context 'app call succeeds' do
    it 'sets the response code' do
      expect(transaction.status).to eq(200)
    end

    it 'sets the response body' do
      expect(transaction.response).to eq('app')
    end
  end

  context 'app call fails' do
    it 'still logs the message' do
      expect(logger.string.chomp).to eq(transaction.to_json)
    end
  end
end
