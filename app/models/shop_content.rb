# encoding: utf-8
class ShopContent < CmsContent
  has_one :cms_info_shop,:foreign_key => "cms_content_id",:dependent => :destroy
  attr_accessible :product_contents,:coupon_contents,:news_contents

  attr_accessible :cms_info_shop_id, :cms_info_shop_attributes
  accepts_nested_attributes_for :cms_info_shop, :allow_destroy => true

  has_many :cms_info_schedules, :inverse_of => :shop_content
  has_many :act_buy_order


  acts_as_mappable  :default_units => :kms,
                    :distance_field_name => :distance,
                   :lat_column_name => :baidu_latitude,
                   :lng_column_name => :baidu_longitude
  attr_accessible :distance

  has_and_belongs_to_many :product_contents
  attr_accessible :product_contents_attributes,:product_content_ids
  accepts_nested_attributes_for :product_contents , :allow_destroy => true

  has_and_belongs_to_many :coupon_contents
  attr_accessible :coupon_contents_attributes,:coupon_content_ids
  accepts_nested_attributes_for :coupon_contents , :allow_destroy => true

  has_and_belongs_to_many :news_contents
  attr_accessible :news_contents_attributes,:news_content_ids
  accepts_nested_attributes_for :news_contents , :allow_destroy => true

  # has_one :cms_info_schedule,:foreign_key => "cms_info_shop_id",:dependent => :destroy

  # attr_accessible :cms_info_schedule_id, :cms_info_schedule_attributes
  # accepts_nested_attributes_for :cms_info_schedule, :allow_destroy => true
  # has_one :cms_info_shop,:foreign_key => "cms_content_id",:dependent => :destroy #,:as => :cms_content
  # belongs_to :cms_content_info, :polymorphic => true, :inverse_of => :activity_content
  # attr_accessible :cms_info_shop_id, :cms_info_shop_attributes
  # accepts_nested_attributes_for :cms_info_shop, :allow_destroy => true

  # belongs_to :cms_sorts , :polymorphic => true, :inverse_of => :comments


  # attr_accessible :cms_sorts_attributes,:cms_sort_ids

  before_save :setup_beforeinfo
  after_save :setup_afterinfo
  after_create :create_contentid
  protected
    def setup_beforeinfo
      shopid=self.cms_info_shop.id
      self.cms_sort_type_id=8
      # Rails.logger.info("eclogger: "+shopid.to_s)
      self.cms_content_info_id = shopid
      # 修改content中的gps信息

      if !self.cms_info_shop.baidu_latitude.blank?
        self.baidu_gps_point = "POINT(#{self.cms_info_shop.baidu_longitude.to_f.round(7).to_s} #{self.cms_info_shop.baidu_latitude.to_f.round(7).to_s})"
      else
        self.baidu_gps_point = "POINT(0 0)"      
      end
      if !self.cms_info_shop.baidu_longitude.blank?
        self.baidu_longitude = self.cms_info_shop.baidu_longitude
      end
      if !self.cms_info_shop.baidu_latitude.blank?
        self.baidu_latitude = self.cms_info_shop.baidu_latitude
      end
    end

    def setup_afterinfo

      # 添加推送
      ispush=self.is_push
      contentid=self.id
      if ispush==true
        # 查询推送记录表中是否有该推送记录
        pushinfo=SysPushOrder.where("cms_content_id = ? ",contentid.to_s )
        # 循环分类
        if pushinfo.blank?
          for sorts in self.cms_sorts do
              pushorder = SysPushOrder.new()
              pushorder.cms_content_id=contentid
              pushorder.project_info_id=self.project_info_id
              pushorder.cms_sort_id=sorts.id
              pushorder.cms_content_title=self.title
              t = Time.new
              date = t.strftime("%Y-%m-%d %H:%M:%S")
              pushorder.updatetime=date
              pushorder.pushtype="content"
              pushorder.save
            end
          end
        end
      end
      def create_contentid
        self.save
      end

      rails_admin do
        list do
          field :cms_sorts
          field :title
          field :id
          field :cms_sort_type_id
          field :type
          field :user_info_id
          field :project_info
          field :user_info_id
        end
        field :cms_sorts do
          nested_form false
        end
        field :sys_location_infos do
          nested_form false
        end
        include_all_fields
        exclude_fields :baidu_gps_point , :baidu_longitude, :baidu_latitude
        navigation_label '内容'
        weight 1
      end
    end
    # class NewsSort < CmsSort
    #     has_and_belongs_to_many :NewsContent ,:association_foreign_key =>"cms_content_id" ,:class_name =>"CmsContent"
    #     rails_admin do
    #       visible false
    #     end
    # end
