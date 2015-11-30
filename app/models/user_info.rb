# encoding: utf-8
class UserInfo < ActiveRecord::Base
    mount_uploader :avatar, UserImagesUploader
    belongs_to :project_info
    has_many :kf_course_user_fav , class_name: "Kf::CourseUserFav" , foreign_key: "user_info_id"
    has_many :kf_diary , class_name: "Kf::Diary" , foreign_key: "user_info_id"
    has_many :cms_info_customers, :inverse_of => :user_info
    has_many :cms_content_comments
    has_many :cms_content
    has_many :form_info
    has_and_belongs_to_many :user_groups

    # 设置收藏
    has_many :cms_content_favs
    has_many :cms_content , through: :cms_content_favs


    attr_accessible :user_info_id
    has_many :act_status, :inverse_of => :user_info

    attr_accessible :act_statu_id
    attr_accessible :id,:avatar,:project_info_id,:user_group_id,:password,:user_role_id,:email,:phone_number,:name,:nickname,:description
    attr_accessible :datetime,:height,:weight,:cnname,:sex,:admingroup,:integral,:push_apn_token,:push_android_token,:created_at,:birthday

    has_and_belongs_to_many :from_id, class_name: "UserInfo", foreign_key: "to_id", join_table: "user_favs", association_foreign_key: "from_id"
    attr_accessible :to_ids_attributes, :to_id_ids
    has_and_belongs_to_many :to_id, class_name: "UserInfo", foreign_key: "from_id", join_table: "user_favs", association_foreign_key: "to_id"
    attr_accessible :from_ids_attributes, :from_id_ids

    rails_admin do
        navigation_label '用户'
        weight 2
    end
end
