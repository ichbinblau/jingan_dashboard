# encoding: utf-8
require "resque"
require 'mqtt'
class CmsContent < ActiveRecord::Base
  validates :cms_sorts,  :presence => { :message => "不能为空" }
  validates :project_info_id,  :presence => { :message => "不能为空" }
  validates :title,  :presence => { :message => "不能为空" }

  mount_uploader :image_cover, UserImagesUploader
  mount_uploader :video_url, FileUploader
  attr_accessible :image_cover, :image_cover_cache , :remove_image_cover, :video_url ,:video_url_cache, :remove_video_url ,:baidu_gps_point,:baidu_longitude,:baidu_latitude,:created_at

  # has_one :cms_info_activity,:dependent => :destroy,:inverse_of => :cms_content
  has_many :cms_content_img
  attr_accessible :cms_content_img_attributes , :cms_content_img_ids
  accepts_nested_attributes_for :cms_content_img, :allow_destroy => true

  has_and_belongs_to_many :cms_sorts
  attr_accessible :cms_sorts_attributes,:cms_sort_ids
  accepts_nested_attributes_for :cms_sorts, :allow_destroy => true

  has_and_belongs_to_many :sys_location_infos
  attr_accessible :sys_location_infos_attributes,:sys_location_info_ids
  accepts_nested_attributes_for :sys_location_infos

  has_many :cms_content_comment, :dependent => :destroy, :inverse_of => :cms_content,:limit =>10
  # accepts_nested_attributes_for :cms_content_comment, :allow_destroy => true
  # attr_accessible :cms_content_comment_attributes, :allow_destroy => true ,cms_content_comment_ids

  belongs_to :user_info
  # has_one :user_info
  attr_accessible :user_info_id

  belongs_to :project_info
  attr_accessible :project_info_id, :order_level , :title,:content , :cms_content_img , :is_push , :is_pushed , :abstract , :is_bigimage , :is_show
  attr_accessible :comment_count , :images_count , :up_count , :down_count ,:view_count , :vote_count , :vote_all , :vote_result , :order_count
  attr_accessible :start_flag , :end_flag

  # 设置收藏
  has_many :cms_content_favs


  # 设置gps point数据类型
  self.rgeo_factory_generator = RGeo::Geos.method(:factory)
  set_rgeo_factory_for_column(:baidu_gps_point, RGeo::Geographic.spherical_factory)

  def cms_sorts_options
      opts = []
      self.cms_sorts.each do |option|
        opts << option.id.to_s
      end
      opts
  end


  #android推送
  def android_push
    args = {}
    appinfo = ProjectApp.select("id").where(:project_info_id =>self.project_info_id);
    # contents
    args[:title] = self.title
    args[:contentid] = self.id
    args[:des] = self.abstract
    # users
    users = UserInfo.select("push_android_token").where("project_info_id=#{self.project_info_id} and push_android_token!=''");
    users.each do |user|
      args[:token] = user.push_android_token
      Rails.logger.info("eclogger:push_android_token:"+user.push_android_token)
      Resque.enqueue(PushAndroid, args)
    end
    puts args
  end


  def apn_push
    # 苹果apn推送服务
    # puts "setup_cafterinfo......................................................................"
    args = {}
    appinfo = ProjectApp.select("id ,apn_sandbox_key").where(:project_info_id =>self.project_info_id);
    args[:pem] = "public/uploads/project_app/apn_sandbox_key/"+appinfo[0][:id].to_s+"/"+appinfo[0][:apn_sandbox_key].to_s
    # contents
    args[:title] = self.title
    args[:contentid] = self.id
    args[:des] = self.abstract
    # users
    users = UserInfo.select("push_apn_token").where("project_info_id=#{self.project_info_id} and push_apn_token!=''");
    users.each do |user|
      args[:token] = user.push_apn_token
      Resque.enqueue(PushApn, args)
      puts args
    end
    # users = ;
  end

  rails_admin do
    visible false
    list do
      field :cms_sorts
      field :sys_location_infos
      field :title
      field :project_info
    end
    edit do
      field :baidu_gps_point , :string
    end
  end
end
