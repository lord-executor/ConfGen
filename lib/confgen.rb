
require('highline/import')
require('yaml')
require('erb')
require('fileutils')
require('pathname')
require('pp')

class ConfGen
	def initialize(path)
		@path = path
	end

	def generate(sets)
		config = locate()
		sets.each() do |setName|
			configSet = config[setName]
			data = gather(configSet)

			say('Generation will continue with the following data')
			print(configSet, data)

			if (agree('Continue [y/n]?', true))
				b = binding
				configSet['templates'].each() do |template|
					src = Pathname.new(ERB.new(@confPath.join(template['src']).to_path()).result(b))
					dst = Pathname.new(ERB.new(@confPath.join(template['dst']).to_path()).result(b))
					tpl = ERB.new(File.read(src.to_path()))
					
					if (!dst.dirname.directory?)
						FileUtils.mkdir_p(dst.dirname.to_path())
					end

					File.open(dst.to_path(), 'w') do |f|
						f.write(tpl.result(b))
					end
				end
			end
		end
	end

	def locate()
		current = Pathname.new(@path)

		while (!current.root?())
			[current.join('variables.confgen'), current.join('confgen', 'variables.confgen')].each() do |f|
				if (f.file?())
					@confPath = f.dirname
					return YAML::load(f.open())
				end
			end

			current = current.dirname
		end
	end

	def gather(configSet)
		data = Hash.new()

		configSet['variables'].each do |var|
			data[var['name']] = self.send(var['type'], var)
		end

		return data
	end

	def print(configSet, data)
		configSet['variables'].each do |var|
			if (var['type'] == 'password')
				say("  #{var['name']}: ****")
			else
				say("  #{var['name']}: #{data[var['name']]}")
			end
		end
	end

	def choice(var)
		return choose(*var['items']) do |menu|
			menu.header = var['question']
			if (var['default'])
				menu.default = var['default']
				menu.prompt = "(defaults to '#{menu.default}')"
			end
		end
	end

	def string(var)
		return ask(var['question']) { |q| q.default = var['default'] }
	end

	def password(var)
		return ask(var['question']) { |q| q.echo = false }
	end
end
