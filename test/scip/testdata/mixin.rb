# typed: true

module M
  def f
    puts 'M.f'
  end
end

class C1
  include M
  def f
    puts 'C1.f'
  end
end

# f refers to C1.f
class C2 < C1
end

# f refers to C1.f
class C3 < C1
  include M
end

class D1
  def f
    puts 'D1.f'
  end
end

class D2
  include M
end

C1.new.f # C1.f
C2.new.f # C1.f
C3.new.f # C1.f

D1.new.f # D1.f
D2.new.f # M.f
