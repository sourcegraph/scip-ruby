# typed: true
# check-errors: true

# This method already has a definition in the payload. Its symbol's location
# belongs to the RBI, not to this source file.
class Exception
  def message
    "custom message"
  end
end

# Repeated definitions in one file must each use their own name range.
class RedefinedMethod
  def value
    1
  end

  def value
    2
  end
end

Exception.new.message
RedefinedMethod.new.value
