# encoding: utf-8
class PlugincfgOpenApi < ActiveRecord::Base
  attr_accessible :name,:configs,:in_json,:out_json,:official_url,:desc
  rails_admin do
    visible false
  end
end
