# typed: true
# check-errors: true
# enable-experimental-rspec: true

module RSpec
  module Core
    class ExampleGroup
      def self.it(name, &block); end
      def self.let(name, &block); end
      def helper; 'helper'; end
    end
  end
  def self.describe(name, &block); end
end

value = 'captured'
RSpec.describe 'captures file scope' do
  let(:captured_helper) { value.downcase }
  it 'keeps both instance self and lexical locals' do
    value.upcase
    helper
    captured_helper
  end
end
