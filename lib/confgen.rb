
require("highline/import")
require("yaml")
require("erb")

class ConfGen
	def generate()
		config = YAML::load(File.open('.confgen'))
		template = config['template']
		destination = config['destination']
		data = gather(config)

		say("Generation will continue with the following data")
		say(data)

		if (agree("Continue [y/n]?", true))
			tpl = ERB.new(File.read(template))

			File.open(destination, 'w') do |f|
				f.write(tpl.result(binding))
			end
		end
	end

	def gather(config)
		data = Hash.new()

		config['variables'].each do |var|
			data[var['name']] = self.send(var['type'], var)
		end

		return data
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
