# typed: true
# enable-experimental-rbs-comments: true

module Ranges
  module Models
    class Customer
      #: -> String
      def name
        "customer"
      end
    end

    #: type customer = Customer
  end

  #: type customer = ::Ranges::Models::Customer
  #: type copy = Ranges::Models::customer
  #: type pair = [
  #|   Ranges::Models::customer,
  #|   ::Ranges::Models::Customer
  #| ]
  #: type optional =
  #|   Ranges::Models::customer?

  #: [out Elem <
  #|   ::Ranges::Models::Customer]
  class Box
    #: Elem
    attr_reader :value

    #: (Elem) -> void
    def initialize(value)
      @value = value
    end
  end

  #: [Elem = Ranges::Models::Customer]
  class Fixed; end

  class Reader
    #: Ranges::Models::customer
    attr_reader :customer

    #: (Ranges::Models::Customer) -> void
    def initialize(customer)
      @customer = customer
    end
  end
end

#: (Ranges::customer) -> Ranges::copy
def customer_echo(value)
  value
end

#: (
#|   ::Ranges::Models::customer,
#|   Ranges::Models::Customer
#| ) -> Ranges::pair
def pair(first, second)
  [first, second]
end

#: (Ranges::optional) -> Ranges::optional
def optional(value)
  value
end

#: [Elem] (Elem?) -> Elem?
def generic(value)
  value #: Elem?
end

#: (Array[Ranges::Models::Customer]) -> Array[Ranges::Models::customer]
def customers(values)
  values
end

#: (Enumerator::Lazy[Ranges::customer]) -> ::Enumerator::Lazy[Ranges::customer]
def lazy(values)
  values
end

#: (Enumerator::Chain[Ranges::customer]) -> ::Enumerator::Chain[Ranges::customer]
def chain(values)
  values
end

customer = Ranges::Models::Customer.new
customer_echo(customer).name
Ranges::Reader.new(customer).customer.name
pair(customer, customer)
optional(customer)
generic(customer)
customers([customer])
box = Ranges::Box.new(customer) #: Ranges::Box[Ranges::Models::Customer]
box.value.name
fixed = Ranges::Fixed.new #: Ranges::Fixed
value = customer #: Ranges::Models::customer
value.name

# Handwritten Sorbet syntax must keep its own T and type references.
T.let(customer, T.nilable(Ranges::Models::Customer))
