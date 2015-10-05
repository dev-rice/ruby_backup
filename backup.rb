require 'yaml'

class YAMLLoader
    attr_reader :parsed

    def initialize(filename)
        @parsed = begin
            YAML.load(File.open(filename))
        rescue ArgumentError => e
            puts "Could not parse YAML: #{e.message}"
        end
    end
end

class BackerUpper
    attr_reader :syncer_command, :source_directory, :backup_directory

    def initialize(args)
        @syncer_command = args["syncer_command"]
        @source_directory = args["source_directory"]
        @backup_directory = args["backup_directory"]
    end

    def backup
        fork {
            exec "#{syncer_command} #{source_directory} #{backup_directory}"
        }
    end
end

yaml_loader = YAMLLoader.new("btsync.yml")
backer_upper = BackerUpper.new(yaml_loader.parsed)
backer_upper.backup()
