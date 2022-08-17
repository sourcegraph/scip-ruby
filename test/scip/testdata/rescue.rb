# typed: true

def f
  begin
    raise 'This exception will be rescued!'
  rescue StandardError => e
    puts "Rescued: #{e.inspect}"
  rescue AnotherError => e
    puts "Rescued, but with a different block: #{e.inspect}"
  end
  f
end
