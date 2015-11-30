# encoding: utf-8
class AdminUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

	attr_accessible :email, :password,:project_info_id, :password_confirmation, :remember_me

  # project
  belongs_to :project_info


	# permissions
	has_and_belongs_to_many :admin_permissions
	attr_accessible :admin_permissions_attributes,:admin_permission_ids
	accepts_nested_attributes_for :admin_permissions, :allow_destroy => true


	rails_admin do
		include_all_fields
		field :admin_permissions do
	      nested_form false
	      # orderable true
	    end
  		navigation_label '项目'
  		weight 6

    end

	# rails_admin do 
	# 	# Rails.logger.debug("zzdebug: in modules user :#{_current_user}" )
	# 	list do
	# 		field :email
	# 		field :password
	# 	end
	# 	update do
	#       	field :email
	# 		field :password
	# 	end
	# end
end

# Rails.logger = Log4r::Logger.new("Application Log")
# # Rails.logger.info("I don't think that's a good idea")
