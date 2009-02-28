ENV["RAILS_ENV"] = "test"
require 'test/unit'
require 'rubygems'
gem 'rails', '>= 1.2.6'
require 'active_support'
require 'action_controller'
require 'action_controller/test_process'
require File.dirname(__FILE__) + '/../lib/filter_table'
require File.dirname(__FILE__) + '/test_stubs.rb'