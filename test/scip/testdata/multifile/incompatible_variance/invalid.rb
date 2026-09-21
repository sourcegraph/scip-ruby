# typed: true
# check-errors: true

class Producer
  extend T::Generic
  Elem = type_member(:out)
  def parent_method; end
end

class InvalidConsumer < Producer
  Elem = type_member(:in) # error: Type variance mismatch for `Elem` with parent `Producer`
  def child_method; end
end

extend T::Sig
sig { params(forward: T.all(InvalidConsumer[Object], Producer[String]), reverse: T.all(Producer[String], InvalidConsumer[Object])).void }
def narrow(forward, reverse)
  forward.parent_method
  forward.child_method
  reverse.parent_method
  reverse.child_method
end

class Consumer
  extend T::Generic
  Elem = type_member(:in)
  def parent_method; end
end

class InvalidProducer < Consumer
  Elem = type_member(:out) # error: Type variance mismatch for `Elem` with parent `Consumer`
  def child_method; end
end

sig { params(forward: T.all(InvalidProducer[String], Consumer[Object]), reverse: T.all(Consumer[Object], InvalidProducer[String])).void }
def widen(forward, reverse)
  forward.parent_method
  forward.child_method
  reverse.parent_method
  reverse.child_method
end
