# typed: true
# options: showDocs

def assign_different_branches(b)
  if b
    x = 1
  else
    x = nil
  end
  return
end

def change_different_branches(b)
  x = 'foo'
  if b
    x = 1
  else
    x = nil
  end
  return
end

def loop_type_change(bs)
  x = nil
  for b in bs
    puts x
    if b
      x = 1
    else
      x = 's'
    end
  end
  return
end

class C
  @k = nil

  def change_type(b)
    @f = nil
    @@g = nil
    @k = nil
    if b
      @f = 1
      @@g = 1
      @k = 1
    else
      @f = 'f'
      @@g = 'g'
      @k = 'k'
    end
  end
end

class D < C
  def change_type(b)
    if !b
      @f = 1
      @@g = 1
      @k = 1
    else
      @f = 'f'
      @@g = 'g'
      @k = 'k'
    end
  end
end
