# encoding: utf-8
class SlaveSysApiCallLog < SlaveModel

	self.table_name = "sys_api_call_logs"
	attr_accessible :method, :api_version, :params, :project_app_id, :project_info_id, :user_info_id, :error_num, :error_msg, :ip_address, :exec_millisecond, :access_token

end