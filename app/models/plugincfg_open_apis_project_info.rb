# encoding: utf-8
class PlugincfgOpenApisProjectInfo < ActiveRecord::Base
  attr_accessible :project_info_id , :plugincfg_open_api_id , :in_json, :configs
  rails_admin do
    visible false
  end
end
