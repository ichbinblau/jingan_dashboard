# encoding: utf-8
class User < ActiveRecord::Base
	# Include default devise modules. Others available are:
	# :token_authenticatable, :confirmable,
	# :lockable, :timeoutable and :omniauthable
	# has_many admin_permission
	devise :database_authenticatable, :registerable,
	     :recoverable, :rememberable, :trackable, :validatable

	# validates :email,  :label => "邮件"
	# Setup accessible (or protected) attributes for your model
	attr_accessible :email, :password,:project_info_id, :password_confirmation, :remember_me
	# attr_accessible :title, :body
	# @currentuser  = instance_eval &RailsAdmin::Config.current_user_method

	# logger.debug("zzdebug: in modules user --#{@currentuser}")
	has_and_belongs_to_many :admin_permissions
	rails_admin do 
		visible false
	end
end

# Rails.logger = Log4r::Logger.new("Application Log")
# # Rails.logger.info("I don't think that's a good idea")
