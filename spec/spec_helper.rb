# spec/spec_helper.rb
require 'rack/test'
require 'rspec'
require 'simplecov'
require 'pry'

ENV['RACK_ENV'] = 'test'
require File.expand_path '../../app.rb', __FILE__


module RSpecMixin
  include Rack::Test::Methods
  def app() Sinatra::Application end
end

# For RSpec 2.x
RSpec.configure { |c| c.include RSpecMixin }


SimpleCov.start do
  add_filter '/spec'
end
