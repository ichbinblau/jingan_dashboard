# encoding: utf-8
class ActShipOrder < ActiveRecord::Base
    # validates :project_companie_id,  :presence => { :message => "不能为空" }
    validates :project_info_id,  :presence => { :message => "不能为空" }

    # foreign key constraints
    belongs_to :cms_content

    attr_accessible :id,:project_info_id,:user_info_id,:cms_content_id,:title \
                  ,:user_consignee_id,:remarks,:created_at,:updated_at

end
