Gem::Specification.new do |s|
	s.name			= 'confgen'
	s.version		= '0.4.0'
	s.date			= '2015-04-04'
	s.summary		= "Generate config files from user input on the command line"
	s.description	= "Simple command line prompt that generates configuration files by querying the user for config values and creating a file based on a template"
	s.authors		= ["Lukas Angerer"]
	s.email			= 'lord.of.war@gmx.ch'
	s.files			= ["lib/confgen.rb"]
	s.executables   = ["confgen"]
	s.homepage		=	'http://rubygems.org/gems/confgen'
	s.license		= 'MIT'
	s.required_ruby_version = '>= 2.0'
	s.add_runtime_dependency('highline', '>= 1.7')
end
