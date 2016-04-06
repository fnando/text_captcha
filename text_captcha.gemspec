require "./lib/text_captcha/version"

Gem::Specification.new do |spec|
  spec.required_ruby_version = ">= 2.1.0"
  spec.name          = "text_captcha"
  spec.version       = TextCaptcha::Version::STRING
  spec.authors       = ["Nando Vieira"]
  spec.email         = ["fnando.vieira@gmail.com"]
  spec.description   = "Simple captcha based on plain text questions."
  spec.summary       = spec.description
  spec.homepage      = "http://github.com/fnando/text_captcha"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) {|f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activemodel"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest-utils"
  spec.add_development_dependency "pry-meta"
  spec.add_development_dependency "activerecord"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "mocha"
  spec.add_development_dependency "codeclimate-test-reporter"
end
