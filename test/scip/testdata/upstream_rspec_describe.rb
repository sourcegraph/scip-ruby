# typed: true
# check-errors: true
# enable-experimental-rspec: true
# Adapted from test/testdata/rewriter/rspec_describe.rb.
# Generated describe classes and described_class methods can have empty name locations.

module RSpec
  module Core
    class ExampleGroup
      def self.it(name, &block); end
      def self.context(name, &block); end
      def self.describe(name, &block); end
    end
  end
  def self.describe(description, *args, &block); end
end

class Customer
  def name; "Alice"; end
end

module Billing
  class Customer
    def account; "billing"; end
  end
end

RSpec.describe Customer do
  it("indexes a constant description") do
    customer = Customer.new
    customer.name
    described_class.new.name
  end

  context("inherits the described class") do
    it("indexes a nested example") { described_class.new.name }
  end

  context Billing::Customer do
    it("uses the nested described class") { described_class.new.account }
  end

  describe Customer do
    it("indexes a nested describe") { described_class.new.name }
  end
end

RSpec.describe Billing::Customer do
  it("indexes a namespaced description") do
    Billing::Customer.new.account
    described_class.new.account
  end
end

class CustomCustomer < Customer; end

RSpec.describe CustomCustomer do
  extend T::Sig
  sig { returns(T.class_of(CustomCustomer)) }
  def described_class; CustomCustomer; end
  it("keeps a handwritten definition") { described_class.new.name }
end
