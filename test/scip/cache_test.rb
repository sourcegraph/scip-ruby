# typed: true

extend T::Sig

sig { params(value: T.nilable(String)).void }
def cache_receiver(value)
  value&.upcase
end

class CacheExamples
  def self.specify(title, &block); end

  specify 'retains handwritten locals' do
    text = 'cached'
    text.upcase
  end
end

cache_receiver('value')
