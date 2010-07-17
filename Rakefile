require "rcov/rcovtask"
require "rake/testtask"
require "rake/rdoctask"
require "lib/text_captcha/version"

Rcov::RcovTask.new do |t|
  t.test_files = FileList["test/**/*_test.rb"]
  t.rcov_opts = ["--sort coverage", "--exclude .gem"]

  t.output_dir = "coverage"
  t.libs << "test"
  t.verbose = true
end

Rake::TestTask.new do |t|
  t.libs << "lib"
  t.libs << "test"
  t.test_files = FileList["test/**/*_test.rb"]
  t.verbose = true
  t.ruby_opts = %w[-rubygems]
end

Rake::RDocTask.new do |rdoc|
  rdoc.main = "README.rdoc"
  rdoc.rdoc_dir = "doc"
  rdoc.title = "TextCaptcha API"
  rdoc.options += %w[ --line-numbers --inline-source --charset utf-8 ]
  rdoc.rdoc_files.include("README.rdoc")
  rdoc.rdoc_files.include("lib/**/*.rb")
end

begin
  require "jeweler"

  Jeweler::Tasks.new do |gem|
    gem.name = "text_captcha"
    gem.email = "fnando.vieira@gmail.com"
    gem.homepage = "http://github.com/fnando/text_captcha"
    gem.authors = ["Nando Vieira"]
    gem.version = TextCaptcha::Version::STRING
    gem.summary = "Simple captcha based on plain text questions."
    gem.files =  FileList["README.rdoc", "{lib,test,locales}/**/*", "Rakefile"]
  end

  Jeweler::GemcutterTasks.new
rescue LoadError => e
  puts "You need to install jeweler to build this gem."
end
