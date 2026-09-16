# typed: true
# check-errors: true
# Adapted from test/testdata/desugar/shadow_args.rb.

class BlockLocalScopes
  def ordinary_block
    value = "outer"
    [1, 2].each do |; value|
      value = 1
      value.times { value.to_s }
    end
    value.upcase
  end

  def proc_block
    value = "outer"
    proc { |; value|
      value = 2
      value.to_s
    }
    value.downcase
  end

  def lambda_block
    value = "outer"
    lambda do |; value|
      value = 3
      value.to_s
    end
    value.downcase
  end

  def arrow_lambda
    value = "outer"
    ->(; value) do
      value = 4
      value.to_s
    end
    value.downcase
  end
end
