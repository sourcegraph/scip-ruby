# typed: true

class X
  alias_method :am_aaa, :aaa
  alias :a_aaa :aaa

  def aaa
    puts "AAA"
  end

  def check_alias
    return [am_aaa, a_aaa]
  end
end
