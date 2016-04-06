require "active_model"

module TextCaptcha
  require "text_captcha/validation"
  require "text_captcha/version"

  class << self
    # You can disable TextCaptcha without having to remove all validations.
    # This is specially good when running tests.
    #
    #   TextCaptcha.enabled = false
    #
    #   class Comment
    #     include ActiveModel::Validations
    #     include TextCaptcha::Validation
    #
    #     validates_captcha
    #   end
    #
    #   @comment = Comment.new
    #   @comment.valid?
    #   #=> true
    #
    attr_accessor :enabled

    # Set the encryption key.
    # This value will be used to generate an encrypted challenge id.
    attr_accessor :encryption_key
  end

  # TextCaptcha is enabled by default
  self.enabled = true

  # Set a random key by default. This may invalidate loaded
  # forms when restarting the server, but it's not a big problem.
  self.encryption_key = nil

  I18n.load_path += Dir[File.dirname(__FILE__) + "/../locales/**/*.yml"]

  begin
    require "active_record"
    ::ActiveRecord::Base.send :include, TextCaptcha::Validation
  rescue LoadError
  end
end
