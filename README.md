# TextCaptcha

[![Travis-CI](https://travis-ci.org/fnando/text_captcha.png)](https://travis-ci.org/fnando/text_captcha)
[![Code Climate](https://codeclimate.com/github/fnando/text_captcha/badges/gpa.svg)](https://codeclimate.com/github/fnando/text_captcha)
[![Test Coverage](https://codeclimate.com/github/fnando/text_captcha/badges/coverage.svg)](https://codeclimate.com/github/fnando/text_captcha/coverage)
[![Gem](https://img.shields.io/gem/v/text_captcha.svg)](https://rubygems.org/gems/text_captcha)
[![Gem](https://img.shields.io/gem/dt/text_captcha.svg)](https://rubygems.org/gems/text_captcha)

A captcha verification for Rails apps, directly integrated into ActiveModel/ActiveRecord.

## Installation

Just run

    gem install text_captcha

## Usage

Just add the validation to your model.

```ruby
class Comment < ActiveRecord::Base
  validates_captcha
end
```

By default the `{:on => :create}` option will be used. You can provide any other option you want.

```ruby
class Comment < ActiveRecord::Base
  validates_captcha :if => :new_record?
end

@comment = Comment.new

@comment.challenge
#=> The color of a red T-shirt is?

@comment.challenge_answer = "red"
@comment.valid?
#=> true
```

Note that you can answer the question without worrying about uppercase/lowercase. All strings are normalized before the comparison. So "ReD", "RED" or "red" will
pass the validation.

You can use TextCaptcha with a non-ActiveRecord class. You just need to include the `TextCaptcha::Validation` module.

```ruby
class Comment
  include ActiveModel::Validations
  include TextCaptcha::Validation

  validates_captcha
end

@comment = Comment.new
@comment.valid?
#=> false

@comment.errors[:challenge_answer]
#=> ["is not a valid answer"]
```

You can disable TextCaptcha without having to remove all validations.
This is specially good when running tests.

```ruby
TextCaptcha.enabled = false

class Comment
  include ActiveModel::Validations
  include TextCaptcha::Validation

  validates_captcha
end

@comment = Comment.new
@comment.valid?
#=> true
```

### Creating a form

First, define the encryption key; this will be used to generate an encrypted version of the challenge id.

```ruby
# config/initializers/text_captcha.rb
TextCaptcha.encryption_key = "SOME VALUE"
```

Then you can create your form. I'm using an `User` model, which may have just a call to `validates_captcha` and an instance of it under the `@user` variable on the controller.

```erb
<%= form_for @user do |f| %>
  <!-- other fields, etc, etc, etc -->

  <!-- this is important -->
  <%= f.hidden_field :encrypted_challenge_id %>

  <%= f.submit %>
<% end %>
```

And your controller may be something like this:

```ruby
class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      # do something
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user)
          .permit(:name, :email, :password, :encrypted_challenge_id)
  end
end
```

### I18n

To set the error message, just define the following scope:

```yaml
en:
  errors:
    messages:
      invalid_challenge_answer: "is invalid"
```

## To-Do

* Add more questions.

## License

(The MIT License)

Copyright © 2010 - Nando Vieira - http://nandovieira.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ‘Software’), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED ‘AS IS’, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
