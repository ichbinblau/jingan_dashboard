# encoding: utf-8
class ProjectAppStateLog < ActiveRecord::Base
	belongs_to :project_app
	mount_uploader :attachment, FileUploader
	attr_accessible :project_app_id , :app_state, :des ,:attachment,:attachment_cache, :log_time

	def app_state_enum
        [ [ '洽谈客户', '0' ], [ '签订合同', '10' ], [ '需求整理', '20' ], [ '内容录入', '30' ], [ '技术开发', '40' ],
         [ '内部测试', '50' ], [ '公开测试', '60' ], [ '交付客户', '70' ], [ '发布推广', '80' ],
          [ '暂停发布', '90' ]]
    end

    # before_save :setup_before_save
    after_save :setup_after_save
    after_create :setup_after_save
    protected
    def setup_after_save
        project_app = ProjectApp.find(self.project_app_id)
        project_app.app_state = self.app_state
        project_app.save
    end

	rails_admin do
  		visible false
  		field :app_state
        field :des
        field :attachment
        field :log_time do
            date_format :default
        end
    end
end
