# encoding: utf-8
class UserFav < ActiveRecord::Base
  attr_accessible  :restrict_id,:from_id,:to_id
  rails_admin do
    visible false
  end
end
