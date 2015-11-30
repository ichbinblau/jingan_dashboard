# encoding: utf-8
class ProjectAppUpload < ActiveRecord::Base
	belongs_to :project_app
	mount_uploader :file, FileUploader
	attr_accessible :project_app_id ,:phonetype , :file, :des ,:version, :file_cache, :remove_file

	def phonetype_enum
        [ [ '安卓', 'android' ], [ 'ios', 'ios' ]]
    end

    # before_save :setup_before_save
    after_save :setup_after_save
    after_create :setup_after_save
    protected
    def setup_after_save
        project_app = ProjectApp.find(self.project_app_id)
        project_app.download_url = "http://admin.nowapp.cn"+self.file.url
        if (!self.version.blank?)
        	project_app.version_num = self.version
        end
        project_app.newupdate_description = self.des
        project_app.save
        # Rails.logger.info( "eclogger:" + request.domain+ self.file.url )
    end


	rails_admin do
  		visible false
  		field :file
        field :version
        field :des
    end
end
