# frozen_string_literal: true
require_relative '../test_helper'

class Opus::Types::Test::DuplicateSigEvalTest < Critic::Unit::UnitTest
  before do
    module Opus::Types::Test::DuplicateSigEvalSandbox; end
  end

  after do
    Opus::Types::Test.send(:remove_const, :DuplicateSigEvalSandbox)
  end

  it "allows duplicate signature evaluation" do
    module Opus::Types::Test::DuplicateSigEvalSandbox
      autoload :CallsMethodUponLoading, "#{__dir__}/fixtures/duplicate_sig_eval/calls_method_upon_loading"
      autoload :DefineMethodWithSig, "#{__dir__}/fixtures/duplicate_sig_eval/define_method_with_sig"
    end

    Opus::Types::Test::DuplicateSigEvalSandbox::DefineMethodWithSig.duplex(nil)
  end
end
