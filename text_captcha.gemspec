# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{text_captcha}
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Nando Vieira"]
  s.date = %q{2010-07-17}
  s.email = %q{fnando.vieira@gmail.com}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    "README.rdoc",
     "Rakefile",
     "lib/text_captcha.rb",
     "lib/text_captcha/config.rb",
     "lib/text_captcha/validation.rb",
     "lib/text_captcha/version.rb",
     "locales/en.yml",
     "locales/pt.yml",
     "test/config_test.rb",
     "test/test_helper.rb",
     "test/text_captcha_test.rb"
  ]
  s.homepage = %q{http://github.com/fnando/text_captcha}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Simple captcha based on plain text questions.}
  s.test_files = [
    "test/config_test.rb",
     "test/test_helper.rb",
     "test/text_captcha_test.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

