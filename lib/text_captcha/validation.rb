module TextCaptcha
  module Validation
    def self.included(base)
      base.class_eval do
        include InstanceMethods
        extend ClassMethods
      end
    end

    module ClassMethods
      # Validate if answer for a captcha question is correct.
      # If there's no valid user, an error will be attached to
      # <tt>:challenge_answer</tt> attribute.
      #
      #   class Comment < ActiveRecord::Base
      #     validates_captcha
      #   end
      #
      # By default the <tt>{:on => :create}</tt> options will be used. You can provide
      # any other option you want.
      #
      #   class Comment < ActiveRecord::Base
      #     validates_captcha :if => :new_record?
      #   end
      #
      #   @comment = Comment.new
      #
      #   @comment.challenge
      #   #=> The colour of a red T-shirt is?
      #
      #   @comment.challenge_answer = "red"
      #   @comment.valid?
      #   #=> true
      #
      # Note that you can answer the question without worrying about uppercase/lowercase.
      # All strings are normalized before the comparison. So "ReD", "RED" or "red" will
      # pass the validation.
      #
      # You can use TextCaptcha with a non-ActiveRecord class. You just need to
      # include the <tt>TextCaptcha::Validation</tt> module.
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
      #   #=> false
      #
      #   @comment.errors[:challenge_answer]
      #   #=> ["You need to answer the anti-spam question."]
      #
      #
      def validates_captcha(options = {})
        attr_accessor :challenge_answer
        attr_writer :challenge_id

        # Only add default options if class descends from ActiveRecord.
        # Otherwise, validations won't run because regular classes don't
        # have save new record status.
        if self.ancestors.include?(::ActiveRecord::Base)
          options.reverse_merge!(:on => :create)
        end

        validate :check_challenge_answer, options
      end
    end

    module InstanceMethods
      # Return an array with the current question and its answers.
      def current_challenge
        all_challenges[challenge_id.to_i]
      end

      # Return the question string.
      def challenge
        current_challenge.first
      end

      # Return all accepted answers.
      def challenge_answers
        current_challenge.last
      end

      # Return the question id. If none is assigned it chooses on
      # randomly.
      def challenge_id
        @challenge_id ||= Kernel.rand(all_challenges.count)
      end

      # Return all questions.
      def all_challenges
        @all_challenges ||= I18n.t("text_captcha.challenges")
      end

      # Detect if the answer is correct. Will also return true if <tt>TextCaptcha.enabled</tt>
      # is set to <tt>false</tt>.
      def valid_challenge_answer?
        return false unless current_challenge
        return true unless TextCaptcha.enabled

        answers = challenge_answers.collect {|a| to_captcha(a)}
        !challenge_answer.blank? && answers.include?(to_captcha(challenge_answer))
      end

      private
      # Check if the answer is correct. Add an error to
      # <tt><:challenge_answer/tt> attribute otherwise.
      def check_challenge_answer
        unless valid_challenge_answer?
          errors.add(:challenge_answer, I18n.t("text_captcha.error_message"))
        end
      end

      # Normalize the strings for comparison.
      def to_captcha(str)
        str.to_s.squish.downcase
      end
    end
  end
end
