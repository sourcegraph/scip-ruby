# typed: true

class ConstructorParent
  def initialize(value)
    @value = value
  end
end

class ConstructorChild < ConstructorParent
end

class ConstructorOverride < ConstructorParent
  def self.new(value)
    super
  end
end

class ConstructorEmpty
end

ConstructorParent.new('parent')
ConstructorChild.new('child')
ConstructorOverride.new('override')
ConstructorEmpty.new
Net::HTTP.new('localhost')
Gem::Version.new('1.2.3')
