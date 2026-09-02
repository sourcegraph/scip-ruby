# typed: true
extend T::Sig

class Test
  extend T::Sig

  def self.test_each(iter, &blk); end
  def self.it(name, &blk); end
  def self.describe(name, &blk); end

  test_each([[1,2], [3,4]]) do |(a,b)|

    describe "d" do
      # `before` inside `test_each` has a synthesized method name with an empty
      # source location. The indexer should skip that definition occurrence.
      before do
      end
      it "b" do
        T.reveal_type(a) # error: Revealed type: `Integer`
      end
    end

    it "a" do
      T.reveal_type(a) # error: Revealed type: `Integer`
    end

  end
end
