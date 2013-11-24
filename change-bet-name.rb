#!/usr/bin/ruby1.9.1

require_relative 'accumulator.rb'

require 'yaml'

INTERNAL_DIR = "internals"
ACC_DIR = "#{INTERNAL_DIR}/accs"

def to_acc_path(name)
  ACC_DIR + "/" + name + ".yml"
end

from_name = ARGV[0]
to_name = ARGV[1]

if !to_name
  puts "Usage: #{__FILE__} <src> <dst>"
  exit(1)
end

raise "DEBUG err"

from_path = to_acc_path(from_name)
to_path = to_acc_path(to_name)

raise("Couldn't find #{from_path}") unless File.exist?(from_path)
raise("#{to_path} already exists") if File.exist?(to_path)

accumulator = YAML.load_file(from_path)
accumulator.name = to_name
File.open(to_path, "w") {
| file |
  YAML.dump(accumulator, file)
}
File.delete(from_path)
