require 'loginator/response'
require 'support/shared/lib/loginator/jsonable_struct_spec'
require 'support/shared/lib/loginator/struct_with_defaults_spec'

RSpec.describe Loginator::Response do
  describe '#new' do
    it_behaves_like 'struct_with_defaults'
  end

  describe 'serializability' do
    it_behaves_like 'jsonable_struct'
  end
end
