# typed: true
# check-errors: true
# enable-experimental-rspec: true
# Adapted from test/testdata/rewriter/minitest_let.rb and rspec_describe.rb.

module RSpec
  module Core
    class ExampleGroup
      def self.test_each(values, &block); end
    end
  end
  def self.describe(description, *args, &block); end
end

class Customer
  extend T::Sig
  sig { returns(String) }
  def name; "Alice"; end
end

class GeneratedAccessor
  attr_reader :ordinary
end

RSpec.describe Customer do
  describe("helpers") do
    let(:ordinary) do
      customer = Customer.new
      customer.name
    end

    let!("eager") { Customer.new.name }
    subject(:named) { Customer.new.name }

    subject do
      customer = Customer.new
      customers = T.let([customer], T::Array[Customer])
      customers.map do |customer|
        customer.name
      end
    end

    let(:empty) {}

    it("uses the helpers") { ordinary; eager; named; subject; empty }

    describe("nested helpers") do
      let("ordinary") { Customer.new.name }
      it("uses the nested helper") { ordinary; subject }
    end
  end

  test_each([1]) do |unused|
    describe("parameterized helpers") do
      let(:ordinary) { Customer.new.name }
      let!(:eager) { Customer.new.name }
      subject("named") { Customer.new.name }
      subject { Customer.new.name }
      it("uses parameterized helpers") { ordinary; eager; named; subject }
    end
  end
end
