# typed: true
# check-errors: true
# options: showDocs

module KeywordMixin
  extend T::Sig
  sig { params(customer: String).returns(String) }
  def deliver(customer:)
    customer.upcase
  end
end

class CrossFileKeywords
  include KeywordMixin
  extend T::Sig

  sig { params(customer: String).void }
  def unused(customer: "default")
  end
end
