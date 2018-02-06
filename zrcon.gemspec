
$:.push File.expand_path('../lib', __FILE__)

require 'zrcon/version'

Gem::Specification.new do |s|
  s.name        = 'zrcon'
  s.version     =  Zrcon::VERSION.dup
  s.executables << 'zrcon'
  s.date        = '2018-02-02'
  s.summary     = "Basic RCON client"
  s.description = "A lightweight rcon client to talk to minecraft remote console service"
  s.authors     = ["Andrew Libby"]
  s.email       = 'alibby@andylibby.org'
  s.files       = Dir[ 'bin/*',  'lib/**/*.rb' ]
  s.homepage    = 'https://github.com/alibby/zrcon'
  s.license     = 'MIT'

  s.add_dependency "dotenv", "~> 2.2"
  s.add_development_dependency "pry", "~> 0.11"
  s.add_development_dependency "rspec", "~> 3.7"
  s.add_development_dependency "rake", "~> 12.3"
end
