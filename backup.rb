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
    attr_reader :source_directory, :backup_directory

    def initialize(args)
        @source_directory = args["source_directory"]
        @backup_directory = args["backup_directory"]
    end

    def backup
        puts
        fork {
            exec "/home/backerupper/bin/syncer #{source_directory} #{backup_directory}"
        }
    end
end

yaml_loader = YAMLLoader.new("btsync.yml")
backer_upper = BackerUpper.new(
    source_directory: yaml_loader.parsed["source_directory"],
    backup_directory: yaml_loader.parsed["backup_directory"])
backer_upper.backup()
