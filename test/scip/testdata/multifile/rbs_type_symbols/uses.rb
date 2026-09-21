# typed: true
# enable-experimental-rbs-comments: true

module RBSDefinitions
  #: (text) -> copy
  def self.echo(value)
    value
  end
end

#: (RBSDefinitions::text) -> RBSDefinitions::copy
def alias_echo(value)
  value.upcase
end

#: [Elem] (Elem) -> Elem
def generic_echo(value)
  value #: Elem
end

#: [Elem] (Elem) -> Elem
def other_echo(value)
  value
end

alias_echo("text").upcase
generic_echo("text").upcase
other_echo(1).abs
RBSDefinitions.echo("text").upcase
box = RBSDefinitions::Box.new #: RBSDefinitions::Box[String]
box.echo("text").upcase
box.generic_echo(1).abs
bounded = RBSDefinitions::Bounded.new #: RBSDefinitions::Bounded[Numeric]
bounded.echo(1).abs
