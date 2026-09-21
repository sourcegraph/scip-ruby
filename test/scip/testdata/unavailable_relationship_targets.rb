# typed: false

# Top-level callbacks record fields on an ancestor without a source definition.
RSpec.configure do |config|
  config.before { @user = 'alice' }
end

describe 'nested groups' do
  before { @message = 'hello' }
  describe 'reads setup fields' do
    it('keeps the body indexed') do
      @user.to_s.upcase
      @message.to_s.downcase
      'after the missing relationship'.length
    end
  end
end

# Source-backed parent and mixin relationships must still be emitted.
module FieldMixin
  def mixed_value
    @shared = 'mixin'
  end
end

class FieldParent
  def initialize
    @shared = 'parent'
  end
end

class FieldChild < FieldParent
  include FieldMixin
  def read
    @shared.to_s.upcase
  end
end

FieldChild.new.read
