Gem::Specification.new do |s|
  s.name        = 'knife-scp'
  s.version     = '1.0.0'
  s.date        = '2014-12-18'
  s.summary     = 'knife-scp plugin'
  s.description = 'knife-scp is a plugin to upload files, folders from local machine to remote nodes'
  s.authors     = ['maxc0d3r']
  s.email       = ['mail2mayank@gmail.com']
  s.files       = ["Gemfile","lib/chef/knife/knife-scp.rb"]
  s.homepage    = "https://github.com/maxc0d3r/knife-plugins"
  s.add_runtime_dependency "parallel","~> 1.2", ">= 1.2.0"
  s.add_runtime_dependency "net-scp","~> 1.2", ">= 1.2.0"
end

