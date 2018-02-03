
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
  s.homepage    = 'https://github.com/alibby/rcon'
  s.license     = 'MIT'

  s.add_dependency "dotenv"
  s.add_development_dependency "pry"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rake"
end
