# typed: true
# Adapted from test/testdata/lsp/rename/locals.rb.

class DifferentScopeLevels
  def shadowing
    variable = "outer"
    [1, 2, 3].map do |variable|
      variable.to_s
    end
    variable
  end

  def block_local
    5.times do
      local = 123
      local * 5
    end
    local = "different"
    local
  end

  def captured
    higher = 123
    5.times do
      higher = 321
    end
    higher
  end

  def branches(condition)
    if condition
      value = 0
    else
      value = ""
    end
    value
  end
end
