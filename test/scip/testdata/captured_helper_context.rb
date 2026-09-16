# typed: true
# check-errors: true

class CapturedHelperContext
  def self.describe(name, &block); end
  def self.context(name, &block); end
  def self.it(name, &block); end
  def self.let(name, &block); end

  def helper
    'helper'
  end

  describe 'keeps instance self alongside captured locals' do
    value = 'captured'
    let(:captured_helper) { value.downcase }
    it 'calls the instance helper' do
      value.upcase
      helper
      self.helper
      captured_helper
    end

    context 'captures through a nested group' do
      extend T::Sig
      sig { returns(String) }
      def local_helper; 'local'; end

      let(:nested_helper) { value.downcase }
      it 'keeps the closure and inherited helpers' do
        value.upcase
        helper
        self.helper
        captured_helper
        nested_helper
        local_helper.upcase
      end

      describe 'isolates an overriding helper' do
        let(:captured_helper) { value.reverse }
        it('uses the inner helper') { captured_helper; value.upcase }
      end

      it('still uses the outer helper') { captured_helper }
    end
  end
end
