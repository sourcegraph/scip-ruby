# typed: true
# enable-experimental-rbs-comments: true
# options: showDocs

class RBSHovers
  #: (String) -> String
  def unnamed(customer)
    customer
  end

  #: (String customer) -> String
  def named(customer)
    customer
  end

  #: (
  #|   String first,
  #|   ?Integer count,
  #|   *Symbol rest, enabled: bool,
  #|   ?label: String,
  #|   **Integer extras
  #| ) { (String) -> String } -> String
  def mixed(first, count = 1, *rest, enabled:, label: "ok", **extras, &transform)
    transform.call(first)
  end

  #: (?String, *Integer, Integer, flag: bool, ?limit: Integer, **String) ?{ -> void } -> void
  def unnamed_mixed(first = "", *rest, last, flag:, limit: 1, **extras, &block)
  end

  #: (String) -> String
  def self.singleton(customer)
    customer
  end

  #: [Item] (Item) -> Item
  def identity(value)
    value
  end

  alias copied unnamed

  #: String
  attr_writer :title

  #: String
  attr_accessor :label

  #: (*Integer) -> void
  def anonymous_rest(*)
  end

  #: (**String) -> void
  def anonymous_keywords(**)
  end

  #: { -> void } -> void
  def anonymous_block(&)
  end
end

#: [Elem < Numeric]
class RBSHoverBox
  #: (Elem) -> void
  def initialize(value)
    @value = value
  end

  #: Elem
  attr_reader :value

  #: (Elem) -> Elem
  def echo(value)
    value
  end

  #: [Item] (Elem, Item) -> Item
  def generic(value, other)
    other
  end
end

#: [Elem = Integer]
class RBSHoverFixed
  #: (Elem) -> Elem
  def echo(value)
    value
  end
end

hovers = RBSHovers.new
hovers.unnamed("a").upcase
hovers.named("b").upcase
hovers.copied("c").upcase
hovers.mixed("a", 1, :x, enabled: true, label: "b", x: 2) { |value| value.upcase }
hovers.unnamed_mixed("a", 1, 2, flag: true)
hovers.identity(1).abs
RBSHovers.singleton("a").upcase
hovers.title = "a"
hovers.label = "b"
hovers.label.upcase
box = RBSHoverBox.new(1) #: RBSHoverBox[Integer]
box.echo(1).abs
box.value.abs
box.generic(1, "a").upcase
RBSHoverFixed.new.echo(1).abs
