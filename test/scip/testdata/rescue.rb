# typed: true

class MyError < StandardError
end

def handle(e)
  puts e.inspect.to_s 
end

def f
  begin
    raise 'This exception will be rescued!'
  rescue MyError => e1
    handle(e1)
  rescue StandardError => e2
    handle(e2)
  end
end
