# typed: true
# check-errors: true
# Adapted from test/testdata/infer/infer_lambda.rb and infer_proc.rb.

class InferredProduct
  extend T::Sig

  sig { returns(String) }
  def name
    "product"
  end
end

arrow_factory = -> { InferredProduct.new }
arrow_factory.call.name.upcase

lambda_factory = lambda { InferredProduct.new }
lambda_factory.call.name.upcase

proc_factory = proc { InferredProduct.new }
proc_factory.call.name.upcase

return_factory = ->(early) do
  return InferredProduct.new if early
  InferredProduct.new
end
return_factory.call(true).name.upcase

next_factory = proc do |early|
  next InferredProduct.new if early
  InferredProduct.new
end
next_factory.call(false).name.upcase
