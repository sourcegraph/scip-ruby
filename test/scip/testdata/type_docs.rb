# typed: true
# options: showDocs

module M
  extent T::Sig

  sig { params(x: Integer, y: String).returns(String) }
  def js_add(x, y)
    xs = x.to_s
    ret = xs + y
    return ret
  end
end
