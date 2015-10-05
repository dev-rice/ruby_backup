#!/usr/bin/ruby

require 'yaml'
require 'fileutils'

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
        @syncer_command = default_syncer_command
        @source_directory = args["source_directory"]
        @backup_directory = args["backup_directory"]
    end
    
    def default_syncer_command
        "rsync -av"
    end

    def backup
        create_backup_directory
        run_backup_command
        write_timestamp_to_backup_directory
    end

    def create_backup_directory
        FileUtils.mkdir_p(backup_directory)
    end
    
    def run_backup_command
        system "#{syncer_command} #{source_directory} #{backup_directory}"
    end

    def write_timestamp_to_backup_directory
        target = open(timestamp_filename, 'w')
        target.write(timestamp)
        target.close 
    end
    
    def timestamp_filename
        File.join(backup_directory, 'last_backup.txt')
    end

    def timestamp
        "#{Time.now}\n"
    end
end

yaml_filename = ARGV[0]
yaml_loader = YAMLLoader.new(yaml_filename)
backer_upper = BackerUpper.new(yaml_loader.parsed)
backer_upper.backup()
