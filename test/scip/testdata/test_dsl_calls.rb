# typed: true

module Minitest
  class Spec
    def self.describe(name, &block); end
    def self.context(name, &block); end
    def self.specify(name, &block); end
    def self.it(name, &block); end
    def self.let(name, &block); end
  end
end

class DSLNavigation < Minitest::Spec
  describe 'group' do
    context 'nested group' do
      let(:name) { 'hello'.upcase }
      specify 'retains the call and body' do
        value = 'world'
        value.downcase
      end
      it('uses the helper') { name }
    end
  end
end
