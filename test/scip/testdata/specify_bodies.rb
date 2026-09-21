# typed: true

class SpecifyBodies
  def self.specify(title, &block); end
  def self.it(title, &block); end
  def self.example(title, &block); end
  def self.xspecify(title, &block); end
  def self.test_each(values, &block); end

  specify 'restores local definitions and reads' do
    text = 'hello'
    text.upcase
  end

  it 'preserves the existing control' do
    text = 'control'
    text.upcase
  end

  example 'indexes example aliases' do
    text = 'example'
    text.upcase
  end

  xspecify 'indexes skipped example bodies' do
    text = 'skipped'
    text.upcase
  end

  test_each(['parameterized']) do |value|
    specify 'indexes parameterized examples' do
      text = value
      text.upcase
    end
  end
end
