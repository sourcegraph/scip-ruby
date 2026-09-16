# typed: true
# enable-experimental-rbs-comments: true
# options: showDocs

class RBSKeywordReceiver
  #: (customer: String, ?enabled: bool) -> String
  def deliver(customer:, enabled: true)
    customer.upcase
  end

  #: (customer: String) -> void
  def unused(customer:)
  end

  #: (customer: String) -> void
  def self.deliver(customer:)
  end
end

customer = "Ada"
RBSKeywordReceiver.new.deliver(customer:, enabled: true)
RBSKeywordReceiver.new.unused(customer: customer)
RBSKeywordReceiver.deliver(customer:)
