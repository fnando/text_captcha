module TextCaptcha
  def self.configure(&block)
    yield TextCaptcha::Config
  end

  class Config
    class << self
      attr_accessor :enabled
      attr_accessor :challenge_attr
      attr_accessor :answer_attr
    end
  end
end
