class ApiWebType < ActiveRecord::Base
  attr_accessible :name, :display_name , :description 
  rails_admin do
    visible false
  end
end
