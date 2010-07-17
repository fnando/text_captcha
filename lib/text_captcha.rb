require "active_record"
require "active_support/all"

module TextCaptcha
  autoload :Validation,  "text_captcha/validation"
  autoload :Version,  "text_captcha/version"

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
  end

  # TextCaptcha is enabled by default
  self.enabled = true

  I18n.load_path += Dir[File.dirname(__FILE__) + "/../locales/**/*.yml"]
  ::ActiveRecord::Base.send :include, TextCaptcha::Validation
end
