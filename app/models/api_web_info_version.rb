class ApiWebInfoVersion < ActiveRecord::Base
  attr_accessible :main_version , :sub_version , :api_web_info_id , :input_maps , :output_maps , :handler_eval ,:is_handler_eval
  rails_admin do
    visible false
  end
end
