$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "academic_benchmarks_api/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "academic_benchmarks_api"
  s.version     = AcademicBenchmarksApi::VERSION
  s.authors     = ["Jacob Bullock"]
  s.email       = ["jacob.bullock@gmail.com"]
  s.homepage    = "https://github.com/oncore-education/academic_benchmarks_api"
  s.summary     = "Summary of AcademicBenchmarksApi."
  s.description = "Description of AcademicBenchmarksApi."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1.4"

  s.add_development_dependency "sqlite3"
end
