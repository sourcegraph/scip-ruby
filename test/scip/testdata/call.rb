# typed: true

# NOTE: The methods have bodies to make sure that we're not
# accidentally skipping emitting references for the method body
# due to changes in rewriter/Command.cc

class Opus::Command
end

# NOTE: This is nested inside Opus as a convention,
# but the key thing is the subclassing relationship.
class Opus::MyThing::Command::GetThing < Opus::Command
  def call()
    x = 1
    y = x
  end
end

# Forgot < Opus::Command relationship here
class Opus::MyThing::BadCommand::GetThing
  def call()
    x = 1
    y = x
  end
end

class NotOpus::Command1::GetThing
  # Class method
  def self.call()
    x = 1
    y = x
  end
end

class NotOpus::Command2::GetThing
  # Instance method
  def call()
    x = 1
    y = x
  end
end

def make_call()
  # Should navigate to instance method
  Opus::MyThing::Command::GetThing.call()
  # Actually wrong, because < Opus::Command was missed
  Opus::MyThing::BadCommand::GetThing.call()
  # Not expected to work since type is not in Opus namespace
  NotOpus::Command1::GetThing.call()
  # Should navigate to instance method
  NotOpus::Command2::GetThing.new().call()
end
