# typed: false

# `require` and `require_relative` calls. They lower to ordinary Send
# instructions; this fixture documents what the indexer emits for them.

require 'json'
require 'set'
require_relative 'non_existent_helper'

def lazy_load
  require 'csv'
  return
end
