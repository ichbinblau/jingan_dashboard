class UserSortInfo < ActiveRecord::Base


  attr_accessible  :char_value_0,:char_value_1,:char_value_2,:char_value_3,:char_value_4
  attr_accessible  :id,:valid_status,:user_sort_type_id,:user_info_id,:project_info_id


  belongs_to :user_info
  has_one :user_sort_type

  mount_uploader :img_0, UserImagesUploader
  mount_uploader :img_1, UserImagesUploader
  mount_uploader :img_2, UserImagesUploader
  mount_uploader :img_3, UserImagesUploader
  mount_uploader :img_4, UserImagesUploader

  attr_accessible :img_0, :img_0_cache, :remove_img_0
  attr_accessible :img_1, :img_1_cache, :remove_img_1
  attr_accessible :img_2, :img_2_cache, :remove_img_2
  attr_accessible :img_3, :img_3_cache, :remove_img_3
  attr_accessible :img_4, :img_4_cache, :remove_img_4

  attr_accessible :char_value_0,:char_value_1,:char_value_2,:char_value_3,:char_value_4





  rails_admin do
    visible false

  end




end
