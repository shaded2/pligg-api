require 'sinatra'
require 'sinatra/activerecord'
require 'logger'

module App
  extend self
  attr_accessor :log

  # init
  # self.log = Logger.new('log/application.log', 10, 5242880)
  self.log = Logger.new(STDOUT)
  self.log.level = Logger::DEBUG  # could DEBUG, ERROR, FATAL, INFO, UNKNOWN, WARN

  self.log.formatter = proc { |severity, datetime, progname, msg| "#{severity} :: #{datetime.strftime('%Y-%m-%d :: %H:%M:%S')} :: #{progname} :: #{msg}\n" }
end

# setting up our environment
env_index = ARGV.index("-e")
ENV['RACK_ENV'] = ARGV[env_index + 1] if env_index
App.log.debug "env: #{Sinatra::Application.environment}"

set :database_file, "./config/database.yml"

#token auth
before do
  validate_token
end

def validate_token
  begin
    App.log.debug "token: #{request.env['HTTP_AUTHORIZATION']}"
    @api_key = ApiKey.find_by_access_token bearer_token
    raise "invalid access token" if !@api_key
    @current_user = @api_key.user
  rescue StandardError => e
    error 401, {:error => e.message}.to_json
  end
end

def bearer_token
  pattern = /^Bearer /
  header  = request.env['HTTP_AUTHORIZATION']
  header.gsub(pattern, '') if header && header.match(pattern)
end

#require app files
require './models/api_key'
require './models/user'
require './service'

