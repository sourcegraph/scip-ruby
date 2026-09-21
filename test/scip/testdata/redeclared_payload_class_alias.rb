# typed: true
# check-errors: true

# The payload already resolves these aliases to classes. Redeclaring the aliases
# clears their result types after namer has selected the classes to reopen.
Mutex = Thread::Mutex
Net::HTTPClientException = Net::HTTPServerException

class Mutex
  extend T::Sig

  sig {returns(Integer)}
  def payload_alias_method
    0
  end
end

# An alias can also be a scope within a class name.
class Mutex::Nested
  extend T::Sig

  sig {returns(String)}
  def nested_alias_method
    ""
  end
end

class Net::HTTPClientException
  extend T::Sig

  sig {returns(Symbol)}
  def qualified_alias_method
    :ok
  end
end

# References must resolve to methods on the original classes.
Thread::Mutex.new.payload_alias_method
Mutex.new.payload_alias_method
Thread::Mutex::Nested.new.nested_alias_method
Net::HTTPServerException.new("", nil).qualified_alias_method
