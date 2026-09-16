# typed: strict
# enable-experimental-rbs-comments: true
# options: showDocs

# Adapted from test/testdata/rbs/signatures_defs.rb.
class RBSParser
  #: -> String
  def title
    "Prism"
  end
end

RBSParser.new.title.upcase
