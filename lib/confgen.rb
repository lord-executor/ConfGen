
require("highline/import")
require("yaml")
require("erb")
require("fileutils")

class ConfGen
	def generate()
		config = YAML::load(File.open('.confgen'))
		template = config['template']
		destination = config['destination']
		data = gather(config)

		say("Generation will continue with the following data")
		say(data)

		if (agree("Continue [y/n]?", true))
			b = binding
			config["templates"].each() do |template|
				src = ERB.new(template["src"]).result(b)
				dst = ERB.new(template["dst"]).result(b)
				tpl = ERB.new(File.read(src))
				
				File.open(dst, 'w') do |f|
					f.write(tpl.result(b))
				end
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
