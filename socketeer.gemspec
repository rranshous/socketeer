Gem::Specification.new do |s|
  s.name        = 'socketeer'
  s.version     = '0.0.16'
  s.date        = '2013-03-10'
  s.summary     = "simple socket server"
  s.description = "simple socket server for doing message passing"
  s.authors     = ["Robby Ranshous"]
  s.email       = "rranshous@gmail.com"
  s.files       = Dir.glob("{lib}/**/*")
  s.homepage    = 'http://oneinchmile.com'
  s.require_paths = ["lib"]

  s.add_dependency 'msgpack'
  s.add_dependency 'nio4r'
end
