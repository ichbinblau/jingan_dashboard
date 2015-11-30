# encoding: utf-8

class CmsContentComment < ActiveRecord::Base

	belongs_to :cms_content, :inverse_of => :cms_content_comment
  belongs_to :user_info
  has_many :cms_content_img,:foreign_key => "cms_content_id",:class_name => "CmsContentImg"

  #mount_uploader :image_cover, UserImagesUploader
	attr_accessible :title,:content,:typenum,:admin_reply, :vote_star,:nick_name,:longitude,:latitude ,:cms_sort_type_id ,:to_user_id

  @@vote_star_dic =
      {
          "1"=>
              {
                  "name"=> "",
                  "text"=> "缺少配件",
                  "value"=> "1"
              },
          "2"=>{
              "name"=> "",
              "text"=> "配件损坏",
              "value"=> "2"
          },
          "3" =>
              {
                  "name"=> "",
                  "text"=> "器材无法使用",
                  "value"=> "3"
              },
          "4"=> {
              "name"=> "",
              "text"=> "请选择设备问题",
              "value"=> "4"
          }
      }

  def vote_star_text

     if !self.vote_star.nil?  && !(item = @@vote_star_dic[self.vote_star.to_s]).nil?
       text = item["text"]
     end
      text
  end



  rails_admin do
    navigation_label '用户'
    weight 1

  end

end


  # `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '编号',
  # `project_info_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '外键-app',
  # `user_info_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '外键-用户',
  # `cms_sort_type_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '外键-内容类型',
  # `cms_content_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '外键-内容',
  # `title` varchar(200) NOT NULL DEFAULT '' COMMENT '标题',
  # `content` text NOT NULL COMMENT '内容',
  # `image_cover` varchar(100) NOT NULL DEFAULT '' COMMENT '封面图片',
  # `vote_star` tinyint(2) unsigned NOT NULL DEFAULT '0' COMMENT '评分',
  # `nick_name` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  # `longitude` varchar(20) NOT NULL DEFAULT '' COMMENT '经度',
  # `latitude` varchar(20) NOT NULL DEFAULT '' COMMENT '纬度',
  # `created_at` datetime NOT NULL DEFAULT '2000-01-01 00:00:00' COMMENT '创建时间',
  # `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
