# -*- encoding : utf-8 -*-
# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require "email_spec"

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
Dir[Rails.root.join("lib/mock*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.include FactoryGirl::Syntax::Methods
  config.global_fixtures = :all
  config.include(EmailSpec::Helpers)
  config.include(EmailSpec::Matchers)
end

def admin_login
  # fake login
  CASClient::Frameworks::Rails::Filter.fake( 'shensiwei@youku.com' )
  # to get the current_user
  cms_user= create(:cms_user, :username => 'admin', :email => 'shensiwei@youku.com')
  session[:cas_user] = cms_user.email
  session[:user] = cms_user
end

