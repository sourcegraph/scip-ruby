# typed: true

class SafeNavigationReceiver
  extend T::Sig

  sig { returns(String) }
  def value; "value"; end
end

extend T::Sig

sig { params(receiver: T.nilable(SafeNavigationReceiver)).void }
def optional_receiver(receiver)
  receiver&.value
  receiver&.value&.upcase
  value = T.let(nil, T.nilable(String))
  value ||= receiver&.value
  value &&= receiver&.value
end

sig { params(receiver: SafeNavigationReceiver).void }
def known_receiver(receiver)
  receiver&.value
  (receiver)&.value
  receiver.value&.upcase
  SafeNavigationReceiver.new&.value
  nil&.value
end
