# typed: true
# check-errors: true

customer = "Ada"
receiver = CrossFileKeywords.new
receiver.deliver(customer: customer)
receiver.deliver(customer:)
receiver.unused(customer:)
