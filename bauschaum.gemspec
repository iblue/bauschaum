Gem::Specification.new do |s|
  s.name        = "bauschaum"
  s.version     = "0.0.1"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Markus Fenske"]
  s.email       = ["iblue@gmx.net"]
  s.homepage    = "https://github.com/iblue/bauschaum"
  s.summary     = "Use git as a database"
  s.description = "Use git as a database"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "bauschaum"

  s.files        = `git ls-files`.split("\n")
  s.require_path = 'lib'
end
