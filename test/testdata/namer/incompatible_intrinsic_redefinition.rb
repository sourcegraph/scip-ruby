# typed: true

# Array#dig is an intrinsic whose payload definition has two explicit arguments.
# A user definition with a different argument shape should not cause namer to
# associate this MethodDef with the payload method's incompatible argument list.
class Array
  def dig(key); end
end
