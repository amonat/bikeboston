require 'rubygems'
require 'bundler'

Bundler.require

require './map'
run Sinatra::Application
