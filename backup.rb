require 'yaml'

class YAMLDirectoryLoader
    attr_reader :source_directory, :backup_directory 
    
    def initialize(yaml_filename)
        parsed = begin
            YAML.load(File.open("btsync.yml"))
        rescue ArgumentError => e
            puts "Could not parse YAML: #{e.message}"
        end

        @source_directory = parsed["source_directory"]
        @backup_directory = parsed["backup_directory"]        
    end
end

class BackerUpper
    
    def initialize(source_directory, backup_directory)
        @source_directory = source_directory
        @backup_directory = backup_directory
    end
    
    def backup
        
    end
end

directory_settings = YAMLDirectoryLoader.new("btsync.yml")
backer_upper = BackerUpper.new(directory_settings.source_directory, directory_settings.backup_directory)
backer_upper.backup()


