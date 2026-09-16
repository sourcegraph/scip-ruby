# typed: false

describe 'outer' do
  context 'nested' do
    value = 'hello'
    it 'reads a captured local' do
      value.upcase
    end
    specify 'writes the same captured local' do
      value = value.downcase
    end
  end

  context 'block argument shadowing' do
    value = 'outer'
    ['inner'].each do |value|
      it 'captures the block argument' do
        value.upcase
      end
    end
    it 'still captures the outer variable' do
      value.downcase
    end
  end

  context 'independent variables' do
    it 'has its own local' do
      value = 'first'
      value.upcase
    end
    it 'has a different local' do
      value = 'second'
      value.downcase
    end
  end

  context 'rescue bindings remain local to the example' do
    it 'introduces a rescue variable' do
      begin
        raise 'example'
      rescue RuntimeError => error
        error.message
      end
    end
  end
end

outside = 'file scope'
describe 'captures file scope' do
  it 'retains the outer definition' do
    outside.upcase
  end
end
