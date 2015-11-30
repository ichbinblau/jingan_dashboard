# encoding: utf-8
class SlaveUserOauthTokenOrder < SlaveModel
    self.table_name = "user_oauth_token_orders"

	attr_accessible :user_info_id, :project_app_id, :user_device_id, :access_token, :expiresin, :created_at

end
