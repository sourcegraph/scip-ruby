# typed: true

_ = 0

class C1
  def f()
    _ = C1.new
    return
  end
end
