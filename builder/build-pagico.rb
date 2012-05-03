#!/usr/bin/env ruby

require 'optparse'
require 'fileutils'

OptionParser.new do |o|
  o.on('-m MODE') { |mode| $mode = mode }
  o.on('-r REVERSION') { |reversion| $reversion = reversion }
  o.on('-h') { puts o; exit }
  o.parse!
end

source_path = File.expand_path("~/Downloads/Pagico_#{$mode}_r#{$reversion}.zip")
if (File.exist?(source_path))
    puts "The file is ready"
else
    puts "#{source_path} can not found"
    exit
end

source_root = File.expand_path("~/Sources")
project_root = File.expand_path("~/Sources/pagico")
de_path = File.expand_path("~/Sources/pagico/CodeX")

if File.exist? (de_path)
    FileUtils::rm_rf(de_path)
    puts "The file is already there, delete it at first"
end

system("unzip #{source_path} -d #{project_root}")
system("cd #{project_root} && debuild")
name = `cd #{source_root} && ls pagico_*~r*.deb`.strip
new_name = "#{name.split('.deb')[0]}_#{$mode}.deb"
puts("cd #{source_root} && mv #{name} ~/Desktop/#{new_name}")
system("cd #{source_root} && mv #{name} ~/Desktop/#{new_name}")
