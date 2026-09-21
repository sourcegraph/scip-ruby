# typed: true
# check-errors: true

# Keep this first definition beyond the end of b.rb to catch offsets being
# reused in the wrong file. Both definitions share one method symbol, but each
# definition occurrence and enclosing range must belong to its own source file.
class ReopenedMethod # error: `ReopenedMethod` has behavior defined in multiple files
  def value
    1
  end
end
