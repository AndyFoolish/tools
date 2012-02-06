#!/usr/bin/env ruby

print "Please input the prefix: "
prefix = gets.strip

Dir.glob('*.JPG').sort.each_with_index do |path, i|
    puts "Converting #{path} to #{prefix}-#{i}.jpg..."
    system("convert -resize 550x413 #{path} #{prefix}-#{i}.jpg")
end
