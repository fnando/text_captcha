require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require "bundler/setup"
require "minitest/utils"
require "minitest/autorun"
require "text_captcha"

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
ActiveRecord::Schema.define(:version => 0) do
  create_table :users do
  end

  create_table :accounts do
  end
end
