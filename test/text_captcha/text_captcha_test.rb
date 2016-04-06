require "test_helper"

class User < ActiveRecord::Base
  validates_captcha
end

class Account < ActiveRecord::Base
  validates_captcha :if => :new_record?
end

class Comment
  include ActiveModel::Validations
  include TextCaptcha::Validation

  validates_captcha
end

class TextCaptchaTest < Minitest::Test
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
    @user.challenge_answer = nil
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
    assert @user.challenge
  end

  def test_require_captcha_answer
    refute @user.valid?
    assert @user.errors[:challenge_answer].include?(I18n.t("errors.messages.invalid_challenge_answer"))
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

  def test_respect_if_option
    @account.challenge_answer = @account.challenge_answers.first
    assert @account.save

    @account.challenge_answer = nil
    @account.challenge_id = nil

    assert @account.valid?
  end

  def test_extend_any_object
    @comment = Comment.new
    assert @comment.challenge
    refute @comment.valid?
    assert @comment.errors[:challenge_answer].include?(I18n.t("errors.messages.invalid_challenge_answer"))
  end

  def test_return_encrypted_key
    TextCaptcha.encryption_key = SecureRandom.hex(50)

    @comment = Comment.new
    challenge_id = @comment.challenge_id
    encrypted_id = @comment.encrypted_challenge_id

    refute_equal challenge_id, encrypted_id

    @another_comment = Comment.new
    @another_comment.encrypted_challenge_id = encrypted_id

    assert_equal challenge_id, @another_comment.challenge_id
  end

  def test_raise_exception_when_have_no_encryption_key
    TextCaptcha.encryption_key = nil
    assert_raises(ArgumentError) { Comment.new.encrypted_challenge_id }
  end
end
