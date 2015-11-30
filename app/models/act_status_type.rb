# encoding: utf-8
require "resque"
$:.unshift File.dirname(__FILE__)+'/../lib'
require 'rubygems'
require 'mqtt'
require "iconv"
class ActStatusType < ActiveRecord::Base
  attr_accessible  :id,:descption,:name,:created_at,:updated_at
  rails_admin do
    visible false
    list do
      field :descption
      field :id
    end
  end
end
