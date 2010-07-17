require "test_helper"

class User < ActiveRecord::Base
  validates_captcha
end

class Account < ActiveRecord::Base
  validates_captcha :on => :save
end

class Comment
  include ActiveModel::Validations
  include TextCaptcha::Validation

  validates_captcha
end

class TextCaptchaTest < Test::Unit::TestCase
  def setup
    I18n.locale = :en
    TextCaptcha.enabled = true
    @user = User.new
    @account = Account.new
  end

  def test_enabled_option
    assert_respond_to TextCaptcha, :enabled
  end

  def test_skip_captcha_validation_when_is_disabled
    TextCaptcha.enabled = false
    assert @user.valid?
  end

  def test_return_all_challenges
    assert_equal I18n.t("text_captcha.challenges"), @user.all_challenges
  end

  def test_randomly_choose_challenge_id
    assert_kind_of Numeric, @user.challenge_id
  end

  def test_keep_previously_selected_challenge
    id = @user.challenge_id
    assert_equal id, @user.challenge_id
  end

  def test_select_a_new_challenge
    Kernel.expects(:rand).twice.with(@user.all_challenges.count).returns(100, 101)

    assert_equal 100, @user.challenge_id
    @user.challenge_id = nil
    assert_equal 101, @user.challenge_id
  end

  def test_return_challenge
    assert_not_nil @user.challenge
  end

  def test_require_captcha_answer
    assert !@user.valid?
    assert_equal I18n.t("text_captcha.error_message"), @user.errors[:challenge_answer].to_s
  end

  def test_accept_valid_answer
    @user.challenge_answer = @user.challenge_answers.first
    assert @user.valid?
  end

  def test_respect_on_create_option
    @user.challenge_answer = @user.challenge_answers.first
    assert @user.save
    assert @user.valid?
  end

  def test_respect_on_save_option
    @account.challenge_answer = @account.challenge_answers.first
    assert @account.save

    @account.challenge_answer = nil
    @account.challenge_id = nil

    assert !@account.valid?
    assert_equal I18n.t("text_captcha.error_message"), @account.errors[:challenge_answer].to_s
  end

  def test_extend_any_object
    @comment = Comment.new
    assert_not_nil @comment.challenge
    assert !@comment.valid?
    assert_equal I18n.t("text_captcha.error_message"), @comment.errors[:challenge_answer].to_s
  end
end
