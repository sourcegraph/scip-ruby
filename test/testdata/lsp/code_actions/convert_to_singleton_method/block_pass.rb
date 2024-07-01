# typed: true
# selective-apply-code-action: refactor.rewrite
extend T::Sig

class A
  extend T::Sig

  def takes_block(x, &blk)
    # | apply-code-action: [A] Convert to singleton class method (best effort)
    puts "Hello, peter."
  end
end

# Our <Magic> methods are hard.
f = ->(){}
A.new.takes_block(0, &f)
