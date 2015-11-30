# encoding: utf-8
class ActSignupOrder < ActiveRecord::Base
    validates :project_info_id,  :presence => { :message => "不能为空" }
    
    # foreign key constraints
    belongs_to :cms_content
    
    attr_accessible :id,:project_info_id,:user_info_id,:cms_content_id,:title \
                    ,:user_signup_id,:remarks,:created_at,:updated_at
end
