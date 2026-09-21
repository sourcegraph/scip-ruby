# typed: true
# enable-experimental-rspec: true

module Minitest
  class Spec
    def self.describe(name, &block); end
    def self.context(name, &block); end
    def self.specify(name, &block); end
    def self.it(name, &block); end
    def self.let(name, &block); end
  end
end

module RSpec
  module Core
    class ExampleGroup
      def self.shared_context(name, &block); end
      def self.include_context(name, *args); end
      def self.describe(name, &block); end
      def self.let(name, &block); end
      def self.it(name, &block); end
    end
  end
  def self.describe(name, &block); end
end

RSpec.describe 'shared helper navigation' do
  shared_context 'unparameterized' do
    let(:ordinary) { 'ordinary' }
  end
  shared_context 'parameterized' do |name|
    let(:from_parameter) { name }
    it('reads the shared parameter') { name; from_parameter }
  end
  describe 'consumer' do
    include_context 'unparameterized'
    include_context 'parameterized', 'hello'
    it('calls both helpers') { ordinary; from_parameter }
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
