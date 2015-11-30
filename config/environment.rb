# encoding: utf-8
# Load the rails application

# Encoding.default_external = "UTF-8"

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

require File.expand_path('../application', __FILE__)
#require 'newrelic_rpm'

# Initialize the rails application
Generala::Application.initialize!
#config.gem 'newrelic_rpm'
