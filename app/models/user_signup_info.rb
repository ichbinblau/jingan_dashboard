# encoding: utf-8
class UserSignupInfo < ActiveRecord::Base
  validates :user_info_id,  :presence => { :message => "不能为空" }
  attr_accessible  :user_info_id,:username,:sex,:age,:phone,:address,:id
  rails_admin do
    visible false
    list do
      field :user_info_id
    end
  end
end
