# encoding: utf-8
class MessageContent < ActiveRecord::Base
  mount_uploader :image, UserImagesUploader
  mount_uploader :sound, FileUploader

  belongs_to :project_info
  attr_accessible :project_info_id,:room_name, :msg_type, :sender_id, :sender_name, :receiver_id, :receiver_name , :sender_avatar\
                  ,:image , :sound , :content

  rails_admin do
    visible false
  end
end
