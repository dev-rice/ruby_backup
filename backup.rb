require 'yaml'

class BackerUpper

    def initialize(args)
        @source_directory = args["source_directory"]
        @backup_directory = args["backup_directory"]
    end

    def backup
        fork {
            exec "/home/backerupper/syncer #{source_directory} #{backup_directory}"
        }
    end
end

parsed = begin
    YAML.load(File.open("btsync.yml"))
rescue ArgumentError => e
    puts "Could not parse YAML: #{e.message}"
end

backer_upper = BackerUpper.new(parsed)
backer_upper.backup()
