# encoding: utf-8
class SlaveUserInfo < SlaveModel
    
    self.table_name = "user_infos"

    attr_accessible :act_statu_id
    attr_accessible :id,:avatar,:project_info_id,:user_group_id,:password,:user_role_id,:email,:phone_number,:name,:nickname,:description
    attr_accessible :datetime,:height,:weight,:cnname,:sex,:admingroup,:integral,:push_apn_token,:push_android_token,:created_at,:birthday

end