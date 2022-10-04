# typed: true

$aa = 0

def f
  $aa = 10
  $bb = $aa
  $aa = $bb
  return
end

class C
  def g
    $c = $bb
  end
end

puts $c

$d = T.let(0, Integer)

def g
  $d
end
