#!/usr/bin/env ruby

# This references the Dropbox SDK gem install with "gem install dropbox-sdk"
require 'dropbox_sdk'

APP_KEY = '1xulcq1r36gagza'
APP_SECRET = 'aqn8yrt86qf7ufc'
ACCESS_TYPE = :app_folder  #The two valid values here are :app_folder and :dropbox

session = DropboxSession.new(APP_KEY, APP_SECRET)
config_path = File.expand_path('~/.imtx-backup')

if File.exist?(config_path)
  key, secret = open(config_path).read().split()
  session.set_access_token(key, secret)
else
  session.get_request_token

  authorize_url = session.get_authorize_url

  # Make the user log in and authorize this token
  puts "AUTHORIZING", authorize_url
  puts "Please visit that website and hit 'Allow', then hit Enter here."
  gets

  # This will fail if the user didn't visit the above URL and hit 'Allow'
  token = session.get_access_token
  f = open(config_path, 'w')
  f.write("#{token.key}\n#{token.secret}")
  f.close
end

client = DropboxClient.new(session, ACCESS_TYPE)
puts "linked account:", client.account_info().inspect

if ARGV.length == 1
  puts "Puting #{ARGV[0]} to dropbox"
  client.put_file(File.basename(ARGV[0]), open(ARGV[0]))
end
