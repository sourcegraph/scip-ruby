# typed: true
# check-errors: true
# options: showDocs

class KeywordReceiver
  extend T::Sig

  sig { params(customer: String, enabled: T::Boolean).returns(String) }
  def deliver(customer:, enabled: true)
    customer = customer.upcase if enabled
    [1].each { customer.downcase }
    ["shadow"].each { |customer| customer.upcase }
    customer
  end

  sig { params(customer: String).void }
  def unused(customer:)
  end

  sig { params(customer: String).returns(String) }
  def self.deliver(customer:)
    customer
  end

  alias copied deliver

  sig { params(values: Integer, customer: String, block: T.nilable(T.proc.void)).returns(String) }
  def wrapped(*values, customer:, &block)
    block.call if block
    customer
  end

  sig { params(extras: String).void }
  def extras(**extras)
  end

  sig { params(options: T::Hash[Symbol, String]).void }
  def positional(options)
  end
end

class KeywordChild < KeywordReceiver
end

class KeywordSibling < KeywordReceiver
end

class OtherKeywordReceiver
  extend T::Sig
  sig { params(customer: String, enabled: T::Boolean).returns(String) }
  def deliver(customer:, enabled: false)
    customer
  end
end

class KeywordOverride < KeywordReceiver
  extend T::Sig
  sig { override.params(customer: String, enabled: T::Boolean).returns(String) }
  def deliver(customer:, enabled: true)
    super(customer:, enabled:)
  end
end

class KeywordConstructor
  extend T::Sig
  sig { params(customer: String).void }
  def initialize(customer:)
    @customer = customer
  end
end

class KeywordCaller
  extend T::Sig

  sig { params(receiver: T.any(KeywordReceiver, OtherKeywordReceiver), customer: String).void }
  def union(receiver, customer:)
    receiver.deliver(customer:)
  end

  sig { params(receiver: T.any(KeywordChild, KeywordSibling), customer: String).void }
  def inherited_union(receiver, customer:)
    receiver.deliver(customer:)
  end

  sig { params(customer: String).returns(String) }
  def defaults(customer: KeywordReceiver.new.wrapped(*[1], customer: "default"))
    customer
  end

  sig { params(receiver: T.untyped, customer: String).void }
  def dynamic(receiver, customer:)
    receiver.deliver(customer:)
  end
end

receiver = KeywordReceiver.new
customer = "Ada"
receiver.deliver(customer: customer, enabled: true)
receiver.deliver(customer:)
receiver.deliver(:customer => customer)
receiver.deliver("customer": customer)
receiver.copied(customer:)
KeywordChild.new.deliver(customer:)
KeywordReceiver.deliver(customer:)
receiver.unused(customer:)
KeywordConstructor.new(customer:)
KeywordOverride.new.deliver(customer:)

block = T.let(-> {}, T.proc.void)
receiver.wrapped(customer:, &block)
receiver.wrapped(*[1, 2], customer: customer)
receiver.wrapped(*[1, 2], customer:, &block)
receiver.wrapped(*[1, 2], customer:) { customer.upcase }

# These keys are data, not named parameter references.
receiver.extras(customer: customer)
receiver.positional(customer: customer)
keywords = {customer: customer}
receiver.deliver(**keywords)
receiver.deliver(**{customer: customer})
